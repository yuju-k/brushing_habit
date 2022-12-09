import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PuzzleGame extends StatefulWidget {
  const PuzzleGame({Key? key}) : super(key: key);
  @override
  State<PuzzleGame> createState() => _PuzzleGameState();
}

class _PuzzleGameState extends State<PuzzleGame> {
  @override
  void initState() {
    super.initState();
    //이 디스플레이에서는 가로모드만 사용
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    //가로고정 해제
    SystemChrome.setPreferredOrientations([]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("퍼즐게임",
              style: TextStyle(
                color: Colors.black,
              )),
          //앱바 사이즈
          toolbarHeight: 35,
          //앱바배경 바디배경 색과 같게 설정, 그림자 없애기
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Center(
            child: Row(children: [
          //화면 7:3로 나눔
          Expanded(
            flex: 7,
            child: Container(
              child: _buildPuzzle(),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              //왼쪽 테두리
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(width: 1.0, color: Colors.grey),
                ),
              ),
            ),
          ),
        ])));
  }

  Widget _buildPuzzle() {
    //퍼즐판 생성
    return Container(
      child: Text('1'),
    );
  }
}
