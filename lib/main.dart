import 'package:flutter/material.dart';
import 'my_list_screen.dart';
import 'public_list_screen.dart';
import 'setting_screen.dart';
import 'registration_screen.dart';
import 'login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter_icons/flutter_icons.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const String _title = 'うちのこ語録';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: new ThemeData(
        primaryColor: Colors.pink,
        fontFamily: 'TypeGothic',
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
    PageWidget(),
  ];

  @override
  void initState() {
    super.initState();

    print(widget.loginUser);
  }

  //ボトムナビでメニューが選ばれた時
  void onMenuSelected(int index) {
    setState(() {
      if (index == null) {
        index = 1;
      }
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Build --> main');
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        //leading: Icon(Icons.child_care),
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 0.0, 0.0, 0.0),
          child: Image(
            image: AssetImage('images/face1.png'),
          ),
        ),
        title: const Text('うちのこ語録'),
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
        onTap: onMenuSelected,
      ),
    );
  }
}
