import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PuzzleGame extends StatefulWidget {
  final String originalPuzzleList; //원본 퍼즐리스트 정보

  const PuzzleGame(
      {super.key,
      required String puzzleListRoute,
      required this.originalPuzzleList});

  @override
  State<PuzzleGame> createState() => _PuzzleGameState();
}

class _PuzzleGameState extends State<PuzzleGame> {
  String? originalPuzzleList;

  List<String> _ownPuzzleSlice = []; //소유하고 있는 퍼즐조각 불러오기
  List<String> _PuzzleSliceList = [];
  List<String> _PuzzleSliceList2 = []; //최종 표시할 퍼즐조각 목록(소유하고있는 퍼즐조각 - 맞춘퍼즐조각)
  List<bool> _isPuzzleSolved = [
    false,
    false,
    false,
    false,
    false,
    false,
  ]; //퍼즐을 맞췄는지 처리할 불함수
  List<String> _savePuzzleSlice = []; //맞춘 퍼즐조각 불러오기

  List<String> _slice_fileName = [];
  List<String> _slice_folder = [];
  List<String> _slice_original = [];
  List<dynamic> _slice_positon = [];

  Future _firebasePuzzleSliceRead() async {
    final FirebaseAuth fb = FirebaseAuth.instance; //파이어베이스 초기화
    final User? user = fb.currentUser;
    final uid = user!.uid; //유저아이디를 불러옵니다.

    //우선 유저아이디가 getItems에 있는지 확인한다.
    final DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('getItems').doc(uid).get();
    if (!doc.exists) {
      print('getItems에 등록된 유저아이디가 없습니다.');
    } else {
      //유저아이디가 getItems에 있으면, puzzleSlice필드가 있는지 확인한다.
      if ((doc.data() as Map<String, dynamic>).containsKey('puzzleSlice')) {
        //puzzleSlice의 값을 _ownPuzzleSlice에 넣는다.
        _ownPuzzleSlice =
            (doc.data() as Map<String, dynamic>)['puzzleSlice'].cast<String>();
        print('_ownPuzzleSlice: $_ownPuzzleSlice');
        //puzzleSlice_save 필드도 있는지 확인한다.
        if ((doc.data() as Map<String, dynamic>)
            .containsKey('puzzleSlice_save')) {
          //puzzleSlice_save의 값을 _savePuzzleSlice에 넣는다.
          _savePuzzleSlice =
              (doc.data() as Map<String, dynamic>)['puzzleSlice_save']
                  .cast<String>();
          //_ownPuzzleSlice에서 _savePuzzleSlice를 빼고 _PuzzleSliceList에 넣는다.
          _PuzzleSliceList = _ownPuzzleSlice
              .toSet()
              .difference(_savePuzzleSlice.toSet())
              .toList();
          print('_PuzzleSliceList: $_PuzzleSliceList');
          print('_savePuzzleSlice: $_savePuzzleSlice');
        } else {
          print('_savePuzzle:Slice : 맞춘 퍼즐조각 없음 (필드가 존재하지 않음)');
          _PuzzleSliceList = _ownPuzzleSlice;
          print('_PuzzleSliceList: $_PuzzleSliceList');
          print('_savePuzzleSlice: $_savePuzzleSlice');
        }
        //_PuzzleSliceList 내림차순 정렬
        _PuzzleSliceList.sort();
        //_PuzzleSliceList의 값에서 6번째 글자가 originalPuzzleList와 같은지 확인한다.
        for (int i = 0; i < _PuzzleSliceList.length; i++) {
          if (_PuzzleSliceList[i].substring(6, 7) ==
              widget.originalPuzzleList) {
            //같으면 _PuzzleSliceList2에 넣는다.
            _PuzzleSliceList2.add(_PuzzleSliceList[i]);
          }
        }
        _PuzzleSliceList2.sort(); //정렬 desc
        print('_PuzzleSliceList2: $_PuzzleSliceList2');
        //puzzle_slice컬렉션에서 _PuzzleSliceList2 값이 있는지 확인한다.
        for (int i = 0; i < _PuzzleSliceList2.length; i++) {
          await FirebaseFirestore.instance
              .collection('puzzle_slice')
              .doc(_PuzzleSliceList2[i])
              .get()
              .then((DocumentSnapshot doc) {
            if (!doc.exists) {
              print('puzzle_slice에 puzzleSlice가 없습니다.');
            } else {
              _slice_fileName.add(doc['file_name']);
              _slice_folder.add(doc['folder']);
              _slice_positon.add(doc['position']);
            }
          });
        }
        //_isPuzzleSolved[i]를 true로 바꾼다.
        for (int i = 0; i < _savePuzzleSlice.length; i++) {
          _isPuzzleSolved[int.parse(_savePuzzleSlice[i].substring(13)) - 1] =
              true;
        }
      } else {
        print('puzzleSlice 필드가 없습니다.');
      }
    }
  }

