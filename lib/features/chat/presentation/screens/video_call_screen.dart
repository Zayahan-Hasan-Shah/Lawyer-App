import 'dart:async';
import 'dart:developer';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/core/constants/app_colors.dart';
import 'package:lawyer_app/core/constants/app_keys.dart';
import 'package:lawyer_app/app/router/route_names.dart';
import 'package:lawyer_app/shared/widgets/custom_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

class VideoCallScreen extends ConsumerStatefulWidget {
  final String? channelName;
  final String? tempToken;
  final String? callerName;

  const VideoCallScreen({
    super.key,
    this.channelName,
    this.tempToken,
    this.callerName,
  });

  @override
  ConsumerState<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends ConsumerState<VideoCallScreen> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  bool _muted = false;
  bool _videoMuted = false;
  bool _isInit = false;

  late String _resolvedChannel;
  late String _resolvedToken;
  late String _resolvedName;

  @override
  void initState() {
    super.initState();
    _resolvedChannel = widget.channelName ?? AppKeys.channelName;
    _resolvedToken = widget.tempToken ?? AppKeys.agoraToken;
    _resolvedName = widget.callerName ?? 'Consultant';
    initAgora();
  }

  Future<void> initAgora() async {
    try {
      await [Permission.microphone, Permission.camera].request();
      _engine = createAgoraRtcEngine();
      await _engine.initialize(
        RtcEngineContext(
          appId: AppKeys.appId,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ),
      );

      _engine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            log('Agora local user joined channel: ${connection.channelId}');
            if (mounted) {
              setState(() {
                _localUserJoined = true;
              });
            }
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            log('Agora remote user joined channel: $remoteUid');
            if (mounted) {
              setState(() {
                _remoteUid = remoteUid;
              });
            }
          },
          onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
            log('Agora remote user went offline: $remoteUid');
            if (mounted) {
              setState(() {
                _remoteUid = null;
              });
            }
          },
        ),
      );

      await _engine.enableVideo();
      await _engine.startPreview();

      await _engine.joinChannel(
        token: _resolvedToken,
        channelId: _resolvedChannel,
        uid: 0,
        options: const ChannelMediaOptions(),
      );

      if (mounted) {
        setState(() {
          _isInit = true;
        });
      }
    } catch (e) {
      log('Agora Engine Error: $e');
    }
  }

  @override
  void dispose() {
    if (_isInit) {
      _engine.leaveChannel();
      _engine.release();
    }
    super.dispose();
  }

  void _onToggleMute() {
    setState(() {
      _muted = !_muted;
    });
    _engine.muteLocalAudioStream(_muted);
  }

  void _onToggleVideoMute() {
    setState(() {
      _videoMuted = !_videoMuted;
    });
    _engine.muteLocalVideoStream(_videoMuted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  void _onCallEnd() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(RouteNames.bottomNavigationScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Fullscreen Remote Video
          Positioned.fill(
            child: _buildRemoteVideo(),
          ),

          // 2. Small Local Preview Video
          Positioned(
            top: 6.h,
            right: 4.w,
            child: _buildLocalVideo(),
          ),

          // 3. Top Controls
          Positioned(
            top: 6.h,
            left: 4.w,
            child: CircleAvatar(
              backgroundColor: Colors.black45,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                onPressed: _onCallEnd,
              ),
            ),
          ),

          // 4. Bottom Controls and info
          Positioned(
            bottom: 6.h,
            left: 0,
            right: 0,
            child: Column(
              children: [
                CustomText(
                  title: _resolvedName,
                  fontSize: 18.sp,
                  weight: FontWeight.bold,
                  color: Colors.white,
                ),
                SizedBox(height: 1.h),
                CustomText(
                  title: _localUserJoined ? "Connected" : "Connecting...",
                  fontSize: 14.sp,
                  color: Colors.white70,
                ),
                SizedBox(height: 4.h),
                _buildCallControls(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemoteVideo() {
    if (!_isInit) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.kGold),
      );
    }

    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: _resolvedChannel),
        ),
      );
    } else {
      return Container(
        color: const Color(0xFF0F1112),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.video_call_rounded, size: 80, color: AppColors.kGold.withOpacity(0.5)),
                SizedBox(height: 3.h),
                CustomText(
                  title: 'Waiting for the other participant to join...',
                  fontSize: 16.sp,
                  color: Colors.white70,
                  alignText: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _buildLocalVideo() {
    if (!_isInit || !_localUserJoined) {
      return Container(
        width: 30.w,
        height: 20.h,
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.kGold.withOpacity(0.3), width: 1.5),
        ),
        child: const Center(child: CircularProgressIndicator(color: AppColors.kGold)),
      );
    }

    if (_videoMuted) {
      return Container(
        width: 30.w,
        height: 20.h,
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.kGold, width: 1.5),
        ),
        child: const Center(
          child: Icon(Icons.videocam_off_rounded, color: Colors.white54, size: 28),
        ),
      );
    }

    return Container(
      width: 30.w,
      height: 20.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.kGold, width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: AgoraVideoView(
          controller: VideoViewController(
            rtcEngine: _engine,
            canvas: const VideoCanvas(uid: 0),
          ),
        ),
      ),
    );
  }

  Widget _buildCallControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCallAction(
          _muted ? Icons.mic_off_rounded : Icons.mic_rounded,
          _muted ? Colors.redAccent : Colors.white24,
          _onToggleMute,
        ),
        _buildCallAction(
          Icons.call_end_rounded,
          Colors.redAccent,
          _onCallEnd,
        ),
        _buildCallAction(
          _videoMuted ? Icons.videocam_off_rounded : Icons.videocam_rounded,
          _videoMuted ? Colors.redAccent : Colors.white24,
          _onToggleVideoMute,
        ),
        _buildCallAction(
          Icons.switch_camera_rounded,
          Colors.white24,
          _onSwitchCamera,
        ),
      ],
    );
  }

  Widget _buildCallAction(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 24.sp),
      ),
    );
  }
}
