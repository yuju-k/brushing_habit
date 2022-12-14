import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'puzzle_game.dart';

//퍼즐모음화면

class PuzzleCollectionScreen extends StatefulWidget {
  const PuzzleCollectionScreen({super.key});

  @override
  State<PuzzleCollectionScreen> createState() => _PuzzleCollectionScreenState();
}

class _PuzzleCollectionScreenState extends State<PuzzleCollectionScreen> {
  List<String> puzzle_list = [];
  List<String> puzzle_list_filename = [];
  List<String> puzzle_list_folder = [];
  List<String> puzzle_list_route = [];

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([]);
  }

  Future puzzleOriginalList() async {
    //파이어베이스 초기화
    var firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user!.uid;

    //getItem, uid, puzzleOriginal 가져오기
    //uid가 존재하지 않으면 print("uid가 존재하지 않습니다.")
    //uid가 존재하면 puzzleOriginal 가져오기
    await firestore
        .collection('getItems')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        if ((documentSnapshot.data() as Map<String, dynamic>)
            .containsKey('puzzleOriginal')) {
          puzzle_list = List.from(documentSnapshot['puzzleOriginal']);
          puzzle_list.sort(); //내림차순정렬

          //puzzle_original collection에서 puzzle_list와 같은 문서의 file_name 가져오기
          //puzzle_list_filename에 저장
          for (int i = 0; i < puzzle_list.length; i++) {
            await firestore
                .collection('puzzle_original')
                .doc(puzzle_list[i])
                .get()
                .then((DocumentSnapshot documentSnapshot) {
              if (documentSnapshot.exists) {
                puzzle_list_filename.add(documentSnapshot['file_name']);
                puzzle_list_folder.add(documentSnapshot['folder']);
                String route = 'assets/puzzles/' +
                    documentSnapshot['folder'] +
                    '/' +
                    documentSnapshot['file_name'];
                puzzle_list_route.add(route);
              } else {
                print('존재하지 않는 문서입니다.');
              }
            });
          }
        } else {
          print('획득한 퍼즐이 없습니다.');
        }
      } else {
        print('uid가 존재하지 않습니다.(획득한 퍼즐없음)');
      }
      print('puzzle_list_route: $puzzle_list_route');
      print('puzzle_list_filename: $puzzle_list_filename');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("퍼즐모음"),
        ),
        body: Center(
            child: FutureBuilder(
                future: puzzleOriginalList(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1),
                        itemCount: puzzle_list_filename.length,
                        itemBuilder: (context, index) {
                          return Container(
                              child: Column(
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    //puzzleGame()화면으로이동
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PuzzleGame(
                                                  puzzleListRoute:
                                                      puzzle_list_route[index],
                                                  originalPuzzleList:
                                                      puzzle_list[index],
                                                )));
                                  },
                                  //버튼배경투명
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent),
                                  child: Image.asset(puzzle_list_route[index]))
                            ],
                          ));
                        });
                  } else {
                    return const CircularProgressIndicator();
                  }
                })));
  }
}
