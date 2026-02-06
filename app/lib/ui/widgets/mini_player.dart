import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit_video/media_kit_video.dart';
import '../../providers/player_provider.dart';

class MiniPlayer extends ConsumerWidget {
  final VoidCallback onExpand;
  final VideoController videoController;

  const MiniPlayer({
    super.key,
    required this.onExpand,
    required this.videoController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerProvider);
    final channel = playerState.currentChannel;
    if (channel == null) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // Mini video preview
          SizedBox(
            width: 100,
            height: 64,
            child: Video(
              controller: videoController,
              controls: NoVideoControls,
            ),
          ),
          const SizedBox(width: 12),
          // Channel info
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  channel.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  channel.group,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          // Controls
          if (playerState.isBuffering)
            const Padding(
              padding: EdgeInsets.all(12),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              icon: Icon(
                playerState.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
              onPressed: () {
                final player = ref.read(playerProvider.notifier).player;
                player.playOrPause();
              },
            ),
          IconButton(
            icon: const Icon(Icons.stop),
            onPressed: () => ref.read(playerProvider.notifier).stop(),
          ),
          IconButton(
            icon: const Icon(Icons.fullscreen),
            onPressed: onExpand,
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
