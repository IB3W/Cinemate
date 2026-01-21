import 'package:flutter/material.dart';
import '../../../data/models/content_item.dart';
import '../../../repositories/content_repository.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/poster_card.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = ContentRepository();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          title: const Text('My Library'),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: AppTheme.primary,
            labelColor: AppTheme.primary,
            unselectedLabelColor: AppTheme.textSecondary,
            tabs: [
              Tab(text: 'Watchlist'),
              Tab(text: 'Favorites'),
              Tab(text: 'Watched'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildLibraryList(
              repository.watchlistStream,
              'Your watchlist is empty',
            ),
            _buildLibraryList(repository.favoritesStream, 'No favorites yet'),
            _buildLibraryList(
              repository.watchedStream,
              'You haven\'t watched anything yet',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLibraryList(
    Stream<List<ContentItem>> stream,
    String emptyMessage,
  ) {
    return StreamBuilder<List<ContentItem>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primary),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final items = snapshot.data ?? [];

        if (items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.movie_outlined,
                  size: 64,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(height: 16),
                Text(
                  emptyMessage,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
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
              onTap: () => Navigator.pushNamed(
                context,
                '/details',
                arguments: items[index],
              ),
            );
          },
        );
      },
    );
  }
}
