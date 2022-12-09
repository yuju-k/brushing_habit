import '../collection/goals_screen.dart';
import 'package:flutter/material.dart';

class RewardPuzzle extends StatelessWidget {
  const RewardPuzzle({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("보상퍼즐"),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('퍼즐 획득!', style: TextStyle(fontSize: 20)),
          const SizedBox(
            height: 20,
          ),
          Image.asset(
            'assets/puzzles/tayo/puzzle/tayo1/image1.png',
            width: 130,
            height: 130,
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GoalsScreen()),
              );
            },
            child: const Text('완료'),
          ),
        ],
      )),
    );
  }
}
