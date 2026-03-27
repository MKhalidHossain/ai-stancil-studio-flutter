import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:cembostyle/core/network/api_client.dart';
import 'package:cembostyle/core/network/constants/api_constants.dart';
import '../data/stencil_dummy_data.dart';
import '../models/stencil_models.dart';

class StencilController extends GetxController {
  StencilController();

  final ApiClient _apiClient = Get.find<ApiClient>();
  final ImagePicker _picker = ImagePicker();
  bool _hasLoadedLibrary = false;

  final RxInt selectedStyleIndex = 0.obs;
  final RxInt selectedColorThemeIndex = 0.obs;
  final RxInt selectedDetailLevel = 1.obs;
  final RxDouble compareValue = 0.55.obs;
  final RxDouble brightness = 0.8.obs;
  final RxDouble contrast = 0.6.obs;
  final RxBool isRecentActivityLoading = false.obs;
  final RxBool isGenerating = false.obs;
  final RxBool isSavingToGallery = false.obs;
  final RxBool isDownloadingPdf = false.obs;
  final RxString recentActivityError = ''.obs;
  final RxString generationError = ''.obs;

  final Rxn<File> selectedImageFile = Rxn<File>();
  final Rxn<StencilRecord> activeStencil = Rxn<StencilRecord>();
  final RxList<StencilActivityItem> recentActivities =
      <StencilActivityItem>[].obs;

  List<StencilStyleOption> get stencilStyles => StencilDummyData.stencilStyles;
  List<ColorThemeOption> get colorThemes => StencilDummyData.colorThemes;
  List<StencilSampleImage> get samples => StencilDummyData.samples;

  StencilStyleOption get selectedStyle => stencilStyles[selectedStyleIndex.value];
  ColorThemeOption get selectedColorTheme =>
      colorThemes[selectedColorThemeIndex.value];

  Future<void> ensureLoaded() async {
    if (_hasLoadedLibrary) {
      return;
    }

    _hasLoadedLibrary = true;
    await fetchRecentActivities();
  }

