import '../../main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:intl/intl.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({Key? key}) : super(key: key);

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  DateTime now = DateTime.now();
  late DateTime _selectedDate;
  DateTime clearDayDate = DateTime.now();
  EventList<Event> listEvents = EventList<Event>(events: {});

  @override
  void initState() {
    super.initState();
    final FirebaseAuth auth = FirebaseAuth.instance;
    _selectedDate = DateTime.now();
    //달력에 마크를 표시하는 메소드를 작성할때, 시간이 0시 0분 0초 0밀리초로 되어있어야함.
    clearDayDate = DateTime(now.year, now.month, now.day, 0, 0, 0, 0);

    final User? user = auth.currentUser;
    final uid = user!.uid;
    //goals_calendar 컬렉션에 uid가 있는지 확인
    //있으면 goals_calendar 컬렉션, uid문서에 clear_day 필드 배열을 _todayDate로 불러오기
    //없으면 print('값이 존재하지 않습니다');
    FirebaseFirestore.instance
        .collection('goals_calendar')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        FirebaseFirestore.instance
            .collection('goals_calendar')
            .doc(uid)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            List<dynamic> clearDay = documentSnapshot['clear_day'];
            for (int i = 0; i < clearDay.length; i++) {
              clearDayDate = clearDay[i].toDate();
              DateTime clearDayDate2 = DateTime(clearDayDate.year,
                  clearDayDate.month, clearDayDate.day, 0, 0, 0, 0);
              listEvents.add(
                  clearDayDate2,
                  Event(
                    date: clearDayDate2,
                    title: '양치질 완료',
                  ));
              setState(() {}); //완료됐을때, 화면을 다시 그려주기 위해 setState()를 사용함.
            }
          } else {
            // ignore: avoid_print
            print('값이 존재하지 않습니다');
          }
        });
      } else {
        // ignore: avoid_print
        print('값이 존재하지 않습니다');
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    //DateTime todayDate = DateTime(now.year, now.month, now.day, 0, 0, 0, 0);

    return Scaffold(
        appBar: AppBar(
          title: const Text('달성표'),
        ),
        body: SingleChildScrollView(
            child: Center(
                child: Column(children: [
          //달력
          CalendarCarousel<Event>(
            width: 370,
            height: 420,
            selectedDateTime: _selectedDate, //선택된 날짜
            onDayPressed: (DateTime date, List<Event> events) {
              setState(() {
                _selectedDate = date;
              });
            },
            weekendTextStyle: const TextStyle(
              color: Colors.red,
            ),
            selectedDayTextStyle: const TextStyle(
              color: Colors.black,
            ),
            selectedDayButtonColor: Colors.lightBlue,
            todayButtonColor: Colors.lightGreen,
            todayTextStyle: const TextStyle(
              color: Colors.black54,
            ),
            thisMonthDayBorderColor: Colors.grey,
            weekFormat: false,
            markedDatesMap: listEvents, //listEvents에 표시된 날짜를 달력에 표시함.
            markedDateShowIcon: true,
            markedDateIconMaxShown: 1,
            markedDateIconBuilder: (event) {
              return const Icon(
                Icons.star_rounded,
                size: 35,
                color: Color.fromARGB(255, 255, 200, 0),
              );
            },
            markedDateMoreShowTotal: true,
            showIconBehindDayText: true,
            markedDateMoreCustomDecoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              color: Colors.black,
            ),
          ),
          //goals_calendar 컬렉션에 uid가 있는지 확인
          //있으면 goals_calendar 컬렉션, uid문서에 clear_day필드 배열에서 _selectedDate를 찾아서 개수 세기
          //없으면 print('값이 존재하지 않습니다');
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('goals_calendar')
                  .doc(uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                int count = 0;
                if (snapshot.hasData) {
                  try {
                    List<dynamic> clearDay = snapshot.data!['clear_day'];
                    for (int i = 0; i < clearDay.length; i++) {
                      clearDayDate = clearDay[i].toDate();
                      DateTime clearDayDate2 = DateTime(clearDayDate.year,
                          clearDayDate.month, clearDayDate.day, 0, 0, 0, 0);
                      if (clearDayDate2 == _selectedDate) {
                        count++;
                      }
                    }
                  } catch (e) {
                    // ignore: avoid_print
                    print('값이 존재하지 않습니다. $e');
                  }
                } else {
                  // ignore: avoid_print
                  print('값이 존재하지 않습니다');
                }

                // clearDayDate를 년월일 형태로 변경
                String clearDayDate3 = DateFormat('yyyy년 MM월 dd일')
                    .format(_selectedDate)
                    .toString();

                return Column(children: [
                  // clearDay.length 만큼 별 출력
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < count; i++) ...{
                        const Icon(
                          Icons.star_rounded,
                          size: 35,
                          color: Color.fromARGB(255, 255, 200, 0),
                        ),
                      }
                    ],
                  ),
                  Text(
                    '$clearDayDate3 \n 양치질 횟수 : $count회',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]);
              }),
          const SizedBox(height: 10),
          ElevatedButton(
              onPressed: () {
                // 초기화면으로 이동
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const RunHome()),
                    (route) => false);
              },
              child: const Text('홈화면으로')),
        ]))));
  }
}
