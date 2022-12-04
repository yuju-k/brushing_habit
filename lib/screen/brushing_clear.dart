import 'package:flutter/material.dart';

import 'reward_movie_screen.dart';
import 'dart:async';
//양치질완료!

class ClearBrushing extends StatefulWidget {
  const ClearBrushing({super.key});

  @override
  State<ClearBrushing> createState() => _ClearBrushingState();
}

class _ClearBrushingState extends State<ClearBrushing> {
  int _remainingSeconds = 5;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    // Start the countdown
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingSeconds--;
      });

      if (_remainingSeconds == 0) {
        timer.cancel();

        // Move the screen after 5 seconds
        Future.delayed(const Duration(seconds: 5)).then((_) {
          Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RewardMovie()),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
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
          Text('Remaining seconds: $_remainingSeconds'),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RewardMovie()),
              );
            },
            child: const Text('Skip'),
          ),
        ],
      )),
    );
  }
}
