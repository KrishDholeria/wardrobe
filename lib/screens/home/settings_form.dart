import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wardrobe/models/clothes.dart';
import 'package:wardrobe/models/clothesWithId.dart';
import 'package:wardrobe/services/database.dart';
import 'package:wardrobe/shared/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingssForm extends StatefulWidget {
  final Function toggleView;
  ClothesWithId? cloth1;
  bool update;
  SettingssForm(
      {super.key, required this.toggleView, this.cloth1, required this.update});

  @override
  State<SettingssForm> createState() => _SettingssFormState();
}

class _SettingssFormState extends State<SettingssForm> {
  final _formKey = GlobalKey<FormState>();

  final List<String> types = [
    'T-Shirt',
    'Shirt',
    'Pants',
    'Shorts',
    'Jacket',
    'Coat',
    'Dress',
    'Skirt',
    'Other'
  ];
  final List<String> colors = [
    'Red',
    'Orange',
    'Yellow',
    'Green',
    'Blue',
    'Purple',
    'Pink',
    'Brown',
    'White',
    'Black',
    'Grey',
    'Other'
  ];
  final List<String> occasions = [
    'Casual',
    'Formal',
    'Work',
    'Sport',
    'Traditional',
    'Other'
  ];

  // form values
  late String _currentName = widget.cloth1?.name ?? '';
  late String _currentCloth = widget.cloth1?.cloth ?? '';
  late String _currentColor = widget.cloth1?.color ?? '';
  late String _currentType = widget.cloth1?.type ?? '';
  late String _currentImage = widget.cloth1?.imageUrl ?? '';

  uploadImage() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final _imagePicker = ImagePicker();
    XFile? image;
    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      image = (await _imagePicker.pickImage(source: ImageSource.camera));
      image ??= (await _imagePicker.pickImage(source: ImageSource.gallery));
      if (image != null) {
        var file = File(image!.path);
        String path = image.name;
        //Upload to Firebase
        var snapshot =
            await _firebaseStorage.ref().child('images/$path').putFile(file);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          _currentImage = downloadUrl;
        });
      } else {
        print('No Image Path Received');
      }
    } else {
      print('Permission not granted. Try Again with permission access');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Text('Add/Update your cloth.', style: TextStyle(fontSize: 18.0)),
            SizedBox(height: 20.0),
            TextFormField(
              decoration: textInputDecoration.copyWith(hintText: 'Name'),
              initialValue: _currentName,
              validator: (val) => val!.isEmpty ? 'Please enter a name' : null,
              onChanged: (val) => setState(() => _currentName = val),
            ),
            SizedBox(height: 10.0),
            // dropdown
            DropdownButtonFormField(
              decoration: const InputDecoration(
                hintText: 'Select a type',
              ),
              value: _currentCloth == '' ? null : _currentCloth,
              items: types.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (val) =>
                  setState(() => _currentCloth = val.toString()),
            ),
            SizedBox(
              height: 10.0,
            ),
            DropdownButtonFormField(
              decoration: const InputDecoration(
                hintText: 'Select a color',
              ),
              value: _currentColor == '' ? null : _currentColor,
              items: colors.map((color) {
                return DropdownMenuItem(
                  value: color,
                  child: Text(color),
                );
              }).toList(),
              onChanged: (val) =>
                  setState(() => _currentColor = val.toString()),
            ),
            SizedBox(height: 10.0),
            DropdownButtonFormField(
              decoration: const InputDecoration(
                hintText: 'Select an occasion',
              ),
              value: _currentType == '' ? null : _currentType,
              items: occasions.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (val) => setState(() => _currentType = val.toString()),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.all(15),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                        border: Border.all(color: Colors.white),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(2, 2),
                            spreadRadius: 2,
                            blurRadius: 1,
                          ),
                        ],
                      ),
                      child: (_currentImage != '')
                          ? Image.network(_currentImage)
                          : Image.network('https://i.imgur.com/sUFH1Aq.png')),
                ],
              ),
            ),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(foregroundColor: Colors.brown[400]),
              onPressed: () async {
                await uploadImage();
              },
              child: const Text(
                'Upload Image',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(foregroundColor: Colors.brown[400]),
              onPressed: () async {
                print(widget.update);
                if (_formKey.currentState!.validate() && !widget.update) {
                  await DatabaseService().addCloth(_currentName, _currentCloth,
                      _currentColor, _currentType, _currentImage);
                } else if (_formKey.currentState!.validate() && widget.update) {
                  print(widget.update);
                  await DatabaseService().updateCloth(
                      widget.cloth1!.cid,
                      _currentName,
                      _currentCloth,
                      _currentColor,
                      _currentType,
                      _currentImage);
                }
                print(_currentName);
                print(_currentCloth);
                print(_currentColor);
                print(_currentType);
                print(_currentImage);
                widget.toggleView(false);
              },
              child: const Text(
                'Add/Update',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
