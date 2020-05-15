import 'package:flutter/material.dart';
import 'myListScreen.dart';
import 'publicListScreen.dart';
import 'settingScreen.dart';
import 'registrationScreen.dart';
import 'loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        '/': (BuildContext context) => MainPageWidget(loginUser: null),
        '/register': (BuildContext context) => RegistrationScreen(),
        '/login': (BuildContext context) => LoginScreen(),
      },
    );
  }
}

// メインページ
class MainPageWidget extends StatefulWidget {
  //final String uid;
  final FirebaseUser loginUser;
  MainPageWidget({Key key, this.loginUser}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPageWidget> {
  int _selectedIndex = 0;

  final _pageWidgets = [
    PublicListPageWidget(),
    ListPageWidget(),
    PageWidget(color: Colors.amber[100], title: '設定'),
  ];

  @override
  void initState() {
    super.initState();

    print(widget.loginUser);
  }

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
      // ボトムナビゲーション
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.collections_bookmark),
            title: Text('みんなの語録'),
            backgroundColor: Colors.deepPurple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('うちのこ語録'),
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
