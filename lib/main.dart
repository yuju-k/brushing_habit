import 'package:flutter/material.dart';

import 'screen/home_screen.dart';

void main() {
  runApp(const RunHome());
}

class RunHome extends StatelessWidget {
  const RunHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brushing habit',
      home: const HomeScreen(),
    );
  }
}
