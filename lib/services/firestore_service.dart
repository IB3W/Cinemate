import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/models/content_item.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  CollectionReference<ContentItem> _userCollection(String collectionName) {
    final userId = _userId;
    if (userId == null) throw Exception("User not logged in");
    return _db
        .collection('users')
        .doc(userId)
        .collection(collectionName)
        .withConverter(
          fromFirestore: (snapshot, _) =>
              ContentItem.fromFirestore(snapshot.data()!),
          toFirestore: (item, _) => item.toJson(),
        );
  }


  Stream<List<ContentItem>> _getStream(String col) => _userCollection(col).snapshots().map((s) => s.docs.map((d) => d.data()).toList());

  Future<void> _add(String col, ContentItem item) =>_userCollection(col).doc(item.id).set(item);
  Future<void> _remove(String col, String id) => _userCollection(col).doc(id).delete();
  Future<bool> _exists(String col, String id) async => (await _userCollection(col).doc(id).get()).exists;

  // ============Watchlist===========
  Stream<List<ContentItem>> getWatchlist() => _getStream('watchlist');
  Future<void> addToWatchlist(ContentItem item) => _add('watchlist', item);
  Future<void> removeFromWatchlist(String id) => _remove('watchlist', id);
  Future<bool> isInWatchlist(String id) => _exists('watchlist', id);

  // ============Favorites===========
  Stream<List<ContentItem>> getFavorites() => _getStream('favorites');
  Future<void> addToFavorites(ContentItem item) => _add('favorites', item);
  Future<void> removeFromFavorites(String id) => _remove('favorites', id);
  Future<bool> isInFavorites(String id) => _exists('favorites', id);

  // ============Watched===========
  Stream<List<ContentItem>> getWatched() => _getStream('watched');
  Future<void> addToWatched(ContentItem item) => _add('watched', item);
  Future<void> removeFromWatched(String id) => _remove('watched', id);
  Future<bool> isWatched(String id) => _exists('watched', id);
}
