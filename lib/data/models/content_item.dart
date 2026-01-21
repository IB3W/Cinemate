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

  factory ContentItem.fromJson(Map<String, dynamic> json) {
    final isMovie = json.containsKey('title');
    final date =
        (isMovie ? json['release_date'] : json['first_air_date']) as String? ??'';
    return ContentItem(
      id: '${isMovie ? 'movie' : 'tv'}_${json['id']}',
      title: (isMovie ? json['title'] : json['name']) ?? 'Unknown',
      imageUrl: _getImageUrl(json['poster_path']),
      rating: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      year: date.length >= 4 ? date.substring(0, 4) : 'N/A',
    );
  }

  static String _getImageUrl(String? path) => path == null? 'https://placehold.co/400x600/121A24/FFF?text=No+Image': 'https://image.tmdb.org/t/p/w500$path';

  factory ContentItem.fromFirestore(Map<String, dynamic> data) => ContentItem(
    id: data['id'],
    title: data['title'],
    imageUrl: data['imageUrl'],
    rating: (data['rating'] as num).toDouble(),
    year: data['year'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'imageUrl': imageUrl,
    'rating': rating,
    'year': year,
  };
}
