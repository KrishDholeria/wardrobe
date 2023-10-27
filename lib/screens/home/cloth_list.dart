import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:wardrobe/models/clothes.dart';
import 'package:wardrobe/models/clothesWithId.dart';
import 'package:wardrobe/screens/home/cloth_tile.dart';
import 'package:wardrobe/services/database.dart';

class ClothList extends StatefulWidget {
  final Function setCloth;
  final Function changeShowForm;
  final String occasion;
  const ClothList(
      {super.key, required this.setCloth, required this.changeShowForm, this.occasion = ''});

  @override
  State<ClothList> createState() => _ClothListState();
}

class _ClothListState extends State<ClothList> {
  @override

  Widget build(BuildContext context) {
    final clothesSnapshots = Provider.of<List<QueryDocumentSnapshot>?>(context);
    print(clothesSnapshots);
    if (clothesSnapshots != null) {
      for (var clothSnapshot in clothesSnapshots) {
        var data = clothSnapshot.data() as Map<String, dynamic>;
        print(data['name']);
        print(data['cloth']);
        print(data['color']);
        print(data['type']);
        print(data['imageUrl']);
        print("HELLO");
        print(clothSnapshot.id);
      }
    }
    if(widget.occasion != 'Select an occasion'){
      return ListView.builder(
        itemCount: clothesSnapshots?.length ?? 0,
        itemBuilder: (context, index) {
          var data;
          data = clothesSnapshots?[index].data();
          if(data['type'] == widget.occasion){
            return GestureDetector(
              onTap: () {
                var data;
                data = clothesSnapshots?[index].data();
                widget.setCloth(ClothesWithId(
                  cid: clothesSnapshots![index].id,
                  name: data['name'] ?? '',
                  cloth: data['cloth'] ?? '',
                  color: data['color'] ?? '',
                  type: data['type'] ?? '',
                  imageUrl: data['imageUrl'] ?? '',
                )); // Pass the document ID
                widget.changeShowForm(true);
              },
              child: ClothTile(cloth1: clothesSnapshots?[index]),
            );
          }
          return Container();
        },
      );
    }

    return ListView.builder(
      itemCount: clothesSnapshots?.length ?? 0,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            var data;
            data = clothesSnapshots?[index].data();
            widget.setCloth(ClothesWithId(
              cid: clothesSnapshots![index].id,
              name: data['name'] ?? '',
              cloth: data['cloth'] ?? '',
              color: data['color'] ?? '',
              type: data['type'] ?? '',
              imageUrl: data['imageUrl'] ?? '',
            )); // Pass the document ID
            widget.changeShowForm(true);
          },
          child: ClothTile(cloth1: clothesSnapshots?[index]),
        );
      },
    );
  }
}
