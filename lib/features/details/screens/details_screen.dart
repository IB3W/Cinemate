import 'package:flutter/material.dart';
import '../../../data/models/content_item.dart';
import '../../../repositories/content_repository.dart';

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
  bool _isInWatchlist = false;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    final details = await _repository.getDetails(widget.item);
    final inWatchlist = await _repository.isInWatchlist(widget.item.id);
    setState(() {
      _details = details;
      _isInWatchlist = inWatchlist;
      _isLoading = false;
    });
  }

  Future<void> _toggleWatchlist() async {
    await _repository.toggleWatchlist(widget.item);
    setState(() => _isInWatchlist = !_isInWatchlist);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isInWatchlist ? 'Added' : 'Removed'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.title),
        backgroundColor: Colors.transparent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Simplified Image with Rounded Corners
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      _details?['backdropUrl'] ?? widget.item.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title and Rating Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.item.year,
                        style: const TextStyle(color: Colors.white54),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            widget.item.rating.toStringAsFixed(1),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Integrated Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                          child: const Text(
                            'Play Trailer',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _toggleWatchlist,
                          icon: Icon(
                            _isInWatchlist ? Icons.check : Icons.add,
                            color: Colors.white,
                          ),
                          label: Text(
                            _isInWatchlist ? 'Watchlist' : 'Add List',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Description Text
                  const Text(
                    'Overview',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _details?['overview'] ?? '',
                    style: const TextStyle(color: Colors.white70, height: 1.5),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }
}
