import '../data/models/content_item.dart';
import '../services/tmdb_service.dart';
import '../services/firestore_service.dart';

class ContentRepository {
  final TmdbService _tmdb = TmdbService();
  final FirestoreService _firestore = FirestoreService();

  // ==================== TMDB API Methods ====================
  Future<List<ContentItem>> trendingNow() => _tmdb.getTrendingMovies();

  Future<List<ContentItem>> topRated() => _tmdb.getTopRatedMovies();

  Future<List<ContentItem>> forYou() => _tmdb.getUpcomingMovies();

  Future<List<ContentItem>> trendingSeries() => _tmdb.getTrendingSeries();

  Future<List<ContentItem>> searchMovies(String query) => _tmdb.searchMovies(query);

  Future<List<ContentItem>> searchTV(String query) => _tmdb.searchTV(query);

  Future<List<ContentItem>> searchMulti(String query) =>_tmdb.searchMulti(query);

  Future<List<ContentItem>> search(String query, {String filter = 'all'}) {
    final f = filter.toLowerCase();
    if (f == 'movies' || f == 'movie') return searchMovies(query);
    if (f == 'tv' || f == 'series') return searchTV(query);
    return searchMulti(query);
  }

  // ==================== WATCHLIST ====================

  Stream<List<ContentItem>> get watchlistStream => _firestore.getWatchlist();
  Future<bool> isInWatchlist(String itemId) => _firestore.isInWatchlist(itemId);
  Future<void> toggleWatchlist(ContentItem item) async {
    (await isInWatchlist(item.id))
        ? await _firestore.removeFromWatchlist(item.id)
        : await _firestore.addToWatchlist(item);
  }

  // ==================== FAVORITES ====================

  Stream<List<ContentItem>> get favoritesStream => _firestore.getFavorites();
  Future<bool> isInFavorites(String itemId) => _firestore.isInFavorites(itemId);
  Future<void> toggleFavorite(ContentItem item) async {
    (await isInFavorites(item.id))
        ? await _firestore.removeFromFavorites(item.id)
        : await _firestore.addToFavorites(item);
  }

  // ==================== WATCHED ====================

  Stream<List<ContentItem>> get watchedStream => _firestore.getWatched();
  Future<bool> isWatched(String itemId) => _firestore.isWatched(itemId);
  Future<void> toggleWatched(ContentItem item) async {
    (await isWatched(item.id))
        ? await _firestore.removeFromWatched(item.id)
        : await _firestore.addToWatched(item);
  }

  // ==================== DETAILS ====================

  Future<Map<String, dynamic>> getDetails(ContentItem item) async {
    final idParts = item.id.split('_');
    final data = await _tmdb.getDetails(idParts.last, idParts.first == 'movie');

    return {
      'overview': data['overview'] ?? 'No summary.',
      'backdropUrl': data['backdrop_path'] != null
          ? 'https://image.tmdb.org/t/p/w780${data['backdrop_path']}'
          : item.imageUrl,
      'cast': (data['credits']?['cast'] as List? ?? []).take(10).toList(),
      'genres': (data['genres'] as List? ?? [])
          .map((g) => g['name'])
          .join(', '),
    };
  }
}
