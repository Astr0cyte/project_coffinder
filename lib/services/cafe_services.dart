import 'package:brewstreet_app/models/cafe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CafeService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Stream<List<Cafe>> getCafes() {
    return _firestore
        .collection('cafes')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Cafe.fromFirestore(doc))
              .toList(),
        );
  }
}