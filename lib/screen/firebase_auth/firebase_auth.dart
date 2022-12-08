// ignore_for_file: unnecessary_null_comparison

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /* Sign In anon */
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return null;
    }
  }

  // create user obj based on FirebaseUser
  UserModel? _userFromFirebaseUser(User user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }
}

class UserModel {
  final String uid;

  UserModel({required this.uid});
}
