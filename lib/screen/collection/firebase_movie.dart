import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseMovie {
  FirebaseFirestore db = FirebaseFirestore.instance;

  void readMovies() {
    db.collection('movies').get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        print('season: ' + doc['season']);
        print('episode: ' + doc['episode']);
        print('title: ' + doc['title']);
        print('name: ' + doc['name']);
        print('youtube_id: ' + doc['youtube_id']);
      }
    });
  }
}
