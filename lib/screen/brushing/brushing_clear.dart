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
    List<String> getItems_uid_movie = []; // (사용자 소유 영상) 불러온 배열 저장할 리스트
    late String randomDocId; // 랜덤하게 선택된 문서의 ID를 저장할 변수

    firebaseMovieGet() async {
      // collection: movies, document 리스트 불러옴
      // firebase에 저장된 movies컬렉션의 문서를 불러와서 랜덤하게 하나 선택해서 print()로 출력
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
        randomDocId = _docIds[Random().nextInt(_docIds.length)];
        print('randdomDocId : $randomDocId');
        // collection: getItems, document: uid, field: movie(배열)을 불러오기
        // 불러온 배열 출력
        FirebaseFirestore.instance
            .collection('getItems')
            .doc(uid)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            print(documentSnapshot.data());
            //불러온 배열 getItmes_uid_movie 리스트에 저장
            getItems_uid_movie = List.from(documentSnapshot['movie']);
            //getItems_uid_movie 리스트에 randomDocId가 없으면 추가
            if (!getItems_uid_movie.contains(randomDocId)) {
              FirebaseFirestore.instance.collection('getItems').doc(uid).set({
                'movie': FieldValue.arrayUnion([randomDocId])
              }, SetOptions(merge: true));
            } else {
              print('이미 존재하는 영상입니다.');
            }
          } else {
            print('Document does not exist on the database. UID문서 생성');
            //movie 필드 배열 생성
            FirebaseFirestore.instance.collection('getItems').doc(uid).set({
              'movie': FieldValue.arrayUnion([randomDocId])
            }, SetOptions(merge: true));
          }
        });
      } catch (e) {
        print(e);
      }
    }

    checkTodayBrushing() {
      //goals_calendar 컬렉션에 오늘 날짜 저장
      //document : uid
      //document에 uid가 없으면 새로 생성
      //clear_day 필드 배열에 오늘 날짜 저장
      FirebaseFirestore.instance.collection('goals_calendar').doc(uid).set({
        'clear_day': FieldValue.arrayUnion([DateTime.now()])
      }, SetOptions(merge: true));
      print('양치완료');
    }

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
            onPressed: () async {
              //완료 - 달성표에 날짜 저장
              checkTodayBrushing();
              //영상얻기
              await firebaseMovieGet();
              //화면이동
              Navigator.pop(context);
              Navigator.push(
                // randomDocId값을 RewardMovie로 전달
                context,
                MaterialPageRoute(
                    builder: (context) => RewardMovie(randomDocId)),
              );
            },
            child: const Text('보상받기'),
          ),
        ],
      )),
    );
  }
}
