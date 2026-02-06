import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

class SettingsRepository {
  static const _playlistUrlKey = 'playlist_url';
  static const _darkModeKey = 'dark_mode';
  static const _gridViewKey = 'grid_view';

  Future<String> getPlaylistUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_playlistUrlKey) ?? AppConstants.defaultPlaylistUrl;
  }

  Future<void> setPlaylistUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_playlistUrlKey, url);
  }

  Future<bool> isDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkModeKey) ?? true;
  }

  Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, value);
  }

  Future<bool> isGridView() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_gridViewKey) ?? true;
  }

  Future<void> setGridView(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_gridViewKey, value);
  }
}
