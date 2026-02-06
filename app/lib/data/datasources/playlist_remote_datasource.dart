import 'package:http/http.dart' as http;

class PlaylistRemoteDatasource {
  Future<String> fetchPlaylist(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    }
    throw Exception('Failed to load playlist: ${response.statusCode}');
  }
}
