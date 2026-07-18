import 'dart:async';
import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/core/constants/app_keys.dart';
import 'package:lawyer_app/app/router/route_names.dart';
import 'package:lawyer_app/features/client/presentation/providers/bottom_navigation_provider/bottom_navigation_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideoScreen extends ConsumerStatefulWidget {
  const VideoScreen({super.key});

  @override
  ConsumerState<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends ConsumerState<VideoScreen> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  bool _muted = false;
  bool _videoMuted = false;
  bool _isEngineInitialized = false;

  @override
  void initState() {
    super.initState();
  }

  void _checkAndManageAgora(int currentIndex) {
    if (currentIndex == 2) {
      if (!_isEngineInitialized) {
        _isEngineInitialized = true;
        initAgora();
      }
    } else {
      if (_isEngineInitialized) {
        _isEngineInitialized = false;
        _disposeAgora();
      }
    }
  }

  Future<void> _disposeAgora() async {
    try {
      await _engine.leaveChannel();
      await _engine.release();
      if (mounted) {
        setState(() {
          _localUserJoined = false;
          _remoteUid = null;
        });
      }
    } catch (e) {
      log("Error disposing Agora: $e");
    }
  }

  Future<void> initAgora() async {
    try {
      await [Permission.microphone, Permission.camera].request();
      _engine = createAgoraRtcEngine();
      await _engine.initialize(
        const RtcEngineContext(
          appId: AppKeys.appId,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ),
      );

      _engine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            if (mounted) {
              setState(() {
                _localUserJoined = true;
              });
            }
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            if (mounted) {
              setState(() {
                _remoteUid = remoteUid;
              });
            }
          },
          onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
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
        token: AppKeys.agoraToken,
        channelId: AppKeys.channelName,
        uid: 0,
        options: const ChannelMediaOptions(),
      );
    } catch (e) {
      log("Error initializing Agora: $e");
    }
  }

  @override
  void dispose() {
    if (_isEngineInitialized) {
      _engine.leaveChannel();
      _engine.release();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(bottomNavigationProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _checkAndManageAgora(currentIndex);
      }
    });

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
            top: 50,
            right: 20,
            child: _buildLocalVideo(),
          ),
          // 3. Optional Overlay UI Controls
          Positioned(
            bottom: 140,
            left: 0,
            right: 0,
            child: _buildCallControls(),
          ),
        ],
      ),
    );
  }

  Widget _buildRemoteVideo() {
    if (!_isEngineInitialized || !_localUserJoined) {
      return const Center(
        child: Text(
          'Initializing video channel...',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }

    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: const RtcConnection(channelId: AppKeys.channelName),
        ),
      );
    } else {
      return const Center(
        child: Text(
          'Waiting for the other participant to join...',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }
  }

  Widget _buildLocalVideo() {
    if (_isEngineInitialized && _localUserJoined) {
      return Container(
        width: 120,
        height: 180,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: AgoraVideoView(
            controller: VideoViewController(
              rtcEngine: _engine,
              canvas: const VideoCanvas(uid: 0),
            ),
          ),
        ),
      );
    } else {
      return const SizedBox(
        width: 120,
        height: 180,
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }
  }

  Widget _buildCallControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(_muted ? Icons.mic_off : Icons.mic, color: _muted ? Colors.red : Colors.white, size: 28),
          onPressed: _onToggleMute,
        ),
        IconButton(
          icon: const Icon(Icons.call_end, color: Colors.red, size: 36),
          onPressed: () => _onCallEnd(context),
        ),
        IconButton(
          icon: Icon(_videoMuted ? Icons.videocam_off : Icons.videocam, color: _videoMuted ? Colors.red : Colors.white, size: 28),
          onPressed: _onToggleVideoMute,
        ),
        IconButton(
          icon: const Icon(Icons.switch_camera, color: Colors.white, size: 28),
          onPressed: _onSwitchCamera,
        ),
      ],
    );
  }

  void _onToggleMute() {
    _muted = !_muted;
    _engine.muteLocalAudioStream(_muted);
    setState(() {});
  }

  void _onToggleVideoMute() {
    _videoMuted = !_videoMuted;
    _engine.muteLocalVideoStream(_videoMuted);
    setState(() {});
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  void _onCallEnd(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      context.go(RouteNames.bottomNavigationScreen);
    }
  }
}
