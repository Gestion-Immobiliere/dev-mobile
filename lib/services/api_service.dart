import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class ApiService {
  static const String url = "https://jsonplaceholder.typicode.com/posts";

  // READ
  static Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Post.fromJson(data)).toList();
    } else {
      throw Exception('Erreur lors du chargement des posts');
    }
  }

  // CREATE
  static Future<Post> createPost(Post post) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': post.title, 'body': post.body, 'userId': 1}),
    );

    if (response.statusCode == 201) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec de la création du post');
    }
  }

  // UPDATE
  static Future<Post> updatePost(Post post) async {
    final response = await http.put(
      Uri.parse('$url/${post.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': post.id,
        'title': post.title,
        'body': post.body,
        'userId': 1,
      }),
    );

    if (response.statusCode == 200) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec de la mise à jour du post');
    }
  }

  // DELETE
  static Future<void> deletePost(int id) async {
    final response = await http.delete(Uri.parse('$url/$id'));

    if (response.statusCode != 200) {
      throw Exception('Échec de la suppression du post');
    }
  }
}
