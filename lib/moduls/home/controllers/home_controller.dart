import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:cembostyle/core/network/api_client.dart';
import 'package:cembostyle/core/network/constants/api_constants.dart';
import 'package:cembostyle/moduls/stencil/models/stencil_models.dart'
    show StencilRecord;
import '../data/home_dummy_data.dart';
import '../models/home_models.dart';

class HomeController extends GetxController {
  HomeController();

  final ApiClient _apiClient = Get.find<ApiClient>();
  String _activeGalleryCategory = '';
  bool _hasLoadedDashboard = false;

  final RxInt bottomNavIndex = 0.obs;
  final RxInt selectedCategoryIndex = 0.obs;
  final RxInt selectedPlanIndex = 0.obs;
  final RxInt selectedColorThemeIndex = 0.obs;
  final RxInt selectedDetailLevel = 1.obs;
  final RxDouble compareValue = 0.55.obs;
  final RxBool hasActivePlan = false.obs;
  final RxBool isProfileLoading = false.obs;
  final RxBool isProfileSaving = false.obs;
  final RxBool isGalleryLoading = false.obs;
  final RxBool isGalleryPreviewLoading = false.obs;
  final RxBool isRecentActivityLoading = false.obs;
  final RxBool isCreatingCheckoutSession = false.obs;
  final RxString profileError = ''.obs;
  final RxString galleryError = ''.obs;
  final RxString galleryPreviewError = ''.obs;
  final RxString recentActivityError = ''.obs;

  final Rxn<UserProfile> profile = Rxn<UserProfile>();
  final Rxn<GalleryPreview> activeGalleryPreview = Rxn<GalleryPreview>();
  final RxList<GalleryItem> galleryItems = <GalleryItem>[].obs;
  final RxList<ActivityItem> recentActivities = <ActivityItem>[].obs;
  final Map<String, GalleryPreview> _galleryPreviewCache = {};

  List<CategoryItem> get categories => HomeDummyData.categories;
  List<PlanOption> get plans => HomeDummyData.plans;
  List<ColorThemeOption> get colorThemes => HomeDummyData.colorThemes;
  PlanOption get selectedPlan => plans[selectedPlanIndex.value];

  Future<void> ensureLoaded() async {
    if (_hasLoadedDashboard) {
      return;
    }

    _hasLoadedDashboard = true;
    await Future.wait([
      fetchUserProfile(),
      fetchGalleryByCategory(
        categories.isNotEmpty ? categories[selectedCategoryIndex.value].title : '',
      ),
      fetchRecentActivities(),
    ]);
  }

  Future<void> refreshDashboard() async {
    await Future.wait([
      fetchUserProfile(),
      refreshGallery(),
      fetchRecentActivities(),
    ]);
  }

  void setBottomNav(int index) => bottomNavIndex.value = index;

  void updateCompare(double value) {
    compareValue.value = value.clamp(0.05, 0.95);
  }

  void selectCategory(int index) {
    if (index == selectedCategoryIndex.value) {
      return;
    }

    selectedCategoryIndex.value = index;
    final category = categories[index].title;
    fetchGalleryByCategory(category);
  }

  Future<void> refreshGallery() async {
    if (categories.isEmpty) {
      return;
    }

    final category = categories[selectedCategoryIndex.value].title;
    await fetchGalleryByCategory(category);
  }

  Future<void> fetchUserProfile() async {
    profileError.value = '';
    isProfileLoading.value = true;

    final result = await _apiClient.get<UserProfile>(
      endpoint: ApiConstants.account.me,
      fromJsonT: (json) => UserProfile.fromApi(json as Map<String, dynamic>),
    );

    result.fold(
      (failure) {
        profileError.value = failure.message;
      },
      (success) {
        profile.value = success.data;
        hasActivePlan.value = success.data.isPremium;
      },
    );

    isProfileLoading.value = false;
  }

  Future<bool> updateProfile({
    required String name,
    required String email,
    String? imagePath,
  }) async {
    final trimmedName = name.trim();
    final trimmedEmail = email.trim();

    if (trimmedName.isEmpty || trimmedEmail.isEmpty) {
      Get.snackbar('Profile', 'Name and email are required.');
      return false;
    }

    isProfileSaving.value = true;
    profileError.value = '';

    final hasImage = imagePath != null && imagePath.trim().isNotEmpty;
    final profileImagePath = imagePath ?? '';

    final result = hasImage
        ? await _apiClient.patch<UserProfile>(
            endpoint: ApiConstants.account.updateProfile,
            data: {},
            formData: dio.FormData.fromMap({
              'file': await dio.MultipartFile.fromFile(
                profileImagePath,
                filename: profileImagePath.split('/').last,
              ),
              'data': jsonEncode({
                'name': trimmedName,
                'email': trimmedEmail,
              }),
            }),
            fromJsonT: (json) => UserProfile.fromApi(json as Map<String, dynamic>),
          )
        : await _apiClient.patch<UserProfile>(
            endpoint: ApiConstants.account.updateProfile,
            data: {
              'name': trimmedName,
              'email': trimmedEmail,
            },
            fromJsonT: (json) => UserProfile.fromApi(json as Map<String, dynamic>),
          );

    isProfileSaving.value = false;

    return result.fold(
      (failure) {
        profileError.value = failure.message;
        Get.snackbar('Profile', failure.message);
        return false;
      },
      (success) {
        profile.value = success.data;
        hasActivePlan.value = success.data.isPremium;
        Get.snackbar('Profile', success.message);
        return true;
      },
    );
  }

