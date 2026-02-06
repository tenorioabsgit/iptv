import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/channel.dart';
import '../data/models/channel_group.dart';
import '../data/repositories/playlist_repository.dart';
import 'settings_provider.dart';

final playlistRepositoryProvider = Provider((ref) => PlaylistRepository());

final playlistProvider =
    AsyncNotifierProvider<PlaylistNotifier, PlaylistState>(PlaylistNotifier.new);

class PlaylistState {
  final List<Channel> allChannels;
  final List<ChannelGroup> groups;

  const PlaylistState({required this.allChannels, required this.groups});
}

class PlaylistNotifier extends AsyncNotifier<PlaylistState> {
  @override
  Future<PlaylistState> build() async {
    final url = ref.watch(playlistUrlProvider);
    final repo = ref.read(playlistRepositoryProvider);
    final (channels, groups) = await repo.loadPlaylist(url);
    return PlaylistState(allChannels: channels, groups: groups);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final url = ref.read(playlistUrlProvider);
    final repo = ref.read(playlistRepositoryProvider);
    try {
      final (channels, groups) =
          await repo.loadPlaylist(url, forceRefresh: true);
      state = AsyncData(PlaylistState(allChannels: channels, groups: groups));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
