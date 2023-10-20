import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class ClothList extends StatefulWidget {
  const ClothList({super.key});

  @override
  State<ClothList> createState() => _ClothListState();
}

class _ClothListState extends State<ClothList> {
  @override
  Widget build(BuildContext context) {
    final clothes = Provider.of<QuerySnapshot?>(context);
    // print(clothes?.docs);
    for(var cloth in clothes?.docs ?? []){
      print(cloth.data());
    }
    return const Placeholder();
  }
}