import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//획득한 퍼즐조각을 이용해서 직소퍼즐을 맞추는 게임
class PuzzleGame extends StatefulWidget {
  const PuzzleGame(
      {Key? key, required this.puzzleListRoute, required this.puzzleList})
      : super(key: key);
  final String puzzleListRoute;
  final String puzzleList;

  @override
  State<PuzzleGame> createState() => _PuzzleGameState();
}

class _PuzzleGameState extends State<PuzzleGame> {
  late String puzzleListRoute = widget.puzzleListRoute;
  late String puzzleList = widget.puzzleList;

  @override
  void initState() {
    super.initState();
    //화면을 가로로 고정
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    //전체화면모드
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([]);
    //전체화면모드 해제
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puzzle Game'),
      ),
      body: Center(child: Image.asset(puzzleListRoute)),
    );
  }
}
