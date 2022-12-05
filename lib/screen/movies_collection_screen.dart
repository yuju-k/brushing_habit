import 'package:flutter/material.dart';

//영상모음화면

class MoviesCollectionScreen extends StatelessWidget {
  const MoviesCollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("영상모음"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // 눌렀을 때 첫 번째 route로 되돌아 갑니다.
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
