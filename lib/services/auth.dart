import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // creste user obj based on firbase user

  User _userFromFirebaseUser(FirebaseUser user){
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user strem

  Stream<User> get user { 
    return _auth.onAuthStateChanged
     // .map((FirebaseUser user) => _userFromFirebaseUser(user));
     .map(_userFromFirebaseUser);
  }
  
  // sign in anon
  Future signInAnon() async {
    try {
     AuthResult result = await _auth.signInAnonymously();
     FirebaseUser user = result.user;
     return _userFromFirebaseUser(user);

    } catch(e){
      print(e.toString());
      return null;

    }
  }


  // sign in with email & password
  Future signInWithEmailandPassword(String email, String password) async{
    try{
      AuthResult result = await  _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
     return _userFromFirebaseUser(user);

    }catch(e){
      print(e.toString());
      return null;
    }
  }



  // register with email & password
  Future registerWithEmailandPassword(String email, String password) async {
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

        //create a new document for a user with a uid
      await DatabaseService(uid: user.uid).updateUserData('low', 'new user 1', 100);
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }



  // sign out
  Future signOut() async {
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}