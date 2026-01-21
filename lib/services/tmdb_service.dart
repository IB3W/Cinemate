import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';
import '../data/models/content_item.dart';

class TmdbService {
  Future<List<ContentItem>> getTrendingMovies() => _fetchList('/trending/movie/day');

  Future<List<ContentItem>> getTopRatedMovies() => _fetchList('/movie/top_rated');

  Future<List<ContentItem>> getUpcomingMovies() => _fetchList('/movie/upcoming');

  Future<List<ContentItem>> getTrendingSeries() => _fetchList('/trending/tv/day');

  Future<List<ContentItem>> searchMovies(String query) => _fetchList('/search/movie', query: query);

  Future<List<ContentItem>> searchTV(String query) =>_fetchList('/search/tv', query: query);

  Future<List<ContentItem>> searchMulti(String query) =>_fetchList('/search/multi', query: query);

  Future<Map<String, dynamic>> getDetails(String id, bool isMovie) async {
    final path = isMovie ? 'movie' : 'tv';
    final url = Uri.parse(
      '${ApiConstants.baseUrl}/$path/$id?api_key=${ApiConstants.apiKey}&append_to_response=credits',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) return json.decode(response.body);
    throw Exception('Failed to load details');
  }

  Future<List<ContentItem>> _fetchList(String endpoint, {String? query}) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint').replace(
      queryParameters: {
        'api_key': ApiConstants.apiKey,
        if (query != null && query.isNotEmpty) 'query': query,
      },
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List results = json.decode(response.body)['results'] as List;
        return results.map((e) => ContentItem.fromJson(e)).toList();
      }
    } catch (_) {}

    return [];
  }
}
