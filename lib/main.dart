import 'package:flutter/material.dart';

void main() => runApp(const HomeScreen());

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brushing_habit_DTx',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('유아양치습관형성 DTx'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Colors.white,
                child: const HomeMenu(),
              ),
              Container(
                color: Colors.white,
                child: const QuestionBrushing(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeMenu extends StatelessWidget {
  const HomeMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('Menu Box')],
      ),
    );
  }
}

class QuestionBrushing extends StatelessWidget {
  const QuestionBrushing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('Question')],
      ),
    );
  }
}
