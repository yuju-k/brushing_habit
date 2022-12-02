import 'package:flutter/material.dart';

//퍼즐모음화면

class RewardMovie extends StatelessWidget {
  const RewardMovie({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("영상시청"),
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
