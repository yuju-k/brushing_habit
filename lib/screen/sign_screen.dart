import 'package:flutter/material.dart';

import 'firebase_auth/firebase_auth.dart';

//로그인!

class SignScreen extends StatelessWidget {
  const SignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("유아양치습관형성 DTx"), centerTitle: true),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text('환영합니다!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 10),
            const Text('유아양치습관형성 DTx를\n사용하기 위해서는\n로그인이 필요합니다.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 10),
            Image.asset('assets/images/loginScreen_image.png', width: 180),
            const SizedBox(height: 20),
            const Text('현재는 익명사용자로 로그인만 가능합니다.'),
            const SizedBox(height: 10),
            ElevatedButton(
              child: const Text('익명사용자로 로그인'),
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
          ]),
        ));
  }
}
