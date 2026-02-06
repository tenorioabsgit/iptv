import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/channel.dart';

class HistoryEntry {
  final Channel channel;
  final DateTime watchedAt;

  const HistoryEntry({required this.channel, required this.watchedAt});

  Map<String, dynamic> toJson() => {
        'channel': channel.toJson(),
        'watchedAt': watchedAt.toIso8601String(),
      };

  factory HistoryEntry.fromJson(Map<String, dynamic> json) => HistoryEntry(
        channel:
            Channel.fromJson(json['channel'] as Map<String, dynamic>),
        watchedAt: DateTime.parse(json['watchedAt'] as String),
      );
}

class HistoryRepository {
  static const _key = 'history';
  static const _maxEntries = 100;

  Future<List<HistoryEntry>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getStringList(_key) ?? [];
    return json
        .map(
            (s) => HistoryEntry.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
  }

  Future<void> addToHistory(Channel channel) async {
    final history = await getHistory();
    // Remove if already exists (will re-add at top)
    history.removeWhere((e) => e.channel.url == channel.url);
    history.insert(
        0, HistoryEntry(channel: channel, watchedAt: DateTime.now()));
    // Keep only last N entries
    final trimmed = history.take(_maxEntries).toList();
    await _save(trimmed);
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  Future<void> _save(List<HistoryEntry> history) async {
    final prefs = await SharedPreferences.getInstance();
    final json = history.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, json);
  }
}
