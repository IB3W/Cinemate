import '../../core/constants/api_constants.dart';

/// Represents a movie or TV show item
class ContentItem {
  final String id;
  final String title;
  final String imageUrl;
  final double rating;
  final String year;

  ContentItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.rating,
    required this.year,
  });

  /// Factory constructor to create ContentItem from TMDB API JSON response
  factory ContentItem.fromJson(Map<String, dynamic> json) {
    final isMovie = json.containsKey('title');
    final date = isMovie ? json['release_date'] : json['first_air_date'];
    final year = (date != null && date.length >= 4)
        ? date.substring(0, 4)
        : 'N/A';

    return ContentItem(
      id: '${isMovie ? 'movie' : 'tv'}_${json['id']}',
      title: json['title'] ?? json['name'] ?? 'Unknown',
      imageUrl: json['poster_path'] != null
          ? '${ApiConstants.imageBaseUrl}${json['poster_path']}'
          : 'https://placehold.co/400x600/121A24/FFF?text=No+Image',
      rating: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      year: year,
    );
  }

  /// Factory constructor to create ContentItem from Firestore document
  factory ContentItem.fromFirestore(Map<String, dynamic> data) {
    return ContentItem(
      id: data['id'] as String,
      title: data['title'] as String,
      imageUrl: data['imageUrl'] as String,
      rating: (data['rating'] as num).toDouble(),
      year: data['year'] as String,
    );
  }

  /// Convert ContentItem to JSON for Firestore storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'rating': rating,
      'year': year,
    };
  }
}
