import '../models/channel.dart';
import '../models/channel_group.dart';

class M3uParser {
  static final _attrRegex = RegExp(r'([\w-]+)="([^"]*)"');
  static final _nameRegex = RegExp(r',(.+)$');

  static List<Channel> parse(String content) {
    final lines = content.split('\n');
    final channels = <Channel>[];

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (!line.startsWith('#EXTINF:')) continue;

      // Extract attributes
      final attrs = <String, String>{};
      for (final match in _attrRegex.allMatches(line)) {
        attrs[match.group(1)!.toLowerCase()] = match.group(2)!;
      }

      // Extract channel name (everything after last comma)
      final nameMatch = _nameRegex.firstMatch(line);
      final name = nameMatch?.group(1)?.trim() ?? 'Unknown';

      // Next non-empty, non-comment line is the URL
      String url = '';
      for (var j = i + 1; j < lines.length; j++) {
        final nextLine = lines[j].trim();
        if (nextLine.isEmpty || nextLine.startsWith('#')) continue;
        url = nextLine;
        break;
      }

      if (url.isEmpty) continue;

      channels.add(Channel(
        name: name,
        url: url,
        group: attrs['group-title'] ?? '',
        logoUrl: attrs['tvg-logo'],
        tvgId: attrs['tvg-id'],
        tvgName: attrs['tvg-name'],
        tvgChno: attrs['tvg-chno'] ?? attrs['channel-number'],
      ));
    }

    return channels;
  }

  static List<ChannelGroup> groupChannels(List<Channel> channels) {
    final map = <String, List<Channel>>{};
    for (final ch in channels) {
      final group = ch.group.isEmpty ? 'Outros' : ch.group;
      map.putIfAbsent(group, () => []).add(ch);
    }

    // Sort: BR categories first, then international
    final groups = map.entries
        .map((e) => ChannelGroup(name: e.key, channels: e.value))
        .toList();

    groups.sort((a, b) {
      final aIsBr = a.name.startsWith('BR ');
      final bIsBr = b.name.startsWith('BR ');
      if (aIsBr && !bIsBr) return -1;
      if (!aIsBr && bIsBr) return 1;
      return a.name.compareTo(b.name);
    });

    return groups;
  }
}
