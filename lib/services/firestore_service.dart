import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/models/content_item.dart';

/// Service class for managing user data in Firestore
/// Handles watchlist, favorites, and watched collections
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Get current user's ID
  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  /// Get a typed collection reference for user data
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

  // ==================== WATCHLIST ====================

  /// Stream of user's watchlist items
  Stream<List<ContentItem>> getWatchlist() => _userCollection(
    'watchlist',
  ).snapshots().map((s) => s.docs.map((d) => d.data()).toList());

  /// Add item to watchlist
  Future<void> addToWatchlist(ContentItem item) =>
      _userCollection('watchlist').doc(item.id).set(item);

  /// Remove item from watchlist
  Future<void> removeFromWatchlist(String itemId) =>
      _userCollection('watchlist').doc(itemId).delete();

  /// Check if item is in watchlist
  Future<bool> isInWatchlist(String itemId) async =>
      (await _userCollection('watchlist').doc(itemId).get()).exists;

  // ==================== FAVORITES ====================

  /// Stream of user's favorite items
  Stream<List<ContentItem>> getFavorites() => _userCollection(
    'favorites',
  ).snapshots().map((s) => s.docs.map((d) => d.data()).toList());

  /// Add item to favorites
  Future<void> addToFavorites(ContentItem item) =>
      _userCollection('favorites').doc(item.id).set(item);

  /// Remove item from favorites
  Future<void> removeFromFavorites(String itemId) =>
      _userCollection('favorites').doc(itemId).delete();

  /// Check if item is in favorites
  Future<bool> isInFavorites(String itemId) async =>
      (await _userCollection('favorites').doc(itemId).get()).exists;

  // ==================== WATCHED ====================

  /// Stream of user's watched items
  Stream<List<ContentItem>> getWatched() => _userCollection(
    'watched',
  ).snapshots().map((s) => s.docs.map((d) => d.data()).toList());

  /// Add item to watched
  Future<void> addToWatched(ContentItem item) =>
      _userCollection('watched').doc(item.id).set(item);

  /// Remove item from watched
  Future<void> removeFromWatched(String itemId) =>
      _userCollection('watched').doc(itemId).delete();

  /// Check if item has been watched
  Future<bool> isWatched(String itemId) async =>
      (await _userCollection('watched').doc(itemId).get()).exists;
}
