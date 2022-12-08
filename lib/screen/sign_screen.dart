import 'package:flutter/material.dart';

import 'firebase_auth/firebase_auth.dart';

//로그인!

class SignScreen extends StatelessWidget {
  const SignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("로그인"),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('로그인테스트'),
          onPressed: () async {
            final AuthService auth = AuthService();
            dynamic result = await auth.signInAnon();
            if (result == null) {
              // ignore: avoid_print
              print('@@ error signing in');
            } else {
              // ignore: avoid_print
              print('@@ signed in');
              // ignore: avoid_print
              print(result); // return Instance of UserModel
              // ignore: avoid_print
              print(result.uid); // return uid value in UserModel class
            }
          },
        ),
      ),
    );
  }
}
