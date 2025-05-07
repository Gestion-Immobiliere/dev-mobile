import 'package:flutter/material.dart';
import '../models/post.dart';

class PostFormPage extends StatefulWidget {
  final Post? post;
  final Function(Post) onSubmit;

  const PostFormPage({super.key, this.post, required this.onSubmit});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.post == null ? 'Ajouter' : 'Modifier')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Titre'),
              validator: (value) => value!.isEmpty ? 'Titre requis' : null,
            ),
            TextFormField(
              controller: _bodyController,
              decoration: InputDecoration(labelText: 'Contenu'),
              validator: (value) => value!.isEmpty ? 'Contenu requis' : null,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Soumettre'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final newPost = Post(
                    id: widget.post?.id ?? 0,
                    title: _titleController.text,
                    body: _bodyController.text,
                  );
                  widget.onSubmit(newPost);
                  Navigator.pop(context);
                }
              },
            )
          ]),
        ),
      ),
    );
  }
}