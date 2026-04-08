import 'package:flutter/foundation.dart';

class ApiConstants {
  static const String _configuredBaseDomain = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  static String get baseDomain {
    if (_configuredBaseDomain.isNotEmpty) {
      return _configuredBaseDomain;
    }

    if (kIsWeb) {
      return 'http://127.0.0.1:5000';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:5000';
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
      case TargetPlatform.fuchsia:
        return 'http://127.0.0.1:5000';
    }
  }

  static String get baseUrl => '$baseDomain/api/v1';

  static String get webSocketUrl {
    if (baseDomain.startsWith('https://')) {
      return baseDomain.replaceFirst('https://', 'wss://');
    } else if (baseDomain.startsWith('http://')) {
      return baseDomain.replaceFirst('http://', 'ws://');
    }
    return 'ws://$baseDomain';
  }

  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> authHeaders(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
  };

  static Map<String, String> get multipartHeaders => {
    'Accept': 'application/json',
  };

  static AuthEndpoints get auth => AuthEndpoints();
  static SearchEndpoints get search => SearchEndpoints();
  static UserEndpoints get users => UserEndpoints();
  static AccountEndpoints get account => AccountEndpoints();
  static HistoryEndpoints get history => HistoryEndpoints();
  static MessagesEndpoints get messages => MessagesEndpoints();
  static HomeEndpoints get home => HomeEndpoints();
  static GigsEndpoints get gigs => GigsEndpoints();
  static PortfolioEndpoints get portfolio => PortfolioEndpoints();
  static JobPostsEndpoints get jobPosts => JobPostsEndpoints();
  static OrderEndpoints get order => OrderEndpoints();
  static NotificationEndpoints get notification => NotificationEndpoints();
  static MedicinePlanEndpoints get medicinePlan => MedicinePlanEndpoints();
  static ProfileEndpoints get profile => ProfileEndpoints();
  static GalleryEndpoints get gallery => GalleryEndpoints();
  static StencilEndpoints get stencil => StencilEndpoints();
  static StripeEndpoints get stripe => StripeEndpoints();
}

class AuthEndpoints {
  String get _base => '${ApiConstants.baseUrl}/auth';

  String get refreshToken => '$_base/refresh-token';
  String get login => '$_base/login';
  String get signup => '$_base/register';
  String get logout => '$_base/logout';
  String get forgotPassword => '$_base/forgot-password';
  String get verifyOtp => '$_base/verify-otp';
  String get resetPassword => '$_base/reset-password';
  String get google => '$_base/google';
  String get changePassword => '$_base/change-password';
}

class SearchEndpoints {
  String get _base => ApiConstants.baseUrl;

  String get getAllGigs => '$_base/gigs';
  String get searchGig => '$_base/users/search';
}

class HistoryEndpoints {
  String get _base => ApiConstants.baseUrl;

  String get getAllOrders => '$_base/orders/my-orders';
  String get getAllGigs => '$_base/gigs';
}

class UserEndpoints {
  String get _base => '${ApiConstants.baseUrl}/users';

  String get updateProfile => '$_base/profile';
  String get uploadWork => '$_base/works';
}

class AccountEndpoints {
  String get _base => '${ApiConstants.baseUrl}/user';

  String get me => '$_base/me';
  String get updateProfile => '$_base/update-profile';
}

class MedicinePlanEndpoints {
  String get _base => '${ApiConstants.baseUrl}/medicine-plans';

  String getFamilyMemberPlans(String memberId) => '$_base/family/$memberId';
}

class MessagesEndpoints {
  String get _base => '${ApiConstants.baseUrl}/messages';

  String get getListOfChats => '$_base/list';
  String chatHistoryById(String id) => '$_base/history/$id';
  String get sendMessage => _base;
}

class HomeEndpoints {
  String get _base => '${ApiConstants.baseUrl}/gigs';

  String get getHome => _base;
}

class GigsEndpoints {
  String get _base => '${ApiConstants.baseUrl}/gigs';

  String get createGig => _base;
  String getDoctorById(String doctorId) => '$_base/$doctorId';
}

class PortfolioEndpoints {
  String get _base => '${ApiConstants.baseUrl}/portfolios';

  String get createPortfolio => _base;
}

class JobPostsEndpoints {
  String get _base => '${ApiConstants.baseUrl}/job-posts';

  String get postJob => _base;
}

class OrderEndpoints {
  String get _base => '${ApiConstants.baseUrl}/orders';

  String get orderMedicine => _base;
  String get pharmacyDashboard => '$_base/pharmacy/dashboard';
}

class NotificationEndpoints {
  String get _base => '${ApiConstants.baseUrl}/notifications';

  String get getNotification => _base;
}

class ProfileEndpoints {
  String get _base => '${ApiConstants.baseUrl}/users';

  String get fetchProfile => '$_base/profile/me';
  String get updateProfile => '$_base/profile';
  String get fetchJobs => '${ApiConstants.baseUrl}/job-posts/my/posts';
  String updateJobs(String jobId) => '${ApiConstants.baseUrl}/job-posts/$jobId';
  String get fetchGigs => '${ApiConstants.baseUrl}/gigs/my/gigs';
  String fetchPortfolio(String creativeId) =>
      '${ApiConstants.baseUrl}/portfolios/creative/$creativeId';
  String fetchGigById(String gigId) => '${ApiConstants.baseUrl}/gigs/$gigId';
  String fetchPortfolioById(String portfolioId) =>
      '${ApiConstants.baseUrl}/portfolios/$portfolioId';
  String updateGig(String gigId) => '${ApiConstants.baseUrl}/gigs/$gigId';
  String updatePortfolio(String portfolioId) =>
      '${ApiConstants.baseUrl}/portfolios/$portfolioId';
  String get fetchLikes => '${ApiConstants.baseUrl}/social/my-likes';
  String get createBlock => '${ApiConstants.baseUrl}/social/block';
  String get fetchBlock => '${ApiConstants.baseUrl}/social/blocked-users';
  String get fetchPublicJobs => '${ApiConstants.baseUrl}/job-posts';
  String fetchPublicClientProfile(String userId) =>
      '${ApiConstants.baseUrl}/users/client/$userId';
  String get createGigs => '${ApiConstants.baseUrl}/gigs';
  String get changePass => '${ApiConstants.baseUrl}/auth/change-password';
  String get toggleLikes => '${ApiConstants.baseUrl}/social/like';
  String fetchPublicCreativeProfile(String userId) =>
      '${ApiConstants.baseUrl}/users/creative/$userId';
  String unblockUser(String userId) =>
      '${ApiConstants.baseUrl}/social/block/$userId';
  String get fetchDislikes => '${ApiConstants.baseUrl}/social/my-dislikes';
  String get toggleDislikes => '${ApiConstants.baseUrl}/social/dislike';
}

class GalleryEndpoints {
  String get _base => '${ApiConstants.baseUrl}/pregallery';

  String get getAll => '$_base/get-all-gallery-items';
  String byCategory(String category) => '$_base/${Uri.encodeComponent(category)}';
  String previewById(String id) => '$_base/$id/preview';
}

class StencilEndpoints {
  String get _base => '${ApiConstants.baseUrl}/aistencil';

  String get create => '$_base/create';
  String get getMyAllStencils => _base;
  String byId(String id) => '$_base/$id';
}

class StripeEndpoints {
  String get _base => '${ApiConstants.baseUrl}/stripe';

  String get createPaymentSession => '$_base/create-payment-session';
}
