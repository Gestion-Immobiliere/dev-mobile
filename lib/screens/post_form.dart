import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';

class PostFormPage extends StatefulWidget {
  final Post? post; // null si création
  const PostFormPage({super.key, this.post});

  @override
  State<PostFormPage> createState() => _PostFormPageState();
}

class _PostFormPageState extends State<PostFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post?.title ?? '');
    _bodyController = TextEditingController(text: widget.post?.body ?? '');
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      Post newPost = Post(
        id: widget.post?.id ?? 0,
        title: _titleController.text,
        body: _bodyController.text,
      );

      try {
        if (widget.post == null) {
          await ApiService.createPost(newPost);
        } else {
          await ApiService.updatePost(newPost);
        }

        if (mounted) Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur : $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post == null ? 'Créer un post' : 'Modifier le post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Titre'),
                validator:
                    (value) => value == null || value.isEmpty ? 'Requis' : null,
              ),
              TextFormField(
                controller: _bodyController,
                decoration: const InputDecoration(labelText: 'Contenu'),
                validator:
                    (value) => value == null || value.isEmpty ? 'Requis' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text(widget.post == null ? 'Créer' : 'Mettre à jour'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
