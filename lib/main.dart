import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawyer_app/app/initialize_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lawyer_app/services/notification_services/notification_service.dart';
import 'package:lawyer_app/services/notification_services/firebase_messaging_service.dart';
import 'package:lawyer_app/services/notification_services/callkit_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:lawyer_app/di/injection_container.dart' as di;

Future<void> _requestNotificationPermissions() async {
  try {
    // Request notification, camera, and microphone permissions together
    await [
      Permission.notification,
      Permission.camera,
      Permission.microphone,
    ].request();

    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;
      if (sdkInt >= 30) {
        await Permission.manageExternalStorage.request();
      } else {
        await Permission.storage.request();
      }
    }
  } catch (e) {
    log('Error requesting permissions: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp();
    await FirebaseMessagingService().init();
  } catch (e) {
    log('Firebase initialization skipped or failed: $e');
  }

  CallKitService().initListener();
  
  await _requestNotificationPermissions();
  await NotificationService().init();
  await di.init();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    ProviderScope(
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return const MyApp();
        },
      ),
    ),
  );
}

