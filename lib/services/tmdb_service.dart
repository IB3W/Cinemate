import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';
import '../data/models/content_item.dart';

/// Service class for fetching data from TMDB API
class TmdbService {
  /// Get trending movies of the day
  Future<List<ContentItem>> getTrendingMovies() async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}/trending/movie/day?api_key=${ApiConstants.apiKey}',
    );
    return _fetchContent(url);
  }

  /// Get top rated movies
  Future<List<ContentItem>> getTopRatedMovies() async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}/movie/top_rated?api_key=${ApiConstants.apiKey}&language=en-US&page=1',
    );
    return _fetchContent(url);
  }

  /// Get upcoming movies
  Future<List<ContentItem>> getUpcomingMovies() async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}/movie/upcoming?api_key=${ApiConstants.apiKey}&language=en-US&page=1',
    );
    return _fetchContent(url);
  }

  /// Get trending TV series of the day
  Future<List<ContentItem>> getTrendingSeries() async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}/trending/tv/day?api_key=${ApiConstants.apiKey}',
    );
    return _fetchContent(url);
  }

  /// Get detailed information for a movie or TV show
  Future<Map<String, dynamic>> getDetails(String id, bool isMovie) async {
    final type = isMovie ? 'movie' : 'tv';
    final url = Uri.parse(
      '${ApiConstants.baseUrl}/$type/$id?api_key=${ApiConstants.apiKey}&append_to_response=credits,recommendations',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load details: $e');
    }
  }

  /// Search for movies by query
  Future<List<ContentItem>> searchMovies(String query) async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}/search/movie?query=$query&api_key=${ApiConstants.apiKey}',
    );
    return _fetchContent(url);
  }

  /// Search for TV series by query
  Future<List<ContentItem>> searchTV(String query) async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}/search/tv?query=$query&api_key=${ApiConstants.apiKey}',
    );
    return _fetchContent(url);
  }

  /// Search for both movies and TV series
  Future<List<ContentItem>> searchMulti(String query) async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}/search/multi?query=$query&api_key=${ApiConstants.apiKey}',
    );
    return _fetchContent(url, allowPerson: false);
  }

  /// Internal method to fetch and parse content from TMDB API
  Future<List<ContentItem>> _fetchContent(
    Uri url, {
    bool allowPerson = true,
  }) async {
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'];

        if (allowPerson) {
          return results.map((e) => ContentItem.fromJson(e)).toList();
        }

        // Exclude results of type 'person' for multi-search
        return results
            .where((e) => e['media_type'] != 'person')
            .map((e) => ContentItem.fromJson(e))
            .toList();
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      return [];
    }
  }
}
