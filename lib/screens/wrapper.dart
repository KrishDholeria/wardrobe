import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wardrobe/models/myUser.dart';
import 'package:wardrobe/screens/authenticate/authenticate.dart';
import 'package:wardrobe/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);

    // return either home or authenticate widget
    if(user == null){
      return Authenticate();
    } else {
      return Home();
    }
  }
}