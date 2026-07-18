import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:lawyer_app/app/router/app_router.dart';

class CallKitService {
  static final CallKitService _instance = CallKitService._internal();
  factory CallKitService() => _instance;
  CallKitService._internal();

  void initListener() {
    FlutterCallkitIncoming.onEvent.listen((event) {
      log('CallKit Event: ${event?.event}');
      if (event == null) return;

      switch (event.event) {
        case Event.actionCallAccept:
          final body = event.body as Map<String, dynamic>?;
          final extra = body?['extra'] as Map<String, dynamic>?;
          final callerName = body?['nameCaller'] as String? ?? 'Advocate';
          final channelName = extra?['channelName'] as String?;
          final tempToken = extra?['tempToken'] as String?;

          log('Call accepted! Routing to /video-call with channelName: $channelName');
          
          // Route the application directly to the video call screen
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AppRouter.router.push('/video-call', extra: {
              'channelName': channelName,
              'tempToken': tempToken,
              'callerName': callerName,
            });
          });
          break;

        case Event.actionCallDecline:
          log('Call declined by user');
          break;

        default:
          break;
      }
    });
  }

  Future<void> showIncomingCall({
    required String uuid,
    required String callerName,
    required String callerAvatar,
    required String channelName,
    required String tempToken,
  }) async {
    final CallKitParams params = CallKitParams(
      id: uuid,
      nameCaller: callerName,
      appName: 'KAR',
      avatar: callerAvatar.isNotEmpty ? callerAvatar : 'https://i.pravatar.cc/150?u=1',
      handle: 'Video Appointment',
      type: 1, // 0 for Audio, 1 for Video
      duration: 30000, // Ringing duration in ms (30s)
      textAccept: 'Accept',
      textDecline: 'Decline',
      missedCallNotification: const NotificationParams(
        showNotification: true,
        subtitle: 'You missed a video appointment call.',
      ),
      extra: <String, dynamic>{
        'channelName': channelName,
        'tempToken': tempToken,
      },
      headers: <String, dynamic>{
        'apiKey': 'AbcTest',
      },
      android: const AndroidParams(
        isCustomNotification: true,
        isShowLogo: false,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#0F1112',
        backgroundUrl: 'assets/images/logo.png',
        actionColor: '#4CAF50',
        incomingCallNotificationChannelName: 'Incoming Call',
      ),
      ios: const IOSParams(
        iconName: 'AppIcon',
        handleType: 'generic',
        supportsVideo: true,
        maximumCallGroups: 1,
        maximumCallsPerCallGroup: 1,
        audioSessionActive: true,
      ),
    );

    await FlutterCallkitIncoming.showCallkitIncoming(params);
  }

  Future<void> endCall(String uuid) async {
    await FlutterCallkitIncoming.endCall(uuid);
  }
}
