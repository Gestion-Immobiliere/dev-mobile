import 'package:flutter/material.dart';
import '../models/post.dart';

class PostDetailPage extends StatelessWidget {
  final Post post;

  const PostDetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Détails du Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text(post.body, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}