import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screen/home_screen.dart';
import 'services/auth.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras(); //카메라 초기화

  await Firebase.initializeApp(
    //firebase초기화
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await AuthService().signInAnon(); //익명로그인 활성화

  runApp(const RunHome());
}

class RunHome extends StatelessWidget {
  const RunHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brushing habit DTX',
      home: const HomeScreen(),
      theme: ThemeData.light(),
    );
  }
}
