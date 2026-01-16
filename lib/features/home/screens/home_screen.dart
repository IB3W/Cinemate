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
      appBar: AppBar(
        title: const Text(
          'Cinamate',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ContentHorizontalList(
                title: 'Trending Movies',
                future: _trendingMovies,
                onItemTap: (item) => _navigateToDetails(item),
                onSeeAll: () async {
                  final items = await _trendingMovies;
                  _navigateToSeeAll('Trending Movies', items);
                },
              ),
              const SizedBox(height: 24),

              ContentHorizontalList(
                title: 'Trending Series',
                future: _trendingSeries,
                onItemTap: (item) => _navigateToDetails(item),
                onSeeAll: () async {
                  final items = await _trendingSeries;
                  _navigateToSeeAll('Trending Series', items);
                },
              ),
              const SizedBox(height: 24),

              ContentHorizontalList(
                title: 'Top Rated',
                future: _topRatedMovies,
                onItemTap: (item) => _navigateToDetails(item),
                onSeeAll: () async {
                  final items = await _topRatedMovies;
                  _navigateToSeeAll('Top Rated', items);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToDetails(ContentItem item) {
    Navigator.pushNamed(context, '/details', arguments: item);
  }

  void _navigateToSeeAll(String title, List<ContentItem> items) {
    Navigator.pushNamed(
      context,
      '/see-all',
      arguments: {'title': title, 'items': items},
    );
  }
}
