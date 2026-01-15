import '../data/models/content_item.dart';
import '../services/tmdb_service.dart';
import '../services/firestore_service.dart';
import '../core/constants/api_constants.dart';

/// Repository that combines TMDB API and Firestore services
/// Acts as the single source of truth for content data
class ContentRepository {
  final TmdbService _tmdb = TmdbService();
  final FirestoreService _firestore = FirestoreService();

  // ==================== TMDB API Methods ====================

  /// Get trending movies
  Future<List<ContentItem>> trendingNow() => _tmdb.getTrendingMovies();

  /// Get top rated movies
  Future<List<ContentItem>> topRated() => _tmdb.getTopRatedMovies();

  /// Get upcoming movies
  Future<List<ContentItem>> forYou() => _tmdb.getUpcomingMovies();

  /// Get trending TV series
  Future<List<ContentItem>> trendingSeries() => _tmdb.getTrendingSeries();

  /// Search movies by query
  Future<List<ContentItem>> searchMovies(String query) =>
      _tmdb.searchMovies(query);

  /// Search TV series by query
  Future<List<ContentItem>> searchTV(String query) => _tmdb.searchTV(query);

  /// Search all content (movies + TV)
  Future<List<ContentItem>> searchMulti(String query) =>
      _tmdb.searchMulti(query);

  /// Search with filter option
  Future<List<ContentItem>> search(String query, {String filter = 'all'}) {
    final f = filter.toLowerCase();
    if (f == 'movies' || f == 'movie') return searchMovies(query);
    if (f == 'tv' || f == 'series') return searchTV(query);
    return searchMulti(query);
  }

  // ==================== WATCHLIST ====================

  /// Stream of watchlist items
  Stream<List<ContentItem>> get watchlistStream => _firestore.getWatchlist();

  /// Check if item is in watchlist
  Future<bool> isInWatchlist(String itemId) => _firestore.isInWatchlist(itemId);

  /// Toggle watchlist status
  Future<void> toggleWatchlist(ContentItem item) async {
    if (await isInWatchlist(item.id)) {
      await _firestore.removeFromWatchlist(item.id);
    } else {
      await _firestore.addToWatchlist(item);
    }
  }

  // ==================== FAVORITES ====================

  /// Stream of favorite items
  Stream<List<ContentItem>> get favoritesStream => _firestore.getFavorites();

  /// Check if item is in favorites
  Future<bool> isInFavorites(String itemId) => _firestore.isInFavorites(itemId);

  /// Toggle favorite status
  Future<void> toggleFavorite(ContentItem item) async {
    if (await isInFavorites(item.id)) {
      await _firestore.removeFromFavorites(item.id);
    } else {
      await _firestore.addToFavorites(item);
    }
  }

  // ==================== WATCHED ====================

  /// Stream of watched items
  Stream<List<ContentItem>> get watchedStream => _firestore.getWatched();

  /// Check if item has been watched
  Future<bool> isWatched(String itemId) => _firestore.isWatched(itemId);

  /// Toggle watched status
  Future<void> toggleWatched(ContentItem item) async {
    if (await isWatched(item.id)) {
      await _firestore.removeFromWatched(item.id);
    } else {
      await _firestore.addToWatched(item);
    }
  }

  // ==================== DETAILS ====================

  /// Get detailed information for a content item
  Future<Map<String, dynamic>> getDetails(ContentItem item) async {
    final idParts = item.id.split('_');
    if (idParts.length != 2) throw Exception("Invalid item ID format");

    final type = idParts.first;
    final id = idParts.last;
    final isMovie = type == 'movie';

    final data = await _tmdb.getDetails(id, isMovie);

    return {
      'item': item,
      'genres': (data['genres'] as List? ?? [])
          .map((g) => g['name'] as String)
          .join(', '),
      'runtime': isMovie
          ? data['runtime'] as int? ?? 0
          : (data['episode_run_time'] as List?)?.first as int? ?? 0,
      'overview': data['overview'] ?? 'No overview available.',
      'backdropUrl': data['backdrop_path'] != null
          ? '${ApiConstants.imageBaseUrl}${data['backdrop_path']}'
          : item.imageUrl,
      'votePercent': (((data['vote_average'] as num?)?.toDouble() ?? 0.0) * 10)
          .toInt(),
      'cast': (data['credits']?['cast'] as List? ?? [])
          .take(10)
          .map(
            (c) => {
              'name': c['name'] ?? 'Unknown',
              'profileUrl': c['profile_path'] != null
                  ? '${ApiConstants.imageBaseUrl}${c['profile_path']}'
                  : 'https://placehold.co/200x300.png?text=No+Image',
            },
          )
          .toList(),
      'recommendations': (data['recommendations']?['results'] as List? ?? [])
          .map((r) => ContentItem.fromJson(r))
          .toList(),
    };
  }
}
