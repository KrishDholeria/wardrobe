import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wardrobe/models/clothes.dart';
import 'package:wardrobe/models/clothesWithId.dart';

class DatabaseService {
  String uid;
  DatabaseService({this.uid = ""});

  // collection reference
  final CollectionReference clothesCollection =
      FirebaseFirestore.instance.collection('clothes');

  Future<void> updateUserData(String name, String cloth, String color, String type, String imageUrl) async {
    return await clothesCollection.doc(uid).set({
      'name': name,
      'cloth': cloth,
      'color': color,
      'type': type,
      'imageUrl': imageUrl,
    });
  }

  Future<void> addCloth(String name, String cloth, String color, String type, String imageUrl) async {
    return await clothesCollection.add({
      'name': name,
      'cloth': cloth,
      'color': color,
      'type': type,
      'imageUrl': imageUrl,
    })
    .then((value) => {print(value)});
  }

  Future<void> updateCloth(String cid, String name, String cloth, String color, String type, String imageUrl) async {
    print(clothesCollection.doc(cid));
    return await clothesCollection.doc(cid).update({
      'name': name,
      'cloth': cloth,
      'color': color,
      'type': type,
      'imageUrl': imageUrl,
    });
  }

  //clothes list from snapshots with id
  List<String> _clothesListFromSnapshotWithId(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      dynamic data = doc.data();
      return doc.id;
    }).toList();
  }
  List<QueryDocumentSnapshot> _clothesListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.toList();
  }

  // get wardrobe stream
  Stream<List<QueryDocumentSnapshot>> get clothes {
    return clothesCollection.snapshots()
    .map(_clothesListFromSnapshot);
  }
}