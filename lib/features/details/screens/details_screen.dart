import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final String id;
  final bool isMovie;

  const DetailsScreen({super.key, required this.id, required this.isMovie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isMovie ? 'Movie Details' : 'TV Show Details'),
      ),
      body: Center(child: Text('Details for $id')),
    );
  }
}
