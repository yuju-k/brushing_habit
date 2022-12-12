import '../collection/goals_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class RewardPuzzle extends StatefulWidget {
  const RewardPuzzle({super.key});

  @override
  State<RewardPuzzle> createState() => _RewardPuzzleState();
}

class _RewardPuzzleState extends State<RewardPuzzle> {
  var firestore = FirebaseFirestore.instance;
  //현재유저의 uid를 가져옴
  var user = FirebaseAuth.instance.currentUser;
  var uid = FirebaseAuth.instance.currentUser!.uid;
  late var puzzle_file_name; //퍼즐조각 파일이름
  late var puzzle_folder; //퍼즐조각 폴더이름
  late var puzzle_original; //퍼즐조각 원본파일 DB문서이름(collection:puzzle_original)
  late var puzzle_position; //퍼즐조각이 맞춰지는 위치 1~6

  Future getPuzzle() async {
    //collection: puzzle_slice에서 문서 한개를 랜덤으로 가져옴
    //퍼즐 보상을 받았을 때, 퍼즐을 랜덤으로 가져옴
    //그리고 getItems collection에 puzzleSlice에 추가함
    QuerySnapshot qn = await firestore.collection("puzzle_slice").get();
    //puzzle_slice에서 문서의 개수를 가져옴
    var puzzleCount = qn.docs.length;
    //1~puzzleCount사이의 랜덤숫자 생성
    var random = Random();
    var randomNum = random.nextInt(puzzleCount);
    //랜덤숫자에 해당하는 문서이름을 가져옴
    var puzzleName = qn.docs[randomNum].id;

    //collection: getItems에서 현재 유저의 uid와 일치하는 문서를 찾아서 puzzleSlice(배열)을 가져옴
    //uid가 없으면 생성
    //puzzleSlice에 puzzleName이 이미 있으면 print('이미 획득한 퍼즐입니다.')
    //없으면 puzzleSlice에 puzzleName 추가
    var doc2 = await firestore.collection('getItems').doc(uid).get();
    if (doc2.exists) {
      //uid가 있으면
      if ((doc2.data() as Map<String, dynamic>).containsKey('puuzzleSlice')) {
        var puzzleSlice = doc2['puzzleSlice'];
        if (puzzleSlice.contains(puzzleName)) {
          print('이미 획득한 퍼즐입니다.');
        } else {
          FirebaseFirestore.instance.collection('getItems').doc(uid).set({
            'puzzleSlice': FieldValue.arrayUnion([puzzleName])
          }, SetOptions(merge: true));
        }
      } else {
        FirebaseFirestore.instance.collection('getItems').doc(uid).set({
          'puzzleSlice': FieldValue.arrayUnion([puzzleName])
        }, SetOptions(merge: true));
      }
    } else {
      FirebaseFirestore.instance.collection('getItems').doc(uid).set({
        'puzzleSlice': FieldValue.arrayUnion([puzzleName])
      }, SetOptions(merge: true));
    }

    //puzzle_slice에서 puzzleName에 해당하는 문서의 필드정보 가져옴
    var doc = await firestore.collection('puzzle_slice').doc(puzzleName).get();
    puzzle_file_name = doc['file_name']; //파일이름
    puzzle_folder = doc['folder']; //저장되어있는 폴더
    puzzle_original =
        doc['original']; //원본파일 DB문서이름 (collection:puzzle_original)
    puzzle_position = doc['position']; //파일조각이 맞춰지는 위치 1~6

    //collection: getItems / uid / puzzleOriginal에 puzzle_original 추가
    //puzzle_original이 이미 있으면 추가하지 않음
    var doc3 = await firestore.collection('getItems').doc(uid).get();
    if (doc3.exists) {
      //uid가 있으면
      if ((doc3.data() as Map<String, dynamic>).containsKey('puzzleOriginal')) {
        var puzzleOriginal = doc3['puzzleOriginal'];
        if (puzzleOriginal.contains(puzzle_original)) {
          print('이미 등록되어있는 Origianl정보입니다..');
        } else {
          FirebaseFirestore.instance.collection('getItems').doc(uid).set({
            'puzzleOriginal': FieldValue.arrayUnion([puzzle_original])
          }, SetOptions(merge: true));
        }
      } else {
        FirebaseFirestore.instance.collection('getItems').doc(uid).set({
          'puzzleOriginal': FieldValue.arrayUnion([puzzle_original])
        }, SetOptions(merge: true));
      }
    } else {
      //uid없으면 생성
      FirebaseFirestore.instance.collection('getItems').doc(uid).set({
        'puzzleOriginal': FieldValue.arrayUnion([puzzle_original])
      }, SetOptions(merge: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("퍼즐보상"),
        ),
        body: Center(
            child: FutureBuilder(
          future: getPuzzle(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('퍼즐획득', style: TextStyle(fontSize: 20)),
                  const SizedBox(
                    height: 20,
                  ),
                  Image.asset(
                    'assets/puzzles/$puzzle_folder/$puzzle_file_name',
                    width: 130,
                    height: 130,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('퍼즐 조각을 보상으로 획득했습니다!'),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GoalsScreen()),
                      );
                    },
                    child: const Text('완료'),
                  ),
                ],
              );
            }
          },
        )));
  }
}
