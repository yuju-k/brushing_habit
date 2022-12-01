import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('유아양치습관형성 DTx')),
      body: const CollectionMenu(),
    );
  }
}

class CollectionMenu extends StatelessWidget {
  const CollectionMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('너무 어려워요'), Text('뭐가 잘못된거냐...')],
      ),
    );
  }
}
