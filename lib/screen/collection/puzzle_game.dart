import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PuzzleGame extends StatefulWidget {
  const PuzzleGame(
      {super.key, required String puzzleListRoute, required String puzzleList});

  @override
  State<PuzzleGame> createState() => _PuzzleGameState();
}

class _PuzzleGameState extends State<PuzzleGame> {
  List<bool> _isPuzzleSolved = [false, false, false, false, false, false];

  @override
  void initState() {
    //가로모드
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    //전체화면
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: Align(
              alignment: Alignment.center,
              child: _buildPuzzleGame(),
            )),
            Column(
              children: [
                Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.2,
                    color: Colors.blueGrey[100],
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: const [
                        Text('획득한 퍼즐 조각', style: TextStyle(fontSize: 17)),
                        SizedBox(height: 5),
                        Text('퍼즐조각을 옮겨서 그림을 완성하세요!',
                            style: TextStyle(fontSize: 13)),
                      ],
                    )),
                Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.8,
                    color: Colors.blueGrey,
                    child: SingleChildScrollView(
                      child: _buildPuzzleSlice(),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPuzzleGame() {
    return Container(
      width: 450,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              _buildPuzzleImage(1),
              _buildPuzzleImage(2),
              _buildPuzzleImage(3),
            ],
          ),
          Row(
            children: <Widget>[
              _buildPuzzleImage(4),
              _buildPuzzleImage(5),
              _buildPuzzleImage(6),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPuzzleImage(int index) {
    return DragTarget(builder: (
      BuildContext context,
      List<dynamic> accepted,
      List<dynamic> rejected,
    ) {
      return Container(
        width: 150,
        height: 150,
        child: Image.asset(
          _isPuzzleSolved[index - 1]
              ? 'assets/puzzles/1/slice$index.png'
              : 'assets/puzzles/blank_puzzle.png',
          fit: BoxFit.fill,
        ),
      );
    }, onWillAccept: (data) {
      return data == 'slice$index.png';
    }, onAccept: (data) {
      print(data);
      setState(() {
        _isPuzzleSolved[index - 1] = true;
      });
    });
  }

  Widget _buildPuzzleSlice() {
    //퍼즐슬라이스조각들 출력...!!
    List<Widget> list = <Widget>[];
    for (var i = 0; i < 6; i++) {
      list.add(_buildPuzzleSliceImage(1, i, 'slice${i + 1}.png'));
      list.add(const SizedBox(height: 20));
    }
    return Column(children: [
      Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: list,
        ),
      )
    ]);
  }

  Widget _buildPuzzleSliceImage(folder, index, String fileName) {
    return Visibility(
      visible: !_isPuzzleSolved[index],
      child: Container(
        width: 150,
        height: 150,
        child: Draggable(
          data: fileName,
          child: Image.asset(
            'assets/puzzles/$folder/$fileName',
            fit: BoxFit.fill,
          ),
          feedback: Image.asset(
            'assets/puzzles/$folder/$fileName',
            fit: BoxFit.fill,
          ),
          childWhenDragging: Container(),
        ),
      ),
    );
  }
}
