import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'screen/home_screen.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();

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