  @override
  void initState() {
    //가로모드
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    //전체화면
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
  }

  @override
  void dispose() {
    //가로모드 해제
    SystemChrome.setPreferredOrientations([]);
    //전체화면 해제
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: FutureBuilder(
          future: _firebasePuzzleSliceRead(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return _buildScene();
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Widget _buildScene() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: Align(
            alignment: Alignment.center,
            child: _buildPuzzleGame(),
          )),
          Column(
            children: [
              Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.2,
                  color: Colors.blueGrey[100],
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: const [
                      Text('획득한 퍼즐 조각', style: TextStyle(fontSize: 17)),
                      SizedBox(height: 5),
                      Text('퍼즐조각을 옮겨서 그림을 완성하세요!',
                          style: TextStyle(fontSize: 13)),
                    ],
                  )),
              Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.8,
                  color: Colors.blueGrey,
                  child: SingleChildScrollView(
                    child: _buildPuzzleSlice(),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPuzzleGame() {
    return Container(
      width: 450,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              _buildPuzzleImage(1),
              _buildPuzzleImage(2),
              _buildPuzzleImage(3),
            ],
          ),
          Row(
            children: <Widget>[
              _buildPuzzleImage(4),
              _buildPuzzleImage(5),
              _buildPuzzleImage(6),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPuzzleImage(int index) {
    String folder;
    //_slice_folder배열이 비어있으면 folder=1로 초기화
    if (_slice_folder.isEmpty) {
      folder = '1';
    } else {
      folder = _slice_folder[0];
    }
    return DragTarget(builder: (
      BuildContext context,
      List<dynamic> accepted,
      List<dynamic> rejected,
    ) {
      return Container(
        width: 150,
        height: 150,
        child: Image.asset(
          _isPuzzleSolved[index - 1]
              ? 'assets/puzzles/$folder/slice$index.png'
              : 'assets/puzzles/blank_puzzle.png',
          fit: BoxFit.fill,
        ),
      );
    }, onWillAccept: (data) {
      return data == 'slice$index.png';
    }, onAccept: (data) {
      setState(() {
        FirebaseAuth auth = FirebaseAuth.instance;
        String uid = auth.currentUser!.uid;
        String saveFileName = 'puzzle$folder-slice$index';
        _isPuzzleSolved[index - 1] = true;
        //firebase puzzleSlice_save필드에 저장, 필드가 없으면 추가
        //puzzleSlice_save필드 속성은 array
        FirebaseFirestore.instance.collection('getItems').doc(uid).set({
          'puzzleSlice_save': FieldValue.arrayUnion([saveFileName])
        }, SetOptions(merge: true));
      });
    });
  }

  Widget _buildPuzzleSlice() {
    //퍼즐슬라이스조각들 출력...!!
    List<Widget> list = <Widget>[];
    for (var i = 0; i < _PuzzleSliceList2.length; i++) {
      list.add(_buildPuzzleSliceImage(
          _slice_folder[i], _slice_positon[i], _slice_fileName[i]));
      list.add(const SizedBox(height: 20));
    }
    return Column(children: [
      Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: list,
        ),
      )
    ]);
  }

  Widget _buildPuzzleSliceImage(String folder, int index, String fileName) {
    return Visibility(
      visible: !_isPuzzleSolved[index - 1],
      child: Container(
        width: 150,
        height: 150,
        child: Draggable(
          data: fileName,
          child: Image.asset(
            'assets/puzzles/$folder/$fileName',
            fit: BoxFit.fill,
          ),
          feedback: Image.asset(
            'assets/puzzles/$folder/$fileName',
            fit: BoxFit.fill,
          ),
          childWhenDragging: Container(),
        ),
      ),
    );
  }
}
