import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/key_constants.dart';

class AuthStorageService {
  final FlutterSecureStorage _secureStorage;

  AuthStorageService({FlutterSecureStorage? storage})
    : _secureStorage = storage ?? const FlutterSecureStorage();


  Future<void> storeAuthData({
    String? accessToken,
    String? refreshToken,
    String? userId,
    String? role,
  }) async {
    if (accessToken == null ||
        refreshToken == null ||
        userId == null ||
        role == null) {
      // Handle missing data: throw, log, or use defaults
      throw Exception('Missing required auth data');
    }

    // Store tokens and user ID in parallel for better performance
    await Future.wait([
      _secureStorage.write(key: KeyConstants.accessToken, value: accessToken),
      _secureStorage.write(key: KeyConstants.refreshToken, value: refreshToken),
      _secureStorage.write(key: KeyConstants.userId, value: userId),
      _secureStorage.write(key: KeyConstants.role, value: role),
    ]);
  }

  // Store just access token
  Future<void> storeAccessToken({required String accessToken}) async {
    await _secureStorage.write(
      key: KeyConstants.accessToken,
      value: accessToken,
    );
  }

  // Store just refresh token
  Future<void> storeRefreshToken({required String refreshToken}) async {
    await _secureStorage.write(
      key: KeyConstants.refreshToken,
      value: refreshToken,
    );
  }

  // Store just user ID
  Future<void> storeUserId(String userId) async {
    await _secureStorage.write(key: KeyConstants.userId, value: userId);
  }

  // Check user authenticater or not
  Future<bool> isAuthenticated() async {
    final accessToken = await getAccessToken();
    return accessToken != null &&
        accessToken.isNotEmpty;
  }

  // Get access token
  Future<String?> getAccessToken() async {
    final accessToken = await _secureStorage.read(
      key: KeyConstants.accessToken,
    );
    // if (accessToken != null) {
    //   _isAuthenticated = true;
    // } else {
    //   _isAuthenticated = false;
    // }
    // DPrint.info("Get Access Token check : $accessToken $_isAuthenticated");

    return accessToken;
  }

  // Get refresh token
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: KeyConstants.refreshToken);
  }

  // Get user ID
  Future<String?> getUserId() async {
    return await _secureStorage.read(key: KeyConstants.userId);
  }

  // Get user role
  Future<String?> getUserRole() async {
    return await _secureStorage.read(key: KeyConstants.role);
  }

  // Future<UserRole?> getUserRole() async {
  //   final role = await _secureStorage.read(key: KeyConstants.role);
  //   final userRole = UserRole.fromString(role);
  //   return userRole;
  // }

  // // Get all auth data at once
  // Future<Map<String, String?>> getAllAuthData() async {
  //   final role = await getUserRole();
  //   return {
  //     'accessToken': await getAccessToken(),
  //     'refreshToken': await getRefreshToken(),
  //     'userId': await getUserId(),
  //     'role': role?.name ?? UserRole.patient.name,
  //   };
  // }

  // Clear all auth data (logout)
  Future<void> clearAuthData() async {
    await Future.wait([
      _secureStorage.delete(key: KeyConstants.accessToken),
      _secureStorage.delete(key: KeyConstants.refreshToken),
      _secureStorage.delete(key: KeyConstants.userId),
      _secureStorage.delete(key: KeyConstants.role),
    ]);

  }

  // Check if user ID exists
  Future<bool> hasUserId() async {
    final userId = await getUserId();
    return userId != null && userId.isNotEmpty;
  }
}
