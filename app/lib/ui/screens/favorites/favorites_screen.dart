import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit_video/media_kit_video.dart';
import '../../../providers/favorites_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../widgets/channel_card.dart';
import '../../widgets/mini_player.dart';
import '../../../providers/player_provider.dart';
import '../player/player_screen.dart';

class FavoritesScreen extends ConsumerWidget {
  final VideoController videoController;

  const FavoritesScreen({super.key, required this.videoController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final isGrid = ref.watch(gridViewProvider);
    final playerState = ref.watch(playerProvider);
    final hasActiveChannel = playerState.currentChannel != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),
      body: Column(
        children: [
          Expanded(
            child: favorites.when(
              data: (channels) {
                if (channels.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.favorite_border, size: 48),
                        SizedBox(height: 16),
                        Text('Nenhum favorito ainda'),
                        SizedBox(height: 8),
                        Text(
                          'Toque no coração de um canal para salvar',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  );
                }

                if (isGrid) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemCount: channels.length,
                    itemBuilder: (_, i) =>
                        ChannelCard(channel: channels[i]),
                  );
                }

                return ListView.builder(
                  itemCount: channels.length,
                  itemBuilder: (_, i) =>
                      ChannelListTile(channel: channels[i]),
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Erro: $e')),
            ),
          ),
          if (hasActiveChannel)
            MiniPlayer(
              videoController: videoController,
              onExpand: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      PlayerScreen(videoController: videoController),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
