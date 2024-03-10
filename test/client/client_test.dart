import 'dart:convert';

import 'package:flutter_http_client_example/client/client.dart';
import 'package:flutter_http_client_example/client/client_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'client_test.mocks.dart';

@GenerateMocks([Client])
void main() {
  test('get posts makes GET request to /posts', () async {
    var client = MockClient();
    final postClient = PlaceholderApiClient('https://jsonplaceholder.typicode.com', client);

    when(
      client.get(Uri.parse('https://jsonplaceholder.typicode.com/posts')),
    ).thenAnswer((_) async => Response("""
    [
      { "id": 1, "userId": 1, "title": "title-1", "body": "body-1" },
      { "id": 2, "userId": 1, "title": "title-2", "body": "body-2" }
    ]
    """, 200));

    final posts = await postClient.getPosts();

    expect(posts.length, 2);
    expect(posts[0], const Post(1, 1, 'title-1', 'body-1'));
    expect(posts[1], const Post(2, 1, 'title-2', 'body-2'));
  });

  test('create post makes POST request to /posts', () async {
    var client = MockClient();
    final postClient = PlaceholderApiClient('https://jsonplaceholder.typicode.com', client);

    when(
      client.post(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
        headers: {'Content-Type': 'application/json'},
        body: anyNamed('body'),
      ),
    ).thenAnswer((_) async => Response("""
      { "id": 100, "userId": 10, "title": "a-title", "body": "a-body" }
    """, 200));

    final post = await postClient.createPost(10, 'a-title', 'a-body');

    expect(post, const Post(100, 10, 'a-title', 'a-body'));

    final verification = verify(client.post(
      any,
      headers: anyNamed('headers'),
      body: captureAnyNamed('body'),
    ));
    final requestBody = jsonDecode(verification.captured.first as String);
    expect(requestBody, {'userId': 10, 'title': 'a-title', 'body': 'a-body'});
  });
}
