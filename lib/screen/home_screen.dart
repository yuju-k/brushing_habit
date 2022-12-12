import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    return Scaffold(
      //앱바 중앙에 타이틀
      //오른쪽에 설정 아이콘 - 서랍메뉴
      appBar: AppBar(title: const Text('유아양치습관형성 DTx'), centerTitle: true),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: Colors.grey[850],
              ),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/setting');
              },
              trailing: const Icon(Icons.arrow_right),
            ),
          ],
        ),
      ),
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
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          //** 기본 메뉴: 퍼즐모음, 영상모음, 달성표 **/
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //퍼즐모음 아이콘-타이틀
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/puzzle');
                    },
                    iconSize: 75,
                    icon: Image.asset(
                      'assets/icon/icon_puzzle.png',
                    ),
                  ),
                  const Text('퍼즐모음'),
                ],
              ),

              // ignore: prefer_const_constructors
              SizedBox(
                width: 20,
              ),

              //영상모음 아이콘-타이틀
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/movie');
                    },
                    iconSize: 75,
                    icon: Image.asset(
                      'assets/icon/icon_movies.png',
                    ),
                  ),
                  const Text('영상모음'),
                ],
              ),

              // ignore: prefer_const_constructors
              SizedBox(
                width: 20,
              ),

              //달성표 아이콘-타이틀
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/goals');
                    },
                    iconSize: 75,
                    icon: Image.asset(
                      'assets/icon/icon_goal.png',
                    ),
                  ),
                  const Text('달성표'),
                ],
              ),
            ],
          ),

          // ignore: prefer_const_constructors
          SizedBox(height: 35),

          Container(
              //둥근모서리, 테두리 색 파란색
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue)),
              alignment: Alignment.center,
              width: 280,
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Container 내부 내용
                  const Text('양치를 했나요?'),
                  //네, 아니오 버튼
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          //네 버튼
                          //버튼스타일 흰 배경에 파란색 테두리
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.blue,
                              backgroundColor: Colors.white,
                              side: const BorderSide(
                                  color: Color.fromARGB(255, 142, 192, 233))),
                          onPressed: () {
                            Navigator.pushNamed(context, '/claer');
                          },
                          child: const Text(
                            '\u{1F603}네!',
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold),
                          )),
                      // ignore: prefer_const_constructors
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                          //아니오 버튼
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.blue,
                              backgroundColor: Colors.white,
                              side: const BorderSide(
                                  color: Color.fromARGB(255, 142, 192, 233))),
                          onPressed: () {
                            Navigator.pushNamed(context, '/run');
                          },
                          child: const Text(
                            '\u{1F613}아니요',
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold),
                          )),
                    ],
                  )
                ],
              )),
        ]));
  }
}
