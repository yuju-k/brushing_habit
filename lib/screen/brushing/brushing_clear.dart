import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'reward_movie_screen.dart';

class ClearBrushing extends StatefulWidget {
  const ClearBrushing({super.key});

  @override
  State<ClearBrushing> createState() => _ClearBrushingState();
}

class _ClearBrushingState extends State<ClearBrushing> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user!.uid; //Firebase에 저장된 유저아이디 불러오기
    List<String> _docIds = []; // 컬렉션에 있는 모든 문서의 ID를 저장할 리스트

    return Scaffold(
      appBar: AppBar(
        title: const Text("양치질 완료"),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/brushing_clear.png',
            width: 100,
            height: 100,
          ),
          const SizedBox(height: 20),
          const Text(
            "양치질을 완료했습니다!",
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              //goals_calendar 컬렉션에 오늘 날짜 저장
              //document : uid
              //document에 uid가 없으면 새로 생성
              //clear_day 필드 배열에 오늘 날짜 저장
              FirebaseFirestore.instance
                  .collection('goals_calendar')
                  .doc(uid)
                  .set({
                'clear_day': FieldValue.arrayUnion([DateTime.now()])
              }, SetOptions(merge: true));
              //화면이동
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RewardMovie()),
              );
            },
            child: const Text('보상받기'),
          ),
          ElevatedButton(
            onPressed: () async {
              //firebase에 저장된 movies컬렉션의 문서를 불러와서 랜덤하게 하나 선택해서 print()로 출력
              // 컬렉션에 있는 모든 문서의 ID를 저장할 리스트
              // "movies" 컬렉션에서 모든 문서를 읽고, 문서리스트를 _docIds에 저장
              await FirebaseFirestore.instance
                  .collection('movies')
                  .get()
                  .then((QuerySnapshot querySnapshot) {
                for (var doc in querySnapshot.docs) {
                  _docIds.add(doc.id);
                }
              });
              // _docIds 리스트에서 랜덤하게 하나 선택
              try {
                var randomDocId = _docIds[Random().nextInt(_docIds.length)];
                // 선택된 문서의 ID를 출력
                print(randomDocId);
              } catch (e) {
                print(e);
              }
            },
            child: const Text('Test'),
          )
        ],
      )),
    );
  }
}
