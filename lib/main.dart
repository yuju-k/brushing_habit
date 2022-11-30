import 'package:flutter/material.dart';

void main() => runApp(const HomeScreen());

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brushing_habit_DTx',
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('유아양치습관형성 DTx'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Colors.black,
                child: const HomeMenu(),
              ),
              Container(
                color: Colors.black,
                child: const QuestionBrushing(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeMenu extends StatelessWidget {
  const HomeMenu({Key? key}) : super(key: key);
//메인페이지에 표기되는 메뉴화면 목록: 퍼즐보상모음, 영상보상모음, 달성표
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            color: Colors.black,
            child: const Text(
              '메뉴',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            color: Colors.black,
            child: const Text(
              '퍼즐보상모음',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            color: Colors.black,
            child: const Text(
              '영상보상모음',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            color: Colors.black,
            child: const Text(
              '달성표',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuestionBrushing extends StatelessWidget {
  const QuestionBrushing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('Question')],
      ),
    );
  }
}
