import 'package:flutter/material.dart';
import 'listScreen.dart';
import 'inputScreen.dart';
import 'settingScreen.dart';
import 'registrationScreen.dart';
import 'loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  static List<String> _words = [
    'てべり (テレビ）',
    'ちゃまま (パジャマ）',
    'かとぱー (パトカー）',
    'ぱんかい (カンパイ）',
    'エベレーター(エレベーター)',
    '元気ぼりぼり(元気もりもり)',
    'aaaaaaaaaa',
    'eegesge',
    'eg3gs',
    'eget5hhter',
    'eee',
    'ooo',
    'aaa'
  ];

  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  FirebaseUser loggedInUser;

  final _pageWidgets = [
    ListPageWidget(words: _words),
    ListPageWidget(words: _words),
    ListPageWidget(words: _words),
    PageWidget(color: Colors.amber[100], title: '設定'),
  ];

  @override
  void initState() {
    super.initState();

    getCurrentUser();
    getWords();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
        print(loggedInUser.uid);
      } else {
        print('not login');
      }
    } catch (e) {
      print(e);
    }
  }

  void getWords() async {
    final words = await _firestore.collection('words').getDocuments();
    for (var word in words.documents) {
      print(word.data);
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        leading: Icon(Icons.child_care),
        title: const Text('うちの子語録'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: _pageWidgets.elementAt(_selectedIndex),
      // 書くボタン
      floatingActionButton: FloatingActionButton.extended(
        label: Text('書く'),
        icon: Icon(Icons.create),
        backgroundColor: Colors.pinkAccent,
        onPressed: () async {
          final result = await Navigator.of(context).pushNamed('/input');
          if (result != null) {
            final contentText = 'I received ' + result + ' !';
            _words.add(result);
            print(contentText);
          }
        },
      ),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            title: Text('お気に入り'),
            backgroundColor: Colors.deepPurple,
          ),
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
