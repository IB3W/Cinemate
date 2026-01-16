import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/widgets/poster_card.dart';
import '../../../data/models/content_item.dart';
import '../../../repositories/content_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ContentRepository _repository = ContentRepository();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  // State variables
  List<ContentItem> _results = [];
  bool _isLoading = false;
  String _activeFilter = 'All'; // All, Movies, Series
  final List<String> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
    _loadTrending(); // Load initial content
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // Load recent searches from SharedPrefs
  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches.addAll(prefs.getStringList('recent_searches') ?? []);
    });
  }

  // Save query to SharedPrefs
  Future<void> _saveSearch(String query) async {
    if (query.isEmpty) return;
    if (!_recentSearches.contains(query)) {
      setState(() {
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 5) _recentSearches.removeLast();
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('recent_searches', _recentSearches);
    }
  }

  // Load trending content when search is empty
  Future<void> _loadTrending() async {
    setState(() => _isLoading = true);
    try {
      final items = await _repository.trendingNow();
      setState(() => _results = items);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Perform search
  Future<void> _doSearch(String query) async {
    if (query.isEmpty) {
      _loadTrending();
      return;
    }

    setState(() => _isLoading = true);
    try {
      List<ContentItem> results;
      if (_activeFilter == 'Movies') {
        results = await _repository.searchMovies(query);
      } else if (_activeFilter == 'Series') {
        results = await _repository.searchTV(query);
      } else {
        results = await _repository.searchMulti(query);
      }
      setState(() => _results = results);
    } catch (e) {
      debugPrint('Search error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Handle text input with debounce
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _doSearch(query);
      _saveSearch(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Search Bar
                  TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Search movies, series...',
                      filled: true,
                      fillColor: Colors.grey[900],
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.white54,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.white54,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                _doSearch('');
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Filters
                  Row(
                    children: ['All', 'Movies', 'Series'].map((filter) {
                      final isSelected = _activeFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _activeFilter = filter);
                              _doSearch(_searchController.text);
                            }
                          },
                          backgroundColor: Colors.grey[900],
                          selectedColor: Colors.orange,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.white60,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide.none,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _results.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.movie_filter_outlined,
                            size: 64,
                            color: Colors.grey[800],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No results found',
                            style: TextStyle(color: Colors.white54),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio:
                                2 / 3.4, // Adjusted for poster + text
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemCount: _results.length,
                      itemBuilder: (context, index) {
                        return PosterCard(
                          item: _results[index],
                          showMeta: false, // Cleaner look for grid
                          width: double.infinity,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/details',
                              arguments: _results[index],
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
