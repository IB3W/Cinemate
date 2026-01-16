import 'package:flutter/material.dart';
import '../../../core/widgets/content_horizontal_list.dart';
import '../../../data/models/content_item.dart';
import '../../../repositories/content_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _repository = ContentRepository();

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
              _buildHeader(),
              const SizedBox(height: 24),
              _buildSearchPlaceholder(),
              const SizedBox(height: 24),

              ContentHorizontalList(
                title: 'Trending Movies',
                future: _trendingMovies,
                onItemTap: (item) => _navigateToDetails(item),
              ),
              const SizedBox(height: 24),

              ContentHorizontalList(
                title: 'Trending Series',
                future: _trendingSeries,
                onItemTap: (item) => _navigateToDetails(item),
              ),
              const SizedBox(height: 24),

              ContentHorizontalList(
                title: 'Top Rated',
                future: _topRatedMovies,
                onItemTap: (item) => _navigateToDetails(item),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back 👋',
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
            SizedBox(height: 4),
            Text(
              'Let\'s relax',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        CircleAvatar(
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
          radius: 20,
        ),
      ],
    );
  }

  Widget _buildSearchPlaceholder() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Icon(Icons.search, color: Colors.white54),
          SizedBox(width: 12),
          Text('Search movies...', style: TextStyle(color: Colors.white54)),
        ],
      ),
    );
  }

  void _navigateToDetails(ContentItem item) {
    Navigator.pushNamed(context, '/details', arguments: item);
  }
}