  Future<bool> pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 92,
        maxWidth: 2048,
      );

      if (picked == null) {
        return false;
      }

      selectedImageFile.value = File(picked.path);
      activeStencil.value = null;
      generationError.value = '';
      compareValue.value = 0.55;
      return true;
    } catch (error) {
      Get.snackbar('Image', 'Could not pick the image. $error');
      return false;
    }
  }

  void updateCompare(double value) {
    compareValue.value = value.clamp(0.05, 0.95);
  }

  void applyStencilRecord(StencilRecord record) {
    activeStencil.value = record;
    generationError.value = '';
    selectedImageFile.value = null;
    _syncSelectedOptions(record);
  }

  Future<void> refreshRecentActivities() async {
    await fetchRecentActivities();
  }

  Future<void> fetchRecentActivities() async {
    recentActivityError.value = '';
    isRecentActivityLoading.value = true;

    final result = await _apiClient.get<List<StencilRecord>>(
      endpoint: ApiConstants.stencil.getMyAllStencils,
      fromJsonT: (json) {
        if (json is! List) {
          return <StencilRecord>[];
        }

        return json
            .whereType<Map<String, dynamic>>()
            .map(StencilRecord.fromApi)
            .toList();
      },
    );

    result.fold(
      (failure) {
        recentActivityError.value = failure.message;
      },
      (success) {
        final records = success.data.toList();
        records.sort(_compareByDateDesc);
        recentActivities.assignAll(records.map(_mapToStencilActivity));
      },
    );

    isRecentActivityLoading.value = false;
  }

  Future<bool> generateStencil() async {
    final sourceFile = await _createSourceFile();
    if (sourceFile == null) {
      generationError.value =
          'Select an image first or open a stencil with an original image to regenerate.';
      Get.snackbar('Stencil', generationError.value);
      return false;
    }

    generationError.value = '';
    isGenerating.value = true;

    final formData = dio.FormData.fromMap({
      'file': sourceFile,
      'style': selectedStyle.title,
      'colorTheme': selectedColorTheme.title,
      'detailLevel': selectedDetailLevel.value,
      'brightness': brightness.value,
      'contrast': contrast.value,
    });

    final result = await _apiClient.post<StencilRecord>(
      endpoint: ApiConstants.stencil.create,
      formData: formData,
      fromJsonT: (json) => StencilRecord.fromApi(json as Map<String, dynamic>),
    );

    isGenerating.value = false;

    return result.fold(
      (failure) {
        generationError.value = failure.message;
        Get.snackbar('Stencil', failure.message);
        return false;
      },
      (success) async {
        final record = success.data;
        activeStencil.value = record;
        compareValue.value = 0.55;
        _syncSelectedOptions(record);
        await fetchRecentActivities();
        return true;
      },
    );
  }

  Future<void> shareActiveStencil() async {
    final record = activeStencil.value;
    final url = record?.stencilImageUrl ?? '';
    if (url.isEmpty) {
      Get.snackbar('Share', 'There is no generated stencil to share yet.');
      return;
    }

    await SharePlus.instance.share(
      ShareParams(
        text: 'My Cembostyle stencil: $url',
      ),
    );
  }

  Future<void> openActiveStencilExternally() async {
    final record = activeStencil.value;
    final url = record?.stencilImageUrl ?? '';
    if (url.isEmpty) {
      Get.snackbar('Download', 'There is no generated stencil to open yet.');
      return;
    }

    final launched = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      Get.snackbar('Download', 'Could not open the stencil image.');
    }
  }

  Future<void> markAsSaved() async {
    final record = activeStencil.value;
    if (record == null) {
      Get.snackbar('Save', 'Generate a stencil before saving it.');
      return;
    }

    if (record.isSaved) {
      Get.snackbar(
        'Saved to My Stencils',
        'This stencil is already saved in My Stencils.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (isSavingToGallery.value) {
      return;
    }

    isSavingToGallery.value = true;

    final result = await _apiClient.patch<StencilRecord>(
      endpoint: ApiConstants.stencil.byId(record.id),
      data: {'isSaved': true},
      fromJsonT: (json) => StencilRecord.fromApi(json as Map<String, dynamic>),
    );

    isSavingToGallery.value = false;

    result.fold(
      (failure) {
        Get.snackbar('Save', failure.message);
      },
      (success) async {
        activeStencil.value = success.data;
        await fetchRecentActivities();
        Get.snackbar(
          'Saved to My Stencils',
          'Your stencil has been added to My Stencils.',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  Future<void> downloadActiveStencilAsPdf() async {
    final record = activeStencil.value;
    final url = record?.stencilImageUrl ?? '';
    if (url.isEmpty) {
      Get.snackbar('Download', 'There is no generated stencil to download yet.');
      return;
    }

    if (isDownloadingPdf.value) {
      return;
    }

    isDownloadingPdf.value = true;

    try {
      final imageBytes = await _downloadBytes(url);
      if (imageBytes == null || imageBytes.isEmpty) {
        throw Exception('Could not download the stencil image.');
      }

      final pdf = pw.Document();
      final image = pw.MemoryImage(imageBytes);
      final styleLabel = record?.style.isNotEmpty == true
          ? record!.style
          : 'Tattoo Stencil';
      final themeLabel = record?.colorTheme.isNotEmpty == true
          ? record!.colorTheme
          : 'Printable reference';

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(28),
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                pw.Text(
                  'Cembostyle Stencil',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Text(
                  '$styleLabel • $themeLabel',
                  style: const pw.TextStyle(fontSize: 11),
                ),
                pw.SizedBox(height: 18),
                pw.Expanded(
                  child: pw.Center(
                    child: pw.Container(
                      width: PdfPageFormat.a4.availableWidth,
                      padding: const pw.EdgeInsets.all(16),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.grey400, width: 1),
                      ),
                      child: pw.Image(
                        image,
                        fit: pw.BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );

      final directory = await _resolvePdfDirectory();
      await directory.create(recursive: true);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${directory.path}/cembostyle_stencil_$timestamp.pdf');
      await file.writeAsBytes(await pdf.save(), flush: true);

      Get.snackbar(
        'Download complete',
        'Printable A4 PDF saved to ${file.path}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
    } catch (error) {
      Get.snackbar('Download', 'Could not create the PDF. $error');
    } finally {
      isDownloadingPdf.value = false;
    }
  }

  Future<dio.MultipartFile?> _createSourceFile() async {
    final localFile = selectedImageFile.value;
    if (localFile != null) {
      return dio.MultipartFile.fromFile(
        localFile.path,
        filename: localFile.path.split('/').last,
      );
    }

    final originalUrl = activeStencil.value?.originalImageUrl ?? '';
    if (originalUrl.isEmpty) {
      return null;
    }

    try {
      final response = await dio.Dio().get<List<int>>(
        originalUrl,
        options: dio.Options(responseType: dio.ResponseType.bytes),
      );
      final bytes = response.data;
      if (bytes == null || bytes.isEmpty) {
        return null;
      }

      final uri = Uri.tryParse(originalUrl);
      final lastSegment = uri != null && uri.pathSegments.isNotEmpty
          ? uri.pathSegments.last
          : 'stencil-source.jpg';
      final filename = lastSegment.contains('.')
          ? lastSegment
          : '$lastSegment.jpg';

      return dio.MultipartFile.fromBytes(bytes, filename: filename);
    } catch (_) {
      return null;
    }
  }

  Future<Directory> _resolvePdfDirectory() async {
    if (Platform.isAndroid) {
      final downloadDirectories = await getExternalStorageDirectories(
        type: StorageDirectory.downloads,
      );
      if (downloadDirectories != null && downloadDirectories.isNotEmpty) {
        return Directory('${downloadDirectories.first.path}/Cembostyle');
      }

      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        return Directory('${directory.path}/Cembostyle');
      }
    }

    final directory = await getApplicationDocumentsDirectory();
    return Directory('${directory.path}/Cembostyle');
  }

  Future<Uint8List?> _downloadBytes(String url) async {
    try {
      final response = await dio.Dio().get<List<int>>(
        url,
        options: dio.Options(responseType: dio.ResponseType.bytes),
      );
      final bytes = response.data;
      if (bytes == null || bytes.isEmpty) {
        return null;
      }
      return Uint8List.fromList(bytes);
    } catch (_) {
      return null;
    }
  }

  int _compareByDateDesc(StencilRecord a, StencilRecord b) {
    final aDate = _parseDate(a.createdAt);
    final bDate = _parseDate(b.createdAt);
    if (aDate == null && bDate == null) {
      return 0;
    }
    if (aDate == null) {
      return 1;
    }
    if (bDate == null) {
      return -1;
    }
    return bDate.compareTo(aDate);
  }

  StencilActivityItem _mapToStencilActivity(StencilRecord record) {
    return StencilActivityItem(
      id: record.id,
      title: _buildTitle(record.status),
      style: _buildStyleLabel(record.style, record.status),
      date: _formatDate(record.createdAt),
      thumbnailUrl: record.stencilImageUrl.isNotEmpty
          ? record.stencilImageUrl
          : record.originalImageUrl,
      styleName: record.style,
      originalImageUrl: record.originalImageUrl,
      stencilImageUrl: record.stencilImageUrl,
      status: record.status,
      errorMessage: record.errorMessage,
      colorTheme: record.colorTheme,
      detailLevel: record.detailLevel,
      isSaved: record.isSaved,
    );
  }

  void _syncSelectedOptions(StencilRecord record) {
    final styleIndex = stencilStyles.indexWhere(
      (style) => style.title == record.style,
    );
    if (styleIndex >= 0) {
      selectedStyleIndex.value = styleIndex;
    }

    final themeIndex = colorThemes.indexWhere(
      (theme) => theme.title == record.colorTheme,
    );
    if (themeIndex >= 0) {
      selectedColorThemeIndex.value = themeIndex;
    }

    selectedDetailLevel.value = record.detailLevel.clamp(0, 2);
    brightness.value = record.brightness.clamp(0.0, 1.0);
    contrast.value = record.contrast.clamp(0.0, 1.0);
  }

  String _buildTitle(String status) {
    if (status.isEmpty) {
      return 'Stencil created';
    }
    final label = _prettyStatus(status);
    return 'Stencil $label';
  }

  String _buildStyleLabel(String style, String status) {
    if (style.isEmpty && status.isEmpty) {
      return 'Stencil';
    }
    if (style.isEmpty) {
      return _prettyStatus(status);
    }
    final statusLabel = _prettyStatus(status);
    if (statusLabel.isEmpty) {
      return style;
    }
    return '$style • $statusLabel';
  }

  String _formatDate(String value) {
    final parsed = _parseDate(value);
    if (parsed == null) {
      return 'Unknown date';
    }
    return DateFormat('dd/MM/yyyy').format(parsed.toLocal());
  }

  DateTime? _parseDate(String value) {
    if (value.isEmpty) {
      return null;
    }
    return DateTime.tryParse(value);
  }

  String _prettyStatus(String status) {
    if (status.isEmpty) {
      return '';
    }
    return status
        .split('_')
        .where((part) => part.isNotEmpty)
        .map((part) {
          final lower = part.toLowerCase();
          return '${lower[0].toUpperCase()}${lower.substring(1)}';
        })
        .join(' ');
  }
}
