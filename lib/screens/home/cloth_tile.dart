import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wardrobe/models/clothes.dart';

class ClothTile extends StatelessWidget {
  final QueryDocumentSnapshot? cloth1;
  const ClothTile({this.cloth1});

  @override
  Widget build(BuildContext context) {
    var data = cloth1!.data() as Map<String, dynamic>;
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
          margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: ListTile(
            leading: Image.network(data["imageUrl"] ?? '') ,
            title: Text(data["cloth"] ?? ''),
            subtitle: Text(data["type"] ?? ''),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('clothes')
                    .doc(cloth1!.id)
                    .delete();
              },
            ),
          )
      )
    );
  }
}