import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:cembostyle/core/network/api_client.dart';
import 'package:cembostyle/core/network/constants/api_constants.dart';
import 'package:cembostyle/core/services/download_notification_service.dart';
import 'package:cembostyle/moduls/stencil/presentation/utils/stencil_tint_filter.dart';
import '../data/stencil_dummy_data.dart';
import '../models/stencil_models.dart';

class StencilController extends GetxController {
  StencilController();

  final ApiClient _apiClient = Get.find<ApiClient>();
  final DownloadNotificationService _downloadNotificationService =
      DownloadNotificationService();
  final ImagePicker _picker = ImagePicker();
  final Map<String, StencilRecord> _generatedStencilCache = {};
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

  int get tattooBlackGreyThemeIndex {
    final index = colorThemes.indexWhere(
      (theme) => theme.id == 'tattoo_black_grey',
    );
    return index >= 0 ? index : 0;
  }

  ColorFilter? get activePreviewColorFilter {
    final record = activeStencil.value;

    if (record == null || record.themeRenderMode != ThemeRenderMode.localTint) {
      return null;
    }

    return buildLocalTintColorFilter(selectedColorTheme);
  }

  ColorFilter get customizePreviewColorFilter => buildAdjustmentColorFilter(
        brightness: brightness.value,
        contrast: contrast.value,
      )!;

  String get activeGeneratedPreviewUrl {
    final record = activeStencil.value;
    if (record == null) {
      return samples.first.resultUrl;
    }

    final previewUrl = record.previewImageUrl;
    if (previewUrl.isNotEmpty) {
      return previewUrl;
    }

    return samples.first.resultUrl;
  }

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
    _cacheRecordVariants(record);
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

