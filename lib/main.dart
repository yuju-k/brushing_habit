import 'package:flutter/material.dart';

void main() => runApp(const HomeScreen());

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brushing_habit_DTx',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('유아양치습관형성 DTx'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                //둥근모서리
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(15.0),
                child: const HomeMenu(),
              ),
              const SizedBox(height: 10),
              Container(
                color: Colors.white10,
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
      children: <Widget>[
        Container(
            width: 100,
            height: 100,
            child: ElevatedButton.icon(
                onPressed: onPressed, icon: icon, label: label)),
      ],
    ));
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
