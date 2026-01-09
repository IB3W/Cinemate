import 'package:flutter/material.dart';

class SeeAllScreen extends StatelessWidget {
  final String title;
  final List items;

  const SeeAllScreen({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('Showing all $title')),
    );
  }
}
