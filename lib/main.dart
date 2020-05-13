import 'package:flutter/material.dart';
import 'myListScreen.dart';
import 'publicListScreen.dart';
import 'inputScreen.dart';
import 'settingScreen.dart';
import 'registrationScreen.dart';
import 'loginScreen.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

// アプリ
class MyApp extends StatelessWidget {
  static const String _title = 'うちの子語録';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: new ThemeData(
        primaryColor: Colors.pink,
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => MainPageWidget(),
        '/input': (BuildContext context) => InputPage(),
        '/register': (BuildContext context) => RegistrationScreen(),
        '/login': (BuildContext context) => LoginScreen(),
      },
    );
  }
}

// メインページ
class MainPageWidget extends StatefulWidget {
  final menuIndex;
  MainPageWidget({Key key, this.menuIndex}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPageWidget> {
  int _selectedIndex = 0;
  static String _uid = 'not login';

  //static List<Map> _myWords = List<Map>();
  //static List<Map> _allWords = List<Map>();

//  final _auth = FirebaseAuth.instance;
//  final _firestore = Firestore.instance;
//  FirebaseUser loggedInUser;

  final _pageWidgets = [
    PublicListPageWidget(),
    ListPageWidget(),
    //ListPageWidget(uid: _uid),
    PageWidget(color: Colors.amber[100], title: '設定'),
  ];

  //ボトムナビでメニューが選ばれた時
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Build --> main');
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        leading: Icon(Icons.child_care),
        title: const Text('うちの子語録'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: _pageWidgets.elementAt(_selectedIndex),
      // 書くボタン
//      floatingActionButton: Visibility(
//        visible: _selectedIndex == 1,
//        child: FloatingActionButton.extended(
//          label: Text('書く'),
//          icon: Icon(Icons.create),
//          backgroundColor: Colors.pinkAccent,
//          onPressed: () async {
//            final result = await Navigator.of(context).pushNamed('/input');
//            if (result != null) {
//              final contentText = 'I received ' + result + ' !';
//              print(contentText);
//              //_myWords.add(result);
//            }
//          },
//        ),
//      ),
      // ボトムナビゲーション
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin),
            title: Text('よそのこ'),
            backgroundColor: Colors.deepPurple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('うちのこ'),
            backgroundColor: Colors.deepPurple,
          ),
//          BottomNavigationBarItem(
//            icon: Icon(Icons.favorite),
//            title: Text('お気に入り'),
//            backgroundColor: Colors.deepPurple,
//          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('設定'),
            backgroundColor: Colors.deepPurple,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.deepPurple[100],
        backgroundColor: Colors.deepPurple[300],
        onTap: _onItemTapped,
      ),
    );
  }
}
