import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/channel.dart';
import 'playlist_provider.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final selectedCategoryProvider = StateProvider<String?>((ref) => null);

final filteredChannelsProvider = Provider<List<Channel>>((ref) {
  final playlistState = ref.watch(playlistProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final category = ref.watch(selectedCategoryProvider);

  return playlistState.when(
    data: (data) {
      var channels = data.allChannels;

      if (category != null) {
        channels = channels.where((ch) => ch.group == category).toList();
      }

      if (query.isNotEmpty) {
        channels = channels
            .where((ch) => ch.name.toLowerCase().contains(query))
            .toList();
      }

      return channels;
    },
    loading: () => [],
    error: (e, st) => [],
  );
});
