import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//퍼즐모음화면

class PuzzleCollectionScreen extends StatefulWidget {
  const PuzzleCollectionScreen({super.key});

  @override
  State<PuzzleCollectionScreen> createState() => _PuzzleCollectionScreenState();
}

class _PuzzleCollectionScreenState extends State<PuzzleCollectionScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([]);
  }

  @override
  Widget build(BuildContext context) {
    List<String> images = [
      'assets/puzzles/1/original.jpg',
      'assets/puzzles/2/original.jpg',
      'assets/puzzles/3/original.jpg',
      'assets/puzzles/4/original.jpg',
    ];

    return Scaffold(
        appBar: AppBar(
          title: const Text("퍼즐모음"),
        ),
        body: Center(
            child: GridView.count(
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          crossAxisCount: 1,
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
