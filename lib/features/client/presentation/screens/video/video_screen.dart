import 'dart:async';
import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:lawyer_app/core/constants/app_keys.dart';
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

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
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
        onJoinChannelSuccess: (RtcConnection connection, int eplapsed) {
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int eplapsed) {
          setState(() {
            _remoteUid = remoteUid; // Store the remote participant's ID
          });
        },
        onUserOffline:
            (
              RtcConnection connection,
              int remoteUid,
              UserOfflineReasonType reason,
            ) {
              setState(() {
                _remoteUid = null;
              });
            },
      ),
    );

    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.joinChannel(
      token: AppKeys.agoraToken, // Import from your app_key.dart
      channelId: AppKeys.channelName, // Import from your app_key.dart
      uid: 0, // Using 0 lets Agora auto-assign a user ID
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Stack(
      children: [
        // 1. Fullscreen Remote Video (Bottom layer of the Stack)
        Positioned.fill(
          child: _buildRemoteVideo(),
        ),
        // 2. Small Local Preview Video (Overlaid on top, positioned at top-right)
        Positioned(
          top: 50,
          right: 20,
          child: _buildLocalVideo(),
        ),
        
        // 3. Optional Overlay UI Controls (e.g. End Call, Mute Buttons)
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
    if (_remoteUid != null) {
      // If the remote user has joined, display their stream
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: const RtcConnection(channelId: AppKeys.channelName),
        ),
      );
    } else {
      // If the remote user hasn't joined yet, show a friendly waiting screen
      return const Center(
        child: Text(
          'Waiting for the other participant to join...',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }
  }

  Widget _buildLocalVideo() {
    if (_localUserJoined) {
      // Render your camera stream in a small container
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
              canvas: const VideoCanvas(
                uid: 0,
              ), // uid: 0 always refers to the local user
            ),
          ),
        ),
      );
    } else {
      // Show a loading circle until you have successfully joined the channel
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

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }
}
