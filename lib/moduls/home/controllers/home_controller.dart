import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:cembostyle/core/network/api_client.dart';
import 'package:cembostyle/core/network/constants/api_constants.dart';
import 'package:cembostyle/moduls/stencil/models/stencil_models.dart'
    show StencilRecord;
import '../data/home_dummy_data.dart';
import '../models/home_models.dart';

class HomeController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();
  String _activeGalleryCategory = '';

  final RxInt bottomNavIndex = 0.obs;
  final RxInt selectedCategoryIndex = 0.obs;
  final RxInt selectedPlanIndex = 0.obs;
  final RxInt selectedColorThemeIndex = 0.obs;
  final RxInt selectedDetailLevel = 1.obs;
  final RxDouble compareValue = 0.55.obs;
  final RxBool hasActivePlan = false.obs;
  final RxBool isGalleryLoading = false.obs;
  final RxString galleryError = ''.obs;
  final RxBool isRecentActivityLoading = false.obs;
  final RxString recentActivityError = ''.obs;

  final RxList<GalleryItem> galleryItems = <GalleryItem>[].obs;
  final RxList<ActivityItem> recentActivities = <ActivityItem>[].obs;

  List<CategoryItem> get categories => HomeDummyData.categories;
  List<PlanOption> get plans => HomeDummyData.plans;
  List<ColorThemeOption> get colorThemes => HomeDummyData.colorThemes;

  @override
  void onInit() {
    super.onInit();
    if (categories.isNotEmpty) {
      fetchGalleryByCategory(categories.first.title);
    }
    fetchRecentActivities();
  }

  void setBottomNav(int index) => bottomNavIndex.value = index;

  void setActivePlan(bool value) => hasActivePlan.value = value;

  void updateCompare(double value) {
    compareValue.value = value.clamp(0.05, 0.95);
  }

  void selectCategory(int index) {
    if (index == selectedCategoryIndex.value) return;
    selectedCategoryIndex.value = index;
    final category = categories[index].title;
    fetchGalleryByCategory(category);
  }

  Future<void> refreshGallery() async {
    if (categories.isEmpty) return;
    final category = categories[selectedCategoryIndex.value].title;
    await fetchGalleryByCategory(category);
  }

  Future<void> fetchGalleryByCategory(String category) async {
    _activeGalleryCategory = category;
    galleryError.value = '';
    isGalleryLoading.value = true;
    galleryItems.clear();

    final result = await _apiClient.get<List<GalleryItem>>(
      endpoint: ApiConstants.gallery.byCategory(category),
      fromJsonT: (json) {
        if (json is! List) return <GalleryItem>[];
        return json
            .whereType<Map<String, dynamic>>()
            .map(GalleryItem.fromApi)
            .toList();
      },
    );

    result.fold(
      (failure) {
        if (_activeGalleryCategory != category) return;
        galleryError.value = failure.message;
      },
      (success) {
        if (_activeGalleryCategory != category) return;
        galleryItems.assignAll(success.data);
      },
    );

    if (_activeGalleryCategory == category) {
      isGalleryLoading.value = false;
    }
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
        recentActivities.assignAll(records.map(_mapToActivityItem));
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

  ActivityItem _mapToActivityItem(StencilRecord record) {
    return ActivityItem(
      id: record.id,
      title: _buildTitle(record.status),
      style: _buildStyleLabel(record.style, record.status),
      date: _formatDate(record.createdAt),
      thumbnailUrl: record.originalImageUrl.isNotEmpty
          ? record.originalImageUrl
          : record.stencilImageUrl,
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
