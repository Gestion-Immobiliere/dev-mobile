import 'package:flutter/material.dart';
import 'pages/post_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TP API Flutter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PostListPage(),
    );
  }
}