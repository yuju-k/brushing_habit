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
  @override
  void initState() {
    super.initState();
    //세로모드
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([]);
  }

  @override
  Widget build(BuildContext context) {
    List<String> puzzleList = [];
    List<String> puzzleListFilename = [];
    List<String> puzzleListFolder = [];
    List<String> puzzleListRoute = [];

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
            puzzleList = List.from(documentSnapshot['puzzleOriginal']);
            puzzleList.sort(); //내림차순정렬

            //puzzle_original collection에서 puzzle_list와 같은 문서의 file_name 가져오기
            //puzzle_list_filename에 저장
            for (int i = 0; i < puzzleList.length; i++) {
              await firestore
                  .collection('puzzle_original')
                  .doc(puzzleList[i])
                  .get()
                  .then((DocumentSnapshot documentSnapshot) {
                if (documentSnapshot.exists) {
                  puzzleListFilename.add(documentSnapshot['file_name']);
                  puzzleListFolder.add(documentSnapshot['folder']);

                  String folderRoute = documentSnapshot['folder'];
                  String fileNameRoute = documentSnapshot['file_name'];
                  String route = 'assets/puzzles/$folderRoute/$fileNameRoute';

                  puzzleListRoute.add(route);
                } else {
                  //print('존재하지 않는 문서입니다.');
                }
              });
            }
          } else {
            //print('획득한 퍼즐이 없습니다.');
          }
        } else {
          //print('uid가 존재하지 않습니다.(획득한 퍼즐없음)');
        }
        //print('puzzleListRoute: $puzzleListRoute');
        //print('puzzleListFilename: $puzzleListFilename');
      });
    }

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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 260, crossAxisCount: 1),
                  itemCount: puzzleListFilename.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PuzzleGame(
                                            puzzleListRoute:
                                                puzzleListRoute[index],
                                            originalPuzzleList:
                                                puzzleList[index],
                                          )));
                            },
                            //버튼배경투명
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent),
                            child: Image.asset(puzzleListRoute[index]))
                      ],
                    );
                  });
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
