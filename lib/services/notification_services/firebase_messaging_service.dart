import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lawyer_app/services/notification_services/callkit_service.dart';
import 'package:uuid/uuid.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("Handling background message: ${message.messageId}");
  await Firebase.initializeApp();
  _handleIncomingCallMessage(message);
}

void _handleIncomingCallMessage(RemoteMessage message) {
  final data = message.data;
  if (data['type'] == 'incoming_call') {
    final uuid = data['uuid'] ?? const Uuid().v4();
    final callerName = data['caller_name'] ?? 'Advocate';
    final callerAvatar = data['caller_avatar'] ?? '';
    final channelName = data['channel_name'] ?? 'agora_video_channel';
    final tempToken = data['temp_token'] ?? '';

    CallKitService().showIncomingCall(
      uuid: uuid,
      callerName: callerName,
      callerAvatar: callerAvatar,
      channelName: channelName,
      tempToken: tempToken,
    );
  }
}

class FirebaseMessagingService {
  static final FirebaseMessagingService _instance = FirebaseMessagingService._internal();
  factory FirebaseMessagingService() => _instance;
  FirebaseMessagingService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init() async {
    // Register background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Request permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    log('FCM Permission status: ${settings.authorizationStatus}');

    // Retrieve FCM Token
    try {
      String? token = await _messaging.getToken();
      log('=== DEVICE FCM TOKEN ===');
      log(token ?? 'Could not retrieve token');
      log('========================');
      if (token != null) {
        await _sendTokenToBackend(token);
      }
    } catch (e) {
      log('Error getting FCM token: $e');
    }

    // Monitor token updates
    _messaging.onTokenRefresh.listen((token) {
      log('FCM Token refreshed: $token');
      _sendTokenToBackend(token);
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Handling foreground message: ${message.messageId}');
      _handleIncomingCallMessage(message);
    });

    // Handle message that opened the app
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('FCM message opened the app: ${message.data}');
    });
  }

  Future<void> _sendTokenToBackend(String token) async {
    // Placeholder: Send this token to your backend API once implemented
    log('FCM Token saved: $token. (API integration pending)');
  }
}
