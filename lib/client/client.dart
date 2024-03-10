import 'dart:convert';
import 'package:http/http.dart';
import 'client_model.dart';

class PlaceholderApiClient {
  final String apiUrl;
  final Client httpClient;

  PlaceholderApiClient(this.apiUrl, this.httpClient);

  Future<List<Post>> getPosts() async {
    var url = Uri.parse('$apiUrl/posts');
    var response = await httpClient.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to get posts ${response.body}');
    }

    return (jsonDecode(response.body) as List<dynamic>).map((o) => Post.fromJson(o as Map<String, dynamic>)).toList();
  }

  Future<Post> createPost(int userId, String title, String body) async {
    var url = Uri.parse('$apiUrl/posts');
    var response = await httpClient.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'title': title,
        'body': body,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create post ${response.body}');
    }

    return Post.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }
}
