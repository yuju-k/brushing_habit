import 'package:flutter/material.dart';

import 'goals_screen.dart';
import 'movies_collection_scrren.dart';
import 'puzzle_collection_scrren.dart';
import 'reward_movie_screen.dart';
import 'run_brushing_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('유아양치습관형성 DTx')),
      body: const CollectionMenu(),
    );
  }
}

class CollectionMenu extends StatelessWidget {
  const CollectionMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          //** 기본 메뉴: 퍼즐모음, 영상모음, 달성표 **/
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //퍼즐모음 아이콘-타이틀
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const PuzzleCollectionScreen()),
                      );
                    },
                    iconSize: 75,
                    icon: Image.asset(
                      'assets/icon/icon_puzzle.png',
                    ),
                  ),
                  const Text('퍼즐모음'),
                ],
              ),

              // ignore: prefer_const_constructors
              SizedBox(
                width: 20,
              ),

              //영상모음 아이콘-타이틀
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const MoviesCollectionScreen()),
                      );
                    },
                    iconSize: 75,
                    icon: Image.asset(
                      'assets/icon/icon_movies.png',
                    ),
                  ),
                  const Text('영상모음'),
                ],
              ),

              // ignore: prefer_const_constructors
              SizedBox(
                width: 20,
              ),

              //달성표 아이콘-타이틀
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GoalsScreen()),
                      );
                    },
                    iconSize: 75,
                    icon: Image.asset(
                      'assets/icon/icon_goal.png',
                    ),
                  ),
                  const Text('달성표'),
                ],
              ),
            ],
          ),

          // ignore: prefer_const_constructors
          SizedBox(height: 35),

          Container(
              //둥근모서리, 테두리 색 파란색
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue)),
              alignment: Alignment.center,
              width: 280,
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Container 내부 내용
                  const Text('양치를 했나요?'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          //버튼스타일 흰 배경에 파란색 테두리
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.blue,
                              backgroundColor: Colors.white,
                              side: const BorderSide(
                                  color: Color.fromARGB(255, 142, 192, 233))),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RewardMovie()),
                            );
                          },
                          child: const Text(
                            '\u{1F603}네!',
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold),
                          )),
                      // ignore: prefer_const_constructors
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.blue,
                              backgroundColor: Colors.white,
                              side: const BorderSide(
                                  color: Color.fromARGB(255, 142, 192, 233))),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RunBrushing()),
                            );
                          },
                          child: const Text(
                            '\u{1F613}아니요',
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold),
                          )),
                    ],
                  )
                ],
              ))
        ]));
  }
}
