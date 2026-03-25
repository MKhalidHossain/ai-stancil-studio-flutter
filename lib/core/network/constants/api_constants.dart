class ApiConstants {
  /// [Base Configuration]

  static const String baseDomain = 'http://localhost:5000';
  // static const String baseDomain = 'http://10.10.5.90:5000'; // Farhan Office

  // static const String baseDomain = 'http://10.10.5.33:5003'; // Eshita Office

  static const String baseUrl = '$baseDomain/api/v1';

  /// Dynamically generated WebSocket URL based on baseDomain
  static String get webSocketUrl {
    if (baseDomain.startsWith('https://')) {
      return baseDomain.replaceFirst('https://', 'wss://');
    } else if (baseDomain.startsWith('http://')) {
      return baseDomain.replaceFirst('http://', 'ws://');
    }
    // Fallback for unexpected cases (e.g., no scheme)
    return 'ws://$baseDomain';
  }

  /// [Headers]
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
    // Content-Type will be set automatically for multipart
  };

  /// [Endpoint Groups
  static AuthEndpoints get auth => AuthEndpoints();
  static SearchEndpoints get search => SearchEndpoints();
  static UserEndpoints get users => UserEndpoints();
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
}

/// [Authentication Endpoints]
class AuthEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/auth';
  final String refreshToken = '$_base/refresh-token';

  final String login = '$_base/login';
  final String signup = '$_base/register';
  final String logout = '$_base/logout';
  final String forgotPassword = '$_base/forgot-password';
  final String verifyOtp = '$_base/verify-otp';
  final String resetPassword = '$_base/reset-password';

  final String google = '$_base/google';
  final String changePassword = '$_base/change-password';
}

class SearchEndpoints {
  static const String _base = ApiConstants.baseUrl;
  final String getAllGigs = '$_base/gigs';
  String searchGig = '$_base/users/search';
}

class HistoryEndpoints {
  static const String _base = ApiConstants.baseUrl;
  final String getAllOrders = '$_base/orders/my-orders';
  final String getAllGigs = '$_base/gigs';
}

class UserEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/users';
  final String updateProfile = '$_base/profile';
  final String uploadWork = '$_base/works';
}

class MedicinePlanEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/medicine-plans';

  String getFamilyMemberPlans(String memberId) => "$_base/family/$memberId";
}

class MessagesEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/messages';

  final String getListOfChats = "$_base/list";
  String chatHistoryById(String id) => "$_base/history/$id";
  final String sendMessage = _base;
}

class HomeEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/gigs';
  final String getHome = _base;
}

class GigsEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/gigs';

  final String createGig = _base;

  String getDoctorById(String doctorId) => "$_base/$doctorId";
}

class PortfolioEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/portfolios';

  final String createPortfolio = _base;
}

class JobPostsEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/job-posts';
  final String postJob = _base;
}

class OrderEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/orders';

  final String orderMedicine = _base;
  final String pharmacyDashboard = "$_base/pharmacy/dashboard";
}

class NotificationEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/notifications';

  final String getNotification = _base;
}

class ProfileEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/users';
  final String fetchProfile = '$_base/profile/me';
  final String updateProfile = '$_base/profile';
  final String fetchJobs = '${ApiConstants.baseUrl}/job-posts/my/posts';
  String updateJobs(String jobId) => '${ApiConstants.baseUrl}/job-posts/$jobId';

  final String fetchGigs = '${ApiConstants.baseUrl}/gigs/my/gigs';
  String fetchPortfolio(String creativeId) =>
      '${ApiConstants.baseUrl}/portfolios/creative/$creativeId';

  String fetchGigById(String gigId) => '${ApiConstants.baseUrl}/gigs/$gigId';
  String fetchPortfolioById(String portfolioId) =>
      '${ApiConstants.baseUrl}/portfolios/$portfolioId';
  String updateGig(String gigId) => '${ApiConstants.baseUrl}/gigs/$gigId';
  String updatePortfolio(String portfolioId) =>
      '${ApiConstants.baseUrl}/portfolios/$portfolioId';

  final String fetchLikes = '${ApiConstants.baseUrl}/social/my-likes';
  final String createBlock = '${ApiConstants.baseUrl}/social/block';
  final String fetchBlock = '${ApiConstants.baseUrl}/social/blocked-users';
  final String fetchPublicJobs = '${ApiConstants.baseUrl}/job-posts';
  String fetchPublicClientProfile(String userId) =>
      '${ApiConstants.baseUrl}/users/client/$userId';

  final String createGigs = '${ApiConstants.baseUrl}/gigs';
  final String changePass = '${ApiConstants.baseUrl}/auth/change-password';
  final String toggleLikes = '${ApiConstants.baseUrl}/social/like';

  String fetchPublicCreativeProfile(String userId) =>
      '${ApiConstants.baseUrl}/users/creative/$userId';
  String unblockUser(String userId) =>
      '${ApiConstants.baseUrl}/social/block/$userId';

  final String fetchDislikes = '${ApiConstants.baseUrl}/social/my-dislikes';
  final String toggleDislikes = '${ApiConstants.baseUrl}/social/dislike';
}

class GalleryEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/pregallery';

  String byCategory(String category) =>
      '$_base/${Uri.encodeComponent(category)}';
}

class StencilEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/aistencil';

  final String getMyAllStencils = _base;
}
