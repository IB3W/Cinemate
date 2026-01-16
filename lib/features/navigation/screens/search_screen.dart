import 'package:flutter/material.dart';
import '../../../core/widgets/poster_card.dart';
import '../../../data/models/content_item.dart';
import '../../../repositories/content_repository.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _repository = ContentRepository();
  final _searchController = TextEditingController();

  List<ContentItem> _results = [];
  bool _isLoading = false;
  String _activeFilter = 'All';

  @override
  void initState() {
    super.initState();
    _loadTrending();
  }

  Future<void> _loadTrending() async {
    setState(() => _isLoading = true);
    final items = await _repository.trendingNow();
    setState(() {
      _results = items;
      _isLoading = false;
    });
  }

  Future<void> _doSearch(String query) async {
    if (query.isEmpty) {
      _loadTrending();
      return;
    }

    setState(() => _isLoading = true);
    List<ContentItem> results;

    if (_activeFilter == 'Movies') {
      results = await _repository.searchMovies(query);
    } else if (_activeFilter == 'Series') {
      results = await _repository.searchTV(query);
    } else {
      results = await _repository.searchMulti(query);
    }

    setState(() {
      _results = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchHeader(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildResultsGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onSubmitted: (value) => _doSearch(value),
            decoration: InputDecoration(
              hintText: 'Search...',
              filled: true,
              fillColor: Colors.grey[900],
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  _doSearch('');
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildFilterChips(),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Row(
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
            selectedColor: Colors.orange,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildResultsGrid() {
    if (_results.isEmpty) {
      return const Center(child: Text('No results found'));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _results.length,
      itemBuilder: (context, index) {
        return PosterCard(
          item: _results[index],
          showMeta: false,
          onTap: () => Navigator.pushNamed(
            context,
            '/details',
            arguments: _results[index],
          ),
        );
      },
    );
  }
}
