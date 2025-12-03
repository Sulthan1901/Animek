import 'package:anime_verse/models/anime.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Colection refences
  CollectionReference _usersCollection() {
    return _firestore.collection('users');
  }

  Stream<List<Anime>> getFavoriteStream(String userId) {
    return _usersCollection()
        .doc(userId)
        .collection('favorites')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Anime.fromFavoritesJson(doc.data());
          }).toList();
        });
  }

  //add Favorites
  Future<void> addFavorite(String userId, Anime anime) {
    return _usersCollection()
        .doc(userId)
        .collection('favorites')
        .doc(anime.malId.toString())
        .set(anime.toJson());
  }

  //remove Favorites
  Future<void> removeFavorite(String userId, int animeId) {
    return _usersCollection()
        .doc(userId)
        .collection('favorites')
        .doc(animeId.toString())
        .delete();
  }

  // Firestore service implementation goes here
}
