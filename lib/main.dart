import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wardrobe/models/myUser.dart';
import 'package:wardrobe/screens/wrapper.dart';
import 'package:wardrobe/services/auth.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser?>.value(
      value: AuthService().user,
      initialData: null,
        child: MaterialApp(
        home: Wrapper(),
        debugShowCheckedModeBanner: false,
      ),

    );
  }
}
