import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'reward_puzzle_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RewardMovie extends StatefulWidget {
  const RewardMovie(this.randomDocId, {super.key});

  final String randomDocId;

  @override
  State<RewardMovie> createState() => _RewardMovieState();
}

class _RewardMovieState extends State<RewardMovie> {
  late String randomDocId = widget.randomDocId;
  late String youtubeUrl;
  late String episodeNum;
  late String episodeTitle;
  late String seasonNum;
  late String animationTitle;

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
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(title: const Text('보상영상시청')),
      body: Center(
        child: FutureBuilder(
            future: getRewardMovie(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SingleChildScrollView(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('[$episodeTitle] 시즌 $seasonNum-$episodeNum화',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text(
                      animationTitle,
                      style: const TextStyle(fontSize: 25),
                    ),
                    const SizedBox(height: 5),
                    YoutubePlayer(
                      controller: YoutubePlayerController(
                        initialVideoId: youtubeUrl, // 유튜브 영상 ID
                        flags: const YoutubePlayerFlags(
                          autoPlay: false, // 자동 재생
                          mute: false, // 소리 켜기
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RewardPuzzle()));
                        },
                        child: const Text('SKIP'))
                  ],
                ));
              } else {
                return const CircularProgressIndicator();
              }
            })),
      ),
    ));
  }

  Future getRewardMovie() async {
    var firestore = FirebaseFirestore.instance;
    var doc = await firestore.collection('movies').doc(randomDocId).get();
    episodeTitle = doc['name']; //영상제목 (슈퍼구조대, 뽀로로와 친구들...)
    youtubeUrl = doc['youtube_id']; //유튜브 동영상 아이디
    seasonNum = doc['season']; //시즌(1,2,3...)
    episodeNum = doc['episode']; //에피소드(1,2,3...)
    animationTitle = doc['title']; //에피소드 타이틀
  }
}
