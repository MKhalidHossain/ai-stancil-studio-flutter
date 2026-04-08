import 'dart:async';
import 'dart:io';

import 'package:downloadsfolder/downloadsfolder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;

class DownloadNotificationService {
  DownloadNotificationService._internal();

  static final DownloadNotificationService _instance =
      DownloadNotificationService._internal();

  factory DownloadNotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);

    await _notifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (response) async {
        await _openPayloadFile(response.payload);
      },
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    final launchDetails = await _notifications.getNotificationAppLaunchDetails();
    final payload = launchDetails?.notificationResponse?.payload;
    if (launchDetails?.didNotificationLaunchApp == true && payload != null) {
      unawaited(_openPayloadFile(payload));
    }

    _isInitialized = true;
  }

  Future<String> saveFileToDownloads({
    required File sourceFile,
    required String fileName,
    required String extension,
  }) async {
    final normalizedExtension = extension.replaceFirst('.', '').toLowerCase();
    final safeName = fileName.replaceAll(RegExp(r'\.[^.]+$'), '');
    final success = await copyFileIntoDownloadFolder(
      sourceFile.path,
      safeName,
      desiredExtension: normalizedExtension,
    );

    if (success != true) {
      throw Exception('Could not save file to Downloads.');
    }

    final downloadsDirectory = await getDownloadDirectory();
    final savedPath = p.join(
      downloadsDirectory.path,
      '$safeName.$normalizedExtension',
    );

    return savedPath;
  }

  Future<void> showDownloadCompleteNotification({
    required String title,
    required String body,
    required String filePath,
  }) async {
    final notificationId = filePath.hashCode;
    const androidDetails = AndroidNotificationDetails(
      'downloads_complete',
      'Downloads',
      channelDescription: 'Download complete notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    await _notifications.show(
      id: notificationId,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(android: androidDetails),
      payload: filePath,
    );
  }

  Future<void> _openPayloadFile(String? payload) async {
    if (payload == null || payload.isEmpty) {
      return;
    }

    final result = await OpenFilex.open(payload);
    if (kDebugMode) {
      debugPrint('Download notification open result: ${result.type} ${result.message}');
    }
  }
}
