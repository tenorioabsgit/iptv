class Channel {
  final String name;
  final String url;
  final String group;
  final String? logoUrl;
  final String? tvgId;
  final String? tvgName;
  final String? tvgChno;

  const Channel({
    required this.name,
    required this.url,
    this.group = '',
    this.logoUrl,
    this.tvgId,
    this.tvgName,
    this.tvgChno,
  });

  String get uniqueId => url.split('?').first;

  Map<String, dynamic> toJson() => {
        'name': name,
        'url': url,
        'group': group,
        'logoUrl': logoUrl,
        'tvgId': tvgId,
        'tvgName': tvgName,
        'tvgChno': tvgChno,
      };

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
        name: json['name'] as String,
        url: json['url'] as String,
        group: json['group'] as String? ?? '',
        logoUrl: json['logoUrl'] as String?,
        tvgId: json['tvgId'] as String?,
        tvgName: json['tvgName'] as String?,
        tvgChno: json['tvgChno'] as String?,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Channel && runtimeType == other.runtimeType && url == other.url;

  @override
  int get hashCode => url.hashCode;
}
