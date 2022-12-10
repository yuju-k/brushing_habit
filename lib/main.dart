import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screen/home_screen.dart';
import 'screen/sign_screen.dart';
import 'screen/collection/goals_screen.dart';
import 'screen/collection/movies_collection_screen.dart';
import 'screen/collection/puzzle_collection_screen.dart';
import 'screen/brushing/reward_movie_screen.dart';
import 'screen/brushing/run_brushing_screen.dart';
import 'screen/collection/puzzle_detail.dart';
import 'screen/collection/puzzle_game.dart';
import 'screen/brushing/brushing_clear.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras(); //카메라 초기화
  await Firebase.initializeApp(
    //firebase초기화
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const RunHome());
}

class RunHome extends StatelessWidget {
  const RunHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brushing habit DTX',
      routes: {
        '/puzzle': (context) => const PuzzleCollectionScreen(),
        '/movie': (context) => const MoviesCollectionScreen(),
        '/goals': (context) => const GoalsScreen(),
        '/reward': (context) => const RewardMovie(),
        '/run': (context) => const ImageLabelView(),
        '/puzzle_detail': (context) => const PuzzleDetails(),
        '/puzzle_game': (context) => const PuzzleGame(),
        '/claer': (context) => const ClearBrushing(),
      },
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // If the user is logged in, navigate to the HomeScreen
          if (snapshot.hasData) {
            return const HomeScreen();
          }
          // Otherwise, navigate to the SignScreen
          else {
            return const SignScreen();
          }
        },
      ),
      theme: ThemeData.light(),
    );
  }
}
