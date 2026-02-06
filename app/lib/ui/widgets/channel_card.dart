import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/channel.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/player_provider.dart';
import 'channel_logo.dart';

class ChannelCard extends ConsumerWidget {
  final Channel channel;

  const ChannelCard({super.key, required this.channel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerProvider);
    final isPlaying = playerState.currentChannel?.url == channel.url;
    final isFav = ref.watch(favoritesProvider).valueOrNull?.any(
              (c) => c.url == channel.url,
            ) ??
        false;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: isPlaying
          ? colorScheme.primaryContainer
          : colorScheme.surfaceContainerLow,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => ref.read(playerProvider.notifier).playChannel(channel),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  ChannelLogo(logoUrl: channel.logoUrl, size: 56),
                  if (isPlaying)
                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          size: 14,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                channel.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isPlaying ? FontWeight.bold : FontWeight.normal,
                  color: isPlaying
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () =>
                    ref.read(favoritesProvider.notifier).toggle(channel),
                child: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  size: 18,
                  color: isFav
                      ? colorScheme.error
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChannelListTile extends ConsumerWidget {
  final Channel channel;

  const ChannelListTile({super.key, required this.channel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerProvider);
    final isPlaying = playerState.currentChannel?.url == channel.url;
    final isFav = ref.watch(favoritesProvider).valueOrNull?.any(
              (c) => c.url == channel.url,
            ) ??
        false;
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: ChannelLogo(logoUrl: channel.logoUrl, size: 40),
      title: Text(
        channel.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: isPlaying ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        channel.group,
        style: TextStyle(
          fontSize: 12,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: IconButton(
        icon: Icon(
          isFav ? Icons.favorite : Icons.favorite_border,
          color: isFav ? colorScheme.error : null,
        ),
        onPressed: () =>
            ref.read(favoritesProvider.notifier).toggle(channel),
      ),
      selected: isPlaying,
      selectedTileColor: colorScheme.primaryContainer,
      onTap: () => ref.read(playerProvider.notifier).playChannel(channel),
    );
  }
}
