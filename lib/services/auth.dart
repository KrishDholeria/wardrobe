import 'package:firebase_auth/firebase_auth.dart';
import 'package:wardrobe/models/myUser.dart';
import 'package:wardrobe/services/database.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on firebase user
  MyUser? _userFromFirebaseUser(User? user){
    return user != null  ? MyUser(uid: user!.uid):null;
  }

  // auth change user stream
  Stream<MyUser?> get user{
    return _auth.authStateChanges()
    //.map((User? user) => _userFromFirebaseUser(user));
    .map(_userFromFirebaseUser);
  }

  // sign in anon
  Future signInAnon() async{
    try{
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      print(user!.displayName);
      return _userFromFirebaseUser(user);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String name, String email, String password) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      await user!.updateDisplayName(name);
      await user.reload();
      user = _auth.currentUser;

      // create a new document for the user with the uid
      await DatabaseService(uid: user!.uid).updateUserData(name, "cloth", "color", "type"); 
      return _userFromFirebaseUser(user);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async{
    try{
      return await _auth.signOut();
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
}