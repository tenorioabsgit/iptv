import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/channel.dart';
import '../data/repositories/favorites_repository.dart';

final favoritesRepositoryProvider = Provider((ref) => FavoritesRepository());

final favoritesProvider =
    AsyncNotifierProvider<FavoritesNotifier, List<Channel>>(
        FavoritesNotifier.new);

class FavoritesNotifier extends AsyncNotifier<List<Channel>> {
  @override
  Future<List<Channel>> build() async {
    return ref.read(favoritesRepositoryProvider).getFavorites();
  }

  Future<void> toggle(Channel channel) async {
    final repo = ref.read(favoritesRepositoryProvider);
    final isFav = await repo.isFavorite(channel);
    if (isFav) {
      await repo.removeFavorite(channel);
    } else {
      await repo.addFavorite(channel);
    }
    state = AsyncData(await repo.getFavorites());
  }

  bool isFavorite(Channel channel) {
    return state.valueOrNull?.any((c) => c.url == channel.url) ?? false;
  }
}