  Future<bool> generateStencil({
    bool useAdjustedSource = false,
    bool forceTattooBlackGrey = false,
  }) async {
    if (forceTattooBlackGrey) {
      selectedColorThemeIndex.value = tattooBlackGreyThemeIndex;
    }

    final requestKey = _buildRequestCacheKey();
    final cachedRecord = _generatedStencilCache[requestKey];
    if (cachedRecord != null) {
      activeStencil.value = cachedRecord;
      compareValue.value = 0.55;
      _syncSelectedOptions(cachedRecord);
      return true;
    }

    final sourceFile = await _createSourceFile(
      useAdjustedSource: useAdjustedSource,
    );
    final activeRecord = activeStencil.value;
    final hasExistingOriginal = activeRecord?.originalImageUrl.isNotEmpty == true;

    if (sourceFile == null && !hasExistingOriginal) {
      generationError.value =
          'Select an image first or open a stencil with an original image to regenerate.';
      Get.snackbar('Stencil', generationError.value);
      return false;
    }

    generationError.value = '';
    isGenerating.value = true;

    final formData = dio.FormData.fromMap({
      if (sourceFile != null) 'file': sourceFile,
      if (!useAdjustedSource && hasExistingOriginal)
        'originalImage': jsonEncode({
          'url': activeRecord!.originalImageUrl,
        }),
      'style': selectedStyle.title,
      'styleId': selectedStyle.id,
      'colorTheme': selectedColorTheme.title,
      'colorThemeId': selectedColorTheme.id,
      'detailLevel': selectedDetailLevel.value,
      'brightness': brightness.value,
      'contrast': contrast.value,
    });

    final result = await _apiClient.post<StencilRecord>(
      endpoint: ApiConstants.stencil.create,
      formData: formData,
      options: dio.Options(
        sendTimeout: null,
        receiveTimeout: null,
      ),
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
        _cacheRecordVariants(record);
        await fetchRecentActivities();
        return true;
      },
    );
  }

  Future<bool> updateSelectedTheme(int index) async {
    if (index < 0 || index >= colorThemes.length) {
      return false;
    }

    if (selectedColorThemeIndex.value == index) {
      return true;
    }

    selectedColorThemeIndex.value = index;

    final requestKey = _buildRequestCacheKey();
    final cached = _generatedStencilCache[requestKey];
    if (cached != null) {
      activeStencil.value = cached;
      return true;
    }

    final record = activeStencil.value;
    if (record != null &&
        record.themeRenderMode == ThemeRenderMode.localTint &&
        selectedColorTheme.isLocalTintEligible) {
      final updated = record.copyWith(
        colorTheme: selectedColorTheme.title,
        colorThemeId: selectedColorTheme.id,
        themeRenderMode: ThemeRenderMode.localTint,
      );
      activeStencil.value = updated;
      _generatedStencilCache[requestKey] = updated;
      return true;
    }

    return generateStencil();
  }

  bool canApplyThemeInstantly(int index) {
    if (index < 0 || index >= colorThemes.length) {
      return false;
    }

    final theme = colorThemes[index];
    final requestKey = [
      _buildSourceCacheKey(),
      selectedStyle.id,
      theme.id,
      selectedDetailLevel.value,
      brightness.value.toStringAsFixed(2),
      contrast.value.toStringAsFixed(2),
    ].join('::');

    if (_generatedStencilCache.containsKey(requestKey)) {
      return true;
    }

    final record = activeStencil.value;
    return record != null &&
        record.themeRenderMode == ThemeRenderMode.localTint &&
        theme.isLocalTintEligible;
  }

  Future<bool> updateSelectedDetailLevel(int value) async {
    final clamped = value.clamp(0, 2);
    if (selectedDetailLevel.value == clamped) {
      return true;
    }

    selectedDetailLevel.value = clamped;
    return generateStencil();
  }

  Future<void> shareActiveStencil() async {
    final record = activeStencil.value;
    final url = record?.previewImageUrl ?? '';
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
    final url = record?.previewImageUrl ?? '';
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
        _cacheRecordVariants(success.data);
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
    await downloadActiveStencil('pdf');
  }

  Future<void> downloadActiveStencil(String format) async {
    final record = activeStencil.value;
    final url = record?.previewImageUrl ?? '';
    if (url.isEmpty) {
      Get.snackbar('Download', 'There is no generated stencil to download yet.');
      return;
    }

    if (isDownloadingPdf.value) {
      return;
    }

    isDownloadingPdf.value = true;

    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final baseFileName = 'cembostyle_stencil_$timestamp';
      final normalizedFormat = format.toLowerCase();

      if (normalizedFormat == 'pdf') {
        final pdfBytes = await _buildPrintablePdfBytes();
        final filePath = await _saveExportToDownloads(
          bytes: pdfBytes,
          fileName: baseFileName,
          extension: 'pdf',
        );
        await _downloadNotificationService.showDownloadCompleteNotification(
          title: 'Download complete',
          body: 'Tap to open your A4 PDF.',
          filePath: filePath,
        );
        Get.snackbar(
          'Download complete',
          'Printable A4 PDF saved to $filePath',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );
      } else {
        final encodedBytes = await _buildDownloadImageBytes(
          format: normalizedFormat,
        );
        if (encodedBytes == null || encodedBytes.isEmpty) {
          throw Exception('Could not prepare the stencil image.');
        }

        final extension = normalizedFormat == 'jpeg' ? 'jpg' : normalizedFormat;
        final filePath = await _saveExportToDownloads(
          bytes: encodedBytes,
          fileName: baseFileName,
          extension: extension,
        );
        await _downloadNotificationService.showDownloadCompleteNotification(
          title: 'Download complete',
          body: 'Tap to open your ${extension.toUpperCase()} file.',
          filePath: filePath,
        );

        Get.snackbar(
          'Download complete',
          'Saved $extension file to $filePath',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );
      }
    } catch (error) {
      Get.snackbar('Download', 'Could not create the PDF. $error');
    } finally {
      isDownloadingPdf.value = false;
    }
  }

  Future<Uint8List> _buildPrintablePdfBytes() async {
    final pdf = pw.Document();
    final imageBytes = await _buildDownloadImageBytes(format: 'png');
    if (imageBytes == null || imageBytes.isEmpty) {
      throw Exception('Could not download the stencil image.');
    }

    final image = pw.MemoryImage(imageBytes);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (context) {
          return pw.Center(
            child: pw.Image(
              image,
              fit: pw.BoxFit.contain,
            ),
          );
        },
      ),
    );

    return Uint8List.fromList(await pdf.save());
  }

  Future<Uint8List?> _buildDownloadImageBytes({
    required String format,
  }) async {
    final record = activeStencil.value;
    final url = record?.previewImageUrl ?? '';
    final sourceBytes = await _downloadBytes(url);
    if (sourceBytes == null || sourceBytes.isEmpty) {
      return null;
    }

    final decodedImage = img.decodeImage(sourceBytes);
    if (decodedImage == null) {
      return sourceBytes;
    }

    final workingImage = img.bakeOrientation(decodedImage);
    final exportedImage = record?.themeRenderMode == ThemeRenderMode.localTint
        ? _applyLocalTintToImage(workingImage)
        : workingImage;

    switch (format) {
      case 'jpeg':
      case 'jpg':
        return Uint8List.fromList(img.encodeJpg(exportedImage, quality: 96));
      case 'png':
      default:
        return Uint8List.fromList(img.encodePng(exportedImage));
    }
  }

  img.Image _applyLocalTintToImage(img.Image source) {
    final tintedImage = img.Image.from(source);
    final tint = selectedColorTheme.accentColor;
    final tintRed = tint.r.clamp(0.0, 1.0);
    final tintGreen = tint.g.clamp(0.0, 1.0);
    final tintBlue = tint.b.clamp(0.0, 1.0);

    for (final pixel in tintedImage) {
      final luminance = (pixel.rNormalized * 0.2126) +
          (pixel.gNormalized * 0.7152) +
          (pixel.bNormalized * 0.0722);

      pixel
        ..rNormalized = (tintRed + (1 - tintRed) * luminance).clamp(0.0, 1.0)
        ..gNormalized = (tintGreen + (1 - tintGreen) * luminance).clamp(0.0, 1.0)
        ..bNormalized = (tintBlue + (1 - tintBlue) * luminance).clamp(0.0, 1.0);
    }

    return tintedImage;
  }

  Future<dio.MultipartFile?> _createSourceFile({
    bool useAdjustedSource = false,
  }) async {
    final localFile = selectedImageFile.value;
    if (localFile != null) {
      if (useAdjustedSource) {
        return _createAdjustedMultipartFile(
          bytes: await localFile.readAsBytes(),
          filename: localFile.path.split('/').last,
        );
      }

      return dio.MultipartFile.fromFile(
        localFile.path,
        filename: localFile.path.split('/').last,
      );
    }

    if (useAdjustedSource) {
      final originalUrl = activeStencil.value?.originalImageUrl ?? '';
      if (originalUrl.isEmpty) {
        return null;
      }

      final bytes = await _downloadBytes(originalUrl);
      if (bytes == null || bytes.isEmpty) {
        return null;
      }

      return _createAdjustedMultipartFile(
        bytes: bytes,
        filename: Uri.tryParse(originalUrl)?.pathSegments.last ?? 'stencil-source.jpg',
      );
    }

    return null;
  }

  Future<dio.MultipartFile?> _createAdjustedMultipartFile({
    required Uint8List bytes,
    required String filename,
  }) async {
    final decodedImage = img.decodeImage(bytes);
    if (decodedImage == null) {
      return null;
    }

    final adjustedImage = img.adjustColor(
      img.bakeOrientation(decodedImage),
      brightness: brightness.value.clamp(0.0, 2.0),
      contrast: contrast.value.clamp(0.0, 2.0),
    );

    final encodedBytes = Uint8List.fromList(img.encodePng(adjustedImage));
    final tempDirectory = await getTemporaryDirectory();
    final baseName = filename.split('.').first;
    final tempFile = File(
      '${tempDirectory.path}/${baseName}_adjusted_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    await tempFile.writeAsBytes(encodedBytes, flush: true);

    return dio.MultipartFile.fromFile(
      tempFile.path,
      filename: '${baseName}_adjusted.png',
    );
  }

  Future<String> _saveExportToDownloads({
    required Uint8List bytes,
    required String fileName,
    required String extension,
  }) async {
    final tempDirectory = await getTemporaryDirectory();
    final tempFile = File('${tempDirectory.path}/$fileName.$extension');
    await tempFile.writeAsBytes(bytes, flush: true);

    return _downloadNotificationService.saveFileToDownloads(
      sourceFile: tempFile,
      fileName: fileName,
      extension: extension,
    );
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

  String _buildSourceCacheKey() {
    final localFile = selectedImageFile.value;
    if (localFile != null) {
      return 'file:${localFile.path}';
    }

    final record = activeStencil.value;
    if (record != null) {
      if (record.sourceFingerprint.isNotEmpty) {
        return 'fingerprint:${record.sourceFingerprint}';
      }
      if (record.originalImageUrl.isNotEmpty) {
        return 'original:${record.originalImageUrl}';
      }
    }

    return 'sample:${samples.first.originalUrl}';
  }

  String _buildRequestCacheKey() {
    return [
      _buildSourceCacheKey(),
      selectedStyle.id,
      selectedColorTheme.id,
      selectedDetailLevel.value,
      brightness.value.toStringAsFixed(2),
      contrast.value.toStringAsFixed(2),
    ].join('::');
  }

  void _cacheRecordVariants(StencilRecord record) {
    final baseKey = [
      record.sourceFingerprint.isNotEmpty
          ? 'fingerprint:${record.sourceFingerprint}'
          : 'original:${record.originalImageUrl}',
      record.styleId.isNotEmpty ? record.styleId : selectedStyle.id,
      record.colorThemeId.isNotEmpty ? record.colorThemeId : selectedColorTheme.id,
      record.detailLevel,
      record.brightness.toStringAsFixed(2),
      record.contrast.toStringAsFixed(2),
    ].join('::');

    _generatedStencilCache[baseKey] = record;

    if (record.themeRenderMode != ThemeRenderMode.localTint) {
      return;
    }

    for (final theme in colorThemes.where((theme) => theme.isLocalTintEligible)) {
      final key = [
        record.sourceFingerprint.isNotEmpty
            ? 'fingerprint:${record.sourceFingerprint}'
            : 'original:${record.originalImageUrl}',
        record.styleId.isNotEmpty ? record.styleId : selectedStyle.id,
        theme.id,
        record.detailLevel,
        record.brightness.toStringAsFixed(2),
        record.contrast.toStringAsFixed(2),
      ].join('::');

      _generatedStencilCache[key] = record.copyWith(
        colorTheme: theme.title,
        colorThemeId: theme.id,
        themeRenderMode: ThemeRenderMode.localTint,
      );
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
      thumbnailUrl: record.previewImageUrl.isNotEmpty
          ? record.previewImageUrl
          : record.originalImageUrl,
      styleName: record.style,
      originalImageUrl: record.originalImageUrl,
      stencilImageUrl: record.stencilImageUrl,
      baseStencilImageUrl: record.baseStencilImageUrl,
      status: record.status,
      errorMessage: record.errorMessage,
      colorTheme: record.colorTheme,
      colorThemeId: record.colorThemeId,
      themeRenderMode: record.themeRenderMode,
      detailLevel: record.detailLevel,
      isSaved: record.isSaved,
    );
  }

  void _syncSelectedOptions(StencilRecord record) {
    final styleIndex = stencilStyles.indexWhere(
      (style) => style.id == record.styleId || style.title == record.style,
    );
    if (styleIndex >= 0) {
      selectedStyleIndex.value = styleIndex;
    }

    final themeIndex = colorThemes.indexWhere(
      (theme) =>
          theme.id == record.colorThemeId || theme.title == record.colorTheme,
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
