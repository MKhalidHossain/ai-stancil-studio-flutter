import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:cembostyle/core/network/api_client.dart';
import 'package:cembostyle/core/network/constants/api_constants.dart';
import '../data/stencil_dummy_data.dart';
import '../models/stencil_models.dart';

class StencilController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();
  final RxInt selectedStyleIndex = 0.obs;
  final RxInt selectedColorThemeIndex = 0.obs;
  final RxInt selectedDetailLevel = 1.obs;
  final RxDouble compareValue = 0.55.obs;
  final RxDouble brightness = 0.8.obs;
  final RxDouble contrast = 0.6.obs;
  final RxBool isRecentActivityLoading = false.obs;
  final RxString recentActivityError = ''.obs;

  final RxList<StencilActivityItem> recentActivities =
      <StencilActivityItem>[].obs;

  List<StencilStyleOption> get stencilStyles => StencilDummyData.stencilStyles;
  List<ColorThemeOption> get colorThemes => StencilDummyData.colorThemes;
  List<StencilSampleImage> get samples => StencilDummyData.samples;

  @override
  void onInit() {
    super.onInit();
    fetchRecentActivities();
  }

  void updateCompare(double value) {
    compareValue.value = value.clamp(0.05, 0.95);
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
        if (json is! List) return <StencilRecord>[];
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

  int _compareByDateDesc(StencilRecord a, StencilRecord b) {
    final aDate = _parseDate(a.createdAt);
    final bDate = _parseDate(b.createdAt);
    if (aDate == null && bDate == null) return 0;
    if (aDate == null) return 1;
    if (bDate == null) return -1;
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
    );
  }

  String _buildTitle(String status) {
    if (status.isEmpty) return 'Stencil created';
    final label = _prettyStatus(status);
    return 'Stencil $label';
  }

  String _buildStyleLabel(String style, String status) {
    if (style.isEmpty && status.isEmpty) return 'Stencil';
    if (style.isEmpty) return _prettyStatus(status);
    final statusLabel = _prettyStatus(status);
    if (statusLabel.isEmpty) return style;
    return '$style • $statusLabel';
  }

  String _formatDate(String value) {
    final parsed = _parseDate(value);
    if (parsed == null) return 'Unknown date';
    return DateFormat('dd/MM/yyyy').format(parsed.toLocal());
  }

  DateTime? _parseDate(String value) {
    if (value.isEmpty) return null;
    return DateTime.tryParse(value);
  }

  String _prettyStatus(String status) {
    if (status.isEmpty) return '';
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
