import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'inputScreen.dart';

// うちの子語録リストのページ
class ListPageWidget extends StatefulWidget {
  //final List<Map> myWords;
  //final String uid;
  //final FirebaseUser loginUser;

  //ListPageWidget({Key key, this.myWords, this.uid}) : super(key: key);
  ListPageWidget({Key key}) : super(key: key);

  @override
  ListPageWidgetState createState() => ListPageWidgetState();
}

class ListPageWidgetState extends State<ListPageWidget> {
  final TextStyle _biggerFont = TextStyle(fontSize: 20.0);
  final TextStyle _subFont = TextStyle(color: Colors.deepPurple[700]);

  final List<String> ageOption = ['2〜3歳', '4〜5歳', '6歳以上'];
  final List<String> typeOption = ['言い間違い', '名言', '印象に残る言葉'];

  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  FirebaseUser loggedInUser;

  List<Map> _myWords = List<Map>();
  String _uid = 'not login';
  String _email = 'not login';

  @override
  void initState() {
    super.initState();

    getCurrentUser();
    //getMyWords();
  }

  @override
  void didUpdateWidget(ListPageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    //getCurrentUser();
    getMyWords();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
        print(loggedInUser.uid);
        _uid = loggedInUser.uid;
        setState(() {
          _email = loggedInUser.email;
        });
        getMyWords();
      } else {
        print('not login');
        _uid = 'not login';
      }
    } catch (e) {
      print(e);
    }
  }

  void getMyWords() async {
    _myWords = [];
    print('get my words');
    try {
      final words = await _firestore
          .collection('words')
          .where("userID", isEqualTo: loggedInUser.uid)
          .orderBy("createdAt", descending: true)
          .getDocuments();
      for (var word in words.documents) {
        Map record = word.data;
        record["documentID"] = word.documentID;
        setState(() {
          _myWords.add(record);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Build --> myListPageWidget');
    return Scaffold(
      backgroundColor: Colors.pink[50],
      //body: widget.isLogin ? _buildListView() : Text('ログインしてね'),
      body: Column(
        children: <Widget>[
          Text(_email),
          Expanded(child: _buildListView()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('書く'),
        icon: Icon(Icons.create),
        backgroundColor: Colors.pinkAccent,
//        onPressed: () async {
//          final result = await Navigator.of(context).pushNamed('/input');
//          if (result != null) {
//            final contentText = 'I received ' + result + ' !';
//            print(contentText);
//            //_myWords.add(result);
//          }
        onPressed: () {
          Map record;
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InputScreen(record, getMyWords),
              ));
        },
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        return _buildRow(_myWords[i]);
      },
      itemCount: _myWords.length,
    );
  }

  Widget _buildRow(Map word) {
    final String age = ageOption[word["ageOption"]];
    final String type = typeOption[word["typeOption"]];

    return Card(
      color: Colors.yellow[50],
      child: ListTile(
        leading: Icon(Icons.child_care),
        title: Text(
          word["title"],
          style: _biggerFont,
        ),
        subtitle: Text(
          word["detail"] + "\n" + age + " " + type,
          //word["detail"],
          style: _subFont,
        ),
        isThreeLine: true,
        trailing: Icon(Icons.create, color: Colors.pink),
        onTap: () {
          print(word["documentID"]);
          String documentID = word["documentID"];
          Map record = word;
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InputScreen(record, getMyWords),
              ));
        },
      ),
    );
  }
}
