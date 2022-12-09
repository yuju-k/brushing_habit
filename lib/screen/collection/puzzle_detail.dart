import 'package:flutter/material.dart';

class PuzzleDetails extends StatelessWidget {
  const PuzzleDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("퍼즐상세"),
        ),
        body: Center(
            child: SingleChildScrollView(
                child: Column(
          children: [
            //Image.asset(ModalRoute.of(context)!.settings.arguments as String),
            Container(
                width: double.infinity,
                //아래 테두리 border=1, 색깔=회색
                decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey))),
                padding: const EdgeInsets.all(10),
                child: const Text(
                  '뽀로로퍼즐',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
            const SizedBox(height: 10),
            thumbnailPuzzle(context),
            thumbnailPuzzle(context),
            thumbnailPuzzle(context),
            thumbnailPuzzle(context),
            thumbnailPuzzle(context),
            thumbnailPuzzle(context),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("돌아가기"))
          ],
        ))));
  }

  Widget thumbnailPuzzle(BuildContext context) {
    return Column(children: [
      ElevatedButton(
        //투명배경
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: () {
          //PuzzleGame으로 이동
          Navigator.pushNamed(context, '/puzzle_game');
        },
        child: Container(
          width: 16 * 17.0,
          height: 9 * 17.0,
          color: Colors.grey,
          child: const Text('퍼즐썸네일'),
        ),
      ),
      const SizedBox(height: 10),
    ]);
  }
}
