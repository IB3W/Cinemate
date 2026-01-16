import 'package:flutter/material.dart';
import '../../../data/models/content_item.dart';
import '../../../repositories/content_repository.dart';
import '../../../core/theme/app_theme.dart';

class DetailsScreen extends StatefulWidget {
  final ContentItem item;

  const DetailsScreen({super.key, required this.item});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final _repository = ContentRepository();
  bool _isLoading = true;
  Map<String, dynamic>? _details;

  // Status states
  bool _isInWatchlist = false;
  bool _isWatched = false;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Parallel loading is fast and keeps the app smooth
      final results = await Future.wait([
        _repository
            .getDetails(widget.item)
            .catchError((e) => <String, dynamic>{}),
        _repository.isInWatchlist(widget.item.id).catchError((e) => false),
        _repository.isWatched(widget.item.id).catchError((e) => false),
        _repository.isInFavorites(widget.item.id).catchError((e) => false),
      ]);

      if (mounted) {
        setState(() {
          _details = results[0] as Map<String, dynamic>;
          _isInWatchlist = results[1] as bool;
          _isWatched = results[2] as bool;
          _isFavorite = results[3] as bool;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleStatus(String type) async {
    if (type == 'watchlist') {
      await _repository.toggleWatchlist(widget.item);
      setState(() => _isInWatchlist = !_isInWatchlist);
    } else if (type == 'watched') {
      await _repository.toggleWatched(widget.item);
      setState(() => _isWatched = !_isWatched);
    } else if (type == 'favorite') {
      await _repository.toggleFavorite(widget.item);
      setState(() => _isFavorite = !_isFavorite);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Status Updated'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the first genre from the list
    final genre = _details?['genres']?.toString().split(',').first ?? '...';

    return Scaffold(
      backgroundColor: AppTheme.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Details'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Header Backdrop Image
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    _details?['backdropUrl'] ?? widget.item.imageUrl,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.3),
                      AppTheme.background,
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // 2. Movie Title
                  Text(
                    widget.item.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 3. Metadata: Year • Genre
                  Text(
                    '${widget.item.year}  •  $genre',
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 4. Rating Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.border,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          widget.item.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 5. Watchlist Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () => _toggleStatus('watchlist'),
                      icon: Icon(
                        _isInWatchlist ? Icons.check : Icons.add,
                        color: Colors.black,
                      ),
                      label: Text(
                        _isInWatchlist ? 'In Watchlist' : 'Add to Watchlist',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 6. Action Cards Row
                  Row(
                    children: [
                      _buildActionItem(
                        Icons.check_circle_outline,
                        'Watched',
                        _isWatched,
                        () => _toggleStatus('watched'),
                      ),
                      const SizedBox(width: 10),
                      _buildActionItem(
                        Icons.favorite_border,
                        'Favorite',
                        _isFavorite,
                        () => _toggleStatus('favorite'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // 7. Summary Text
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _isLoading
                          ? 'Loading summary...'
                          : (_details?['overview'] ?? 'No summary available.'),
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 8. Cast List
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Cast',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Horizontal Cast List
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (_details?['cast'] == null ||
                      (_details?['cast'] as List).isEmpty)
                    const Text(
                      'No cast info available.',
                      style: TextStyle(color: AppTheme.textSecondary),
                    )
                  else
                    SizedBox(
                      height: 160,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: (_details?['cast'] as List).length,
                        itemBuilder: (context, index) {
                          final actor = (_details?['cast'] as List)[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    actor['profileUrl'],
                                    width: 90,
                                    height: 120,
                                    fit: BoxFit.cover,
                                    errorBuilder: (ctx, err, st) => Container(
                                      width: 90,
                                      height: 120,
                                      color: AppTheme.cardColor,
                                      child: const Icon(
                                        Icons.person,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: 90,
                                  child: Text(
                                    actor['name'],
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper for the 3 small action buttons (Watched, Favorite, Rate)
  Widget _buildActionItem(
    IconData icon,
    String label,
    bool isActive,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: isActive ? Border.all(color: AppTheme.primary) : null,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isActive ? AppTheme.primary : AppTheme.textSecondary,
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? AppTheme.primary : AppTheme.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
