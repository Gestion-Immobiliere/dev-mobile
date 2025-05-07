import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class ApiService {
  static const String url = "https://jsonplaceholder.typicode.com/posts";

  static Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Post.fromJson(data)).toList();
    } else {
      throw Exception('Erreur lors du chargement des posts');
    }
  }

  static Future<Post> addPost(Post post) async {
    final response = await http.post(
      Uri.parse(url),
      body: json.encode(post.toJson()),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 201) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erreur lors de l\'ajout du post');
    }
  }

  static Future<void> deletePost(int id) async {
    final response = await http.delete(Uri.parse('$url/$id'));
    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la suppression du post');
    }
  }

  static Future<Post> updatePost(Post post) async {
    final response = await http.put(
      Uri.parse('$url/${post.id}'),
      body: json.encode(post.toJson()),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erreur lors de la mise à jour du post');
    }
  }
}
