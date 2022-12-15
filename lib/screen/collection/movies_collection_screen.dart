import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MoviesCollectionScreen extends StatefulWidget {
  const MoviesCollectionScreen({super.key});

  @override
  State<MoviesCollectionScreen> createState() => _MoviesCollectionScreenState();
}

class _MoviesCollectionScreenState extends State<MoviesCollectionScreen> {
  List<String> animationName = [
    '슈퍼구조대',
    'Pea Pea World',
    '코코몽',
    '뽀로로와 친구들',
    '꼬마버스 타요',
  ];

  final List<bool> selectedanimationName = <bool>[
    true,
    false,
    false,
    false,
    false
  ];

  List<String> _docIds = []; //getItems에서 가져온 movie값들을 저장할 리스트
  List<String> _youtubeIds = []; //movies에서 가져온 youtube_id값들을 저장할 리스트
  final List<String> _title = []; //movies에서 가져온 title값들을 저장할 리스트
  final List<String> _seasonNum = []; //movies에서 가져온 season값들을 저장할 리스트
  final List<String> _episodeNum = []; //movies에서 가져온 episode값들을 저장할 리스트
  int aniIndex = 0;

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
                  //print('Menu Select :' + animationName[index].toString());
                  aniIndex = index;
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
              children: <Widget>[
                for (int i = 0; i < animationName.length; i++)
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Text(animationName[i]),
                  ),
              ],
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
                FutureBuilder(
                    future: getMovies(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        //_youtubeIds 길이만큼 반복해서 thumbnailYoutube()함수를 실행
                        return Column(
                          children: [
                            for (int i = 0; i < _youtubeIds.length; i++)
                              thumbnailYoutube(i),
                          ],
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    }),
              ],
            ),
          ],
        ));
  }

  Widget thumbnailYoutube(int index) {
    String getThumbnail({
      //유튜브썸네일 이미지가져오기
      required String videoId,
      String quality = ThumbnailQuality.standard,
      bool webp = true,
    }) =>
        webp
            ? 'https://i3.ytimg.com/vi_webp/$videoId/$quality.webp'
            : 'https://i3.ytimg.com/vi/$videoId/$quality.jpg';

    if (_youtubeIds.isEmpty) {
      return const Text('시청한 영상이 없습니다.');
    } else {
      String? videoId = _youtubeIds[index];
      String? title = _title[index];
      String? season = _seasonNum[index];
      String? episode = _episodeNum[index];
      String thumbnailUrl = getThumbnail(videoId: videoId);
      return Column(children: [
        Container(
          width: 16 * 17.0,
          height: 9 * 17.0,
          color: Colors.black,
          child: Image.network(thumbnailUrl),
        ),
        Text('[시즌$season] $episode화 - $title'),
        const SizedBox(height: 20),
      ]);
    }
  }

  Future getMovies() async {
    _youtubeIds = [];
    var firestore = FirebaseFirestore.instance;
    //uid 가져오기
    final User? user = FirebaseAuth.instance.currentUser;
    final String uid = user!.uid;
    //collection: getItems, document: uid, field: movie
    //movie값을 _docIds에 저장
    await firestore
        .collection('getItems')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if ((documentSnapshot.data() as Map<String, dynamic>)
            .containsKey('movie')) {
          _docIds = List.from(documentSnapshot['movie']);
          _docIds.sort();
          //print(_docIds);
        } else {
          //print('사용자가 얻은 영상이 없습니다.');
        }
      } else {
        //print('사용자가 얻은 영상이 없습니다.');
      }
    });
    //docIds에 저장된 값들을 이용해 영상 정보 가져오기
    for (int i = 0; i < _docIds.length; i++) {
      await firestore
          .collection('movies')
          .doc(_docIds[i])
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          if (documentSnapshot['name'] == animationName[aniIndex]) {
            //print(_docIds[i] + ': ' + documentSnapshot['youtube_id']);
            _youtubeIds.add(documentSnapshot['youtube_id']);
            _seasonNum.add(documentSnapshot['season']);
            _episodeNum.add(documentSnapshot['episode']);
            _title.add(documentSnapshot['title']);
          }
        }
      });
    }
    //print(_youtubeIds);
  }
}
