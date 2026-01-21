import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/poster_card.dart';
import '../../../data/models/content_item.dart';

class SeeAllScreen extends StatelessWidget {
  final String title;
  final List<ContentItem> items;

  const SeeAllScreen({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text(title), centerTitle: true),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.5,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return PosterCard(
            item: items[index],
            onTap: () {
              Navigator.pushNamed(context, '/details', arguments: items[index]);
            },
          );
        },
      ),
    );
  }
}
