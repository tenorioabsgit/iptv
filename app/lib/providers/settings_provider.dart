import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_constants.dart';
import '../data/repositories/settings_repository.dart';

final settingsRepositoryProvider = Provider((ref) => SettingsRepository());

final playlistUrlProvider = StateProvider<String>((ref) {
  return AppConstants.defaultPlaylistUrl;
});

final darkModeProvider = StateProvider<bool>((ref) => true);

final gridViewProvider = StateProvider<bool>((ref) => true);

/// Loads settings from SharedPreferences into providers
Future<void> loadSettings(ProviderContainer container) async {
  final repo = container.read(settingsRepositoryProvider);
  container.read(playlistUrlProvider.notifier).state =
      await repo.getPlaylistUrl();
  container.read(darkModeProvider.notifier).state = await repo.isDarkMode();
  container.read(gridViewProvider.notifier).state = await repo.isGridView();
}
