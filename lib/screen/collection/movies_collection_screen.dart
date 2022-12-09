import 'package:flutter/material.dart';

const List<Widget> animationName = <Widget>[
  Text('슈퍼구조대'),
  Text('Pea Pea World'),
  Text('코코몽'),
  Text('뽀로로와 친구들'),
  Text('꼬마버스 타요'),
];

final List<bool> selectedanimationName = <bool>[
  true,
  false,
  false,
  false,
  false
];

class MoviesCollectionScreen extends StatefulWidget {
  const MoviesCollectionScreen({super.key});

  @override
  State<MoviesCollectionScreen> createState() => _MoviesCollectionScreenState();
}

class _MoviesCollectionScreenState extends State<MoviesCollectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("영상모음"),
        ),
        body: movieList());
  }

  Widget movieList() {
    //큰 틀
    return SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        animationSelect(),
        const SizedBox(height: 10),
        finishedEpisode(),
      ],
    ));
  }

//-- 세 부 위 젯 --//
  Widget animationSelect() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 5),
      //아래 테두리 border=1, 색깔=회색
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.grey),
        ),
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '애니메이션',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 3),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ToggleButtons(
              direction: Axis.horizontal,
              onPressed: (int index) {
                // Call the updateSelectedanimationName() method to update the list.
                setState(() {
                  // The button that is tapped is set to true, and the others to false.
                  for (int i = 0; i < selectedanimationName.length; i++) {
                    selectedanimationName[i] = i == index;
                  }
                });
              },
              selectedBorderColor: Colors.blue[700],
              selectedColor: Colors.white,
              fillColor: Colors.blue[200],
              color: Colors.blue[400],
              constraints: const BoxConstraints(
                minHeight: 40.0,
                minWidth: 100.0,
              ),
              isSelected: selectedanimationName,
              children: animationName,
            ),
          )
        ],
      ),
    );
  }

  Widget finishedEpisode() {
    return Container(
        width: double.infinity,
        //아래 테두리 border=1, 색깔=회색
        padding: const EdgeInsets.all(10),
        //아래 테두리 border=1, 색깔=회색
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1.0, color: Colors.grey),
          ),
        ),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '시청 완료 목록',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                thumbnailYoutube(),
                thumbnailYoutube(),
                thumbnailYoutube(),
                thumbnailYoutube(),
              ],
            ),
          ],
        ));
  }

  Widget thumbnailYoutube() {
    return Column(children: [
      Container(
        width: 16 * 17.0,
        height: 9 * 17.0,
        color: Colors.grey,
        child: const Text('영상썸네일'),
      ),
      const Text('[시즌1] 1화 - 영상제목'),
      const SizedBox(height: 10),
    ]);
  }
}
