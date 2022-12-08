import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'reward_puzzle_screen.dart';

class RewardMovie extends StatefulWidget {
  const RewardMovie({super.key});

  @override
  State<RewardMovie> createState() => _RewardMovieState();
}

class _RewardMovieState extends State<RewardMovie> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: const Text('보상영상시청')),
          body: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              youtubePlaying(),
              const SizedBox(
                height: 20,
              ),
              const Text('시즌1 : 1화 뽀로로를 소개합니다.'),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RewardPuzzle()),
                  );
                },
                child: const Text('Skip'),
              ),
            ],
          ))),
    );
  }
}

Widget youtubePlaying() {
  return YoutubePlayer(
    controller: YoutubePlayerController(
      initialVideoId: 'gAVsLi3Nrd0', // 유튜브 영상 ID
      flags: const YoutubePlayerFlags(
        autoPlay: true, // 자동 재생
        mute: false, // 소리 켜기
      ),
    ),
  );
}
