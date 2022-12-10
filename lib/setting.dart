import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text('SignOut을 하면 모든 정보가 사라집니다.'),
              ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  //어플리케이션 종료
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('SignOut'),
              ),
            ],
          ),
        ));
  }
}
