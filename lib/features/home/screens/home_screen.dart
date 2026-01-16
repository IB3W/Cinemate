import 'package:flutter/material.dart';
import '../../../core/widgets/poster_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../../data/models/content_item.dart';
import '../../../repositories/content_repository.dart';
// Note: SeeAllScreen and DetailsScreen imports will be added later when those screens are created

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Using Repository pattern
  final _repository = ContentRepository();

  // Futures for data fetching
  late Future<List<ContentItem>> _trendingMovies;
  late Future<List<ContentItem>> _trendingSeries;
  late Future<List<ContentItem>> _topRatedMovies;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _trendingMovies = _repository.trendingNow();
    _trendingSeries = _repository.trendingSeries();
    _topRatedMovies = _repository.topRated();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome back 👋',
                        style: TextStyle(color: Colors.white54, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Let\'s relax',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?img=11',
                    ),
                    radius: 20,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Search Bar Placeholder
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Colors.white54),
                    SizedBox(width: 12),
                    Text(
                      'Search movies...',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Trending Movies Section
              _buildHorizontalSection('Trending Movies', _trendingMovies, () {
                // TODO: Navigate to SeeAllScreen
              }),

              const SizedBox(height: 24),

              // Trending Series Section
              _buildHorizontalSection('Trending Series', _trendingSeries, () {
                // TODO: Navigate to SeeAllScreen
              }),

              const SizedBox(height: 24),

              // Top Rated Section
              _buildHorizontalSection('Top Rated', _topRatedMovies, () {
                // TODO: Navigate to SeeAllScreen
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalSection(
    String title,
    Future<List<ContentItem>> future,
    VoidCallback onSeeAll,
  ) {
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
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/details',
                        arguments: items[index],
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
