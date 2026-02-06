import '../datasources/playlist_remote_datasource.dart';
import '../models/channel.dart';
import '../models/channel_group.dart';
import '../parsers/m3u_parser.dart';

class PlaylistRepository {
  final PlaylistRemoteDatasource _remote = PlaylistRemoteDatasource();

  List<Channel>? _cachedChannels;
  List<ChannelGroup>? _cachedGroups;
  DateTime? _lastFetch;

  Future<(List<Channel>, List<ChannelGroup>)> loadPlaylist(String url,
      {bool forceRefresh = false}) async {
    if (!forceRefresh &&
        _cachedChannels != null &&
        _lastFetch != null &&
        DateTime.now().difference(_lastFetch!) < const Duration(hours: 6)) {
      return (_cachedChannels!, _cachedGroups!);
    }

    final content = await _remote.fetchPlaylist(url);
    _cachedChannels = M3uParser.parse(content);
    _cachedGroups = M3uParser.groupChannels(_cachedChannels!);
    _lastFetch = DateTime.now();

    return (_cachedChannels!, _cachedGroups!);
  }

  List<Channel> get channels => _cachedChannels ?? [];
  List<ChannelGroup> get groups => _cachedGroups ?? [];
}