  Future<void> fetchGalleryByCategory(String category) async {
    if (category.trim().isEmpty) {
      galleryItems.clear();
      return;
    }

    _activeGalleryCategory = category;
    galleryError.value = '';
    isGalleryLoading.value = true;
    galleryItems.clear();

    final result = await _apiClient.get<List<GalleryItem>>(
      endpoint: ApiConstants.gallery.byCategory(category),
      fromJsonT: (json) {
        if (json is! List) {
          return <GalleryItem>[];
        }

        return json
            .whereType<Map<String, dynamic>>()
            .map(GalleryItem.fromApi)
            .toList();
      },
    );

    result.fold(
      (failure) {
        if (_activeGalleryCategory != category) {
          return;
        }
        galleryError.value = failure.message;
      },
      (success) {
        if (_activeGalleryCategory != category) {
          return;
        }
        galleryItems.assignAll(success.data);
      },
    );

    if (_activeGalleryCategory == category) {
      isGalleryLoading.value = false;
    }
  }

  Future<void> generateGalleryPreview({
    required GalleryItem item,
    bool forceRefresh = false,
  }) async {
    galleryPreviewError.value = '';
    final key =
        '${item.id}::${colorThemes[selectedColorThemeIndex.value].title}::${selectedDetailLevel.value}';

    if (!forceRefresh && _galleryPreviewCache.containsKey(key)) {
      activeGalleryPreview.value = _galleryPreviewCache[key];
      return;
    }

    isGalleryPreviewLoading.value = true;
    activeGalleryPreview.value = GalleryPreview(
      itemId: item.id,
      originalImageUrl: item.imageUrl,
      previewImageUrl: '',
      style: item.categoryId,
      colorTheme: colorThemes[selectedColorThemeIndex.value].title,
      detailLevel: selectedDetailLevel.value,
      status: 'PENDING',
      errorMessage: '',
    );

    final result = await _apiClient.post<GalleryPreview>(
      endpoint: ApiConstants.gallery.previewById(item.id),
      data: {
        'colorTheme': colorThemes[selectedColorThemeIndex.value].title,
        'detailLevel': selectedDetailLevel.value,
      },
      fromJsonT: (json) =>
          GalleryPreview.fromApi(item.id, json as Map<String, dynamic>),
    );

    result.fold(
      (failure) {
        galleryPreviewError.value = failure.message;
      },
      (success) {
        activeGalleryPreview.value = success.data;
        _galleryPreviewCache[key] = success.data;
      },
    );

    isGalleryPreviewLoading.value = false;
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
        recentActivities.assignAll(records.map(_mapToActivityItem));
      },
    );

    isRecentActivityLoading.value = false;
  }

  Future<bool> openCheckoutSession() async {
    isCreatingCheckoutSession.value = true;

    final result = await _apiClient.post<Map<String, dynamic>>(
      endpoint: ApiConstants.stripe.createPaymentSession,
      data: {'planType': selectedPlan.id},
      fromJsonT: (json) => json as Map<String, dynamic>,
    );

    isCreatingCheckoutSession.value = false;

    return result.fold(
      (failure) {
        Get.snackbar('Payment', failure.message);
        return false;
      },
      (success) async {
        final url = (success.data['url'] ?? '').toString();
        if (url.isEmpty) {
          Get.snackbar(
            'Payment',
            'Stripe did not return a checkout URL. Please try again.',
          );
          return false;
        }

        final launched = await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );

        if (!launched) {
          Get.snackbar(
            'Payment',
            'Could not open the checkout page on this device.',
          );
          return false;
        }

        Get.snackbar(
          'Stripe Checkout',
          'Complete the payment in your browser, then return to the app.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      },
    );
  }

  Future<void> syncSubscriptionStatus() async {
    await fetchUserProfile();
    if (hasActivePlan.value) {
      Get.snackbar(
        'Premium Active',
        'Your subscription is now active.',
        snackPosition: SnackPosition.BOTTOM,
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
