import 'package:flutter/material.dart';
import 'dart:core';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({Key? key}) : super(key: key);

  @override
  _GoalsScreenState createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  DateTime now = DateTime.now();
  late DateTime _selectedDate;
  DateTime _todayDate = DateTime.now();
  EventList<Event> listEvents = EventList<Event>(events: {});

  @override
  void initState() {
    _selectedDate = DateTime.now();
    //달력에 마크를 표시하는 메소드를 작성할때, 시간이 0시 0분 0초 0밀리초로 되어있어야함.
    _todayDate = DateTime(now.year, now.month, now.day, 0, 0, 0, 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Goals'),
        ),
        body: SingleChildScrollView(
            child: Center(
          child: Column(
            children: [
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
              const SizedBox(height: 20),
              const Icon(Icons.star_rounded),
              ElevatedButton(
                onPressed: () {
                  // ignore: avoid_print
                  print('Button pressed');
                  //listEvents에 오늘 날짜를 추가함.
                  setState(() {
                    listEvents.add(
                      _todayDate,
                      Event(
                        date: _todayDate,
                        title: 'Complete Brusing',
                      ),
                    );
                  });
                },
                child: const Text('Button'),
              ),
            ],
          ),
        )));
  }
}
