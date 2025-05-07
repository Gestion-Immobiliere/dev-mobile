import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';
import 'post_detail_page.dart';
import 'post_form_page.dart';

class PostListPage extends StatefulWidget {
  const PostListPage({super.key});

  @override
  State<PostListPage> createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  List<Post> _posts = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPostsFromApi();
  }

  Future<void> _loadPostsFromApi() async {
    try {
      final fetchedPosts = await ApiService.fetchPosts();
      setState(() {
        _posts = fetchedPosts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erreur lors du chargement des posts';
        _isLoading = false;
      });
    }
  }

  void _handleCreate(Post post) {
    final newPost =
        Post(id: _posts.length + 101, title: post.title, body: post.body);
    setState(() {
      _posts.add(newPost);
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Post ajouté (simulation, l'API ne le sauvegarde pas)"),
    ));
  }

  void _handleUpdate(Post post) {
    setState(() {
      final index = _posts.indexWhere((p) => p.id == post.id);
      if (index != -1) {
        _posts[index] = post;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Post modifié (simulation, l'API ne le sauvegarde pas)"),
    ));
  }

  void _handleDelete(int id) {
    setState(() {
      _posts.removeWhere((p) => p.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Post supprimé (simulation, l'API ne le supprime pas)"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Liste des Posts')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : ListView.builder(
                  itemCount: _posts.length,
                  itemBuilder: (context, index) {
                    final post = _posts[index];
                    return Card(
                      margin: EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(post.title),
                        subtitle: Text(post.body),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => PostDetailPage(post: post)));
                        },
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => PostFormPage(
                                            post: post,
                                            onSubmit: _handleUpdate)));
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _handleDelete(post.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => PostFormPage(onSubmit: _handleCreate)));
        },
      ),
    );
  }
}
