import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawyer_app/src/app/initialize_app.dart';
import 'package:lawyer_app/src/services/notification_services/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

Future<void> _requestNotificationPermissions() async {
  try {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;
      await Permission.notification.request();
      if (sdkInt >= 30) {
        await Permission.manageExternalStorage.request();
      } else {
        await Permission.storage.request();
      }
    } else if (Platform.isIOS) {
      final status = await Permission.notification.status;
      if (!status.isGranted) {
        await Permission.notification.request();
      }
    }
  } catch (e) {
    log('Error requesting permissions: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _requestNotificationPermissions();
  await NotificationService().init();
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
