import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit_video/media_kit_video.dart';
import '../../../providers/player_provider.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  final VideoController videoController;

  const PlayerScreen({super.key, required this.videoController});

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    // Restore: allow landscape + portrait (no upside-down)
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(playerProvider);
    final channel = playerState.currentChannel;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Video
          Center(
            child: Video(
              controller: widget.videoController,
              controls: AdaptiveVideoControls,
            ),
          ),
          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          // Channel name overlay
          if (channel != null)
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              left: 56,
              child: Text(
                channel.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                ),
              ),
            ),
          // Error overlay
          if (playerState.error != null)
            Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.redAccent, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      'Erro ao reproduzir',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      playerState.error!,
                      style: const TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () {
                        if (channel != null) {
                          ref
                              .read(playerProvider.notifier)
                              .playChannel(channel);
                        }
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
