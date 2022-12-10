import 'package:flutter/material.dart';

//퍼즐모음화면

class PuzzleCollectionScreen extends StatelessWidget {
  const PuzzleCollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> images = [
      'assets/puzzles/titles/pororo.png',
      'assets/puzzles/titles/tayo.png',
      'assets/puzzles/titles/baby_shark.png',
      'assets/puzzles/titles/cocomong.png',
    ];

    return Scaffold(
        appBar: AppBar(
          title: const Text("퍼즐모음"),
        ),
        body: Center(
            child: GridView.count(
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          crossAxisCount: 2,
          children: List.generate(4, (index) {
            // For each index in the list of images,
            // return an Image widget that displays the image at that index
            return Container(
                color: Colors.white,
                child: ElevatedButton(
                    //투명배경
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: () {
                      //PuzzleDetails로 이동
                      Navigator.pushNamed(
                        context, '/puzzle_game',
                        //arguments: images[index]);
                      );
                    },
                    child: Image.asset(images[index])));
          }),
        )));
  }
}
