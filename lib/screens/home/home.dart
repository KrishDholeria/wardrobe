import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wardrobe/models/clothes.dart';
import 'package:wardrobe/models/clothesWithId.dart';
import 'package:wardrobe/screens/home/settings_form.dart';
import 'package:wardrobe/services/auth.dart';
import 'package:wardrobe/services/database.dart';
import 'package:provider/provider.dart';
import 'package:wardrobe/screens/home/cloth_list.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  bool showForm = false;

  void changeShowForm() {
    setState(() {
      showForm = !showForm;
    });
  }

  ClothesWithId? cloth1;
  void setCloth(ClothesWithId cloth) {
    setState(() {
      cloth1 = cloth;
    });
  }

  bool update = false;
  void setUpdate(bool val) {
    setState(() {
      update = val;
    });
  }

  void toggleView(bool val) {
    setUpdate(val);
    setState(() {
      showForm = false;
    });
  }

  String occasion = 'Select an occasion';
  final List<String> occasions = [
    'Select an occasion',
    'Casual',
    'Formal',
    'Work',
    'Sport',
    'Traditional',
    'Other'
  ];

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<QueryDocumentSnapshot>?>.value(
      value: DatabaseService().clothes,
      initialData: null,
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: const Text('Wardrobe'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              icon: const Icon(Icons.person),
              label: const Text('Logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
            TextButton.icon(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              icon: Icon(Icons.add),
              label: Text('Add'),
              onPressed: () => setState(() {
                changeShowForm();
                setUpdate(false);
                setCloth(ClothesWithId(
                    cid: '',
                    name: '',
                    cloth: '',
                    color: '',
                    type: '',
                    imageUrl: ''));
              }),
            ),
          ],
        ),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Your Wardrobe',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: showForm || update ? Container():  DropdownButtonFormField(
                decoration: const InputDecoration(
                hintText: 'Select an occasion',
              ),
              items: occasions.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (val) => setState(() => occasion = val.toString()),
              ),
            ),
            Expanded(
                child: showForm || update
                    ? SettingssForm(
                        toggleView: toggleView,
                        cloth1: cloth1,
                        update: update,
                      )
                    : ClothList(setCloth: setCloth, changeShowForm: setUpdate, occasion: occasion,)),
          ],
        ),
      ),
    );
  }
}
