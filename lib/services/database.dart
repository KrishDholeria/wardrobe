import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  // collection reference
  final CollectionReference wardrobeCollection =
      FirebaseFirestore.instance.collection('wardrobe');

  Future<void> updateUserData(String name, String cloth, String color, String type) async {
    return await wardrobeCollection.doc(uid).set({
      'name': name,
      'cloth': cloth,
      'color': color,
      'type': type,
    });
  }
}