import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/channel.dart';

class FavoritesRepository {
  static const _key = 'favorites';

  Future<List<Channel>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getStringList(_key) ?? [];
    return json
        .map((s) => Channel.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
  }

  Future<void> addFavorite(Channel channel) async {
    final favorites = await getFavorites();
    if (!favorites.contains(channel)) {
      favorites.add(channel);
      await _save(favorites);
    }
  }

  Future<void> removeFavorite(Channel channel) async {
    final favorites = await getFavorites();
    favorites.removeWhere((c) => c.url == channel.url);
    await _save(favorites);
  }

  Future<bool> isFavorite(Channel channel) async {
    final favorites = await getFavorites();
    return favorites.any((c) => c.url == channel.url);
  }

  Future<void> _save(List<Channel> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final json = favorites.map((c) => jsonEncode(c.toJson())).toList();
    await prefs.setStringList(_key, json);
  }
}
