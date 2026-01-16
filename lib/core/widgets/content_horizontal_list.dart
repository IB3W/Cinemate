import 'package:flutter/material.dart';
import '../../data/models/content_item.dart';
import 'poster_card.dart';
import 'section_header.dart';

class ContentHorizontalList extends StatelessWidget {
  final String title;
  final Future<List<ContentItem>> future;
  final Function(ContentItem) onItemTap;
  final VoidCallback? onSeeAll;

  const ContentHorizontalList({
    super.key,
    required this.title,
    required this.future,
    required this.onItemTap,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(title: title, onSeeAll: onSeeAll),
        const SizedBox(height: 16),
        SizedBox(
          height: 240,
          child: FutureBuilder<List<ContentItem>>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingState();
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No items found'));
              }

              final items = snapshot.data!;
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  return PosterCard(
                    item: items[index],
                    onTap: () => onItemTap(items[index]),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(width: 16),
      itemBuilder: (_, __) => Container(
        width: 120,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
