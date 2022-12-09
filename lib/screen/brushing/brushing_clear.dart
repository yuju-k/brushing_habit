import 'package:flutter/material.dart';
import 'reward_movie_screen.dart';

class ClearBrushing extends StatefulWidget {
  const ClearBrushing({super.key});

  @override
  State<ClearBrushing> createState() => _ClearBrushingState();
}

class _ClearBrushingState extends State<ClearBrushing> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("양치질 완료"),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/brushing_clear.png',
            width: 100,
            height: 100,
          ),
          const SizedBox(height: 20),
          const Text(
            "양치질을 완료했습니다!",
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RewardMovie()),
              );
            },
            child: const Text('보상받기'),
          ),
        ],
      )),
    );
  }
}
