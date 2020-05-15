import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// みんなの語録リストのページ
class PublicListPageWidget extends StatefulWidget {
  //final List<Map> words;

  PublicListPageWidget({Key key}) : super(key: key);

  @override
  PublicListPageWidgetState createState() => PublicListPageWidgetState();
}

class PublicListPageWidgetState extends State<PublicListPageWidget> {
  List<String> _saved = List<String>();
  final TextStyle _biggerFont = TextStyle(fontSize: 20.0);
  final TextStyle _subFont = TextStyle(color: Colors.deepPurple[700]);
  final TextStyle _counterFont = TextStyle(color: Colors.pinkAccent[700]);

  final List<String> ageOption = ['2〜3歳', '4〜5歳', '6歳以上'];
  final List<String> typeOption = ['言い間違い', '名言', '印象に残る言葉'];

  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  FirebaseUser loggedInUser;

  List<Map> _allWords = List<Map>();

  int orderByValue = 0;
  int filterValue = 0;

  @override
  void initState() {
    super.initState();

    getAllWords();
    getCurrentUser();
  }

  void getAllWords() async {
    try {
      final words = await _firestore
          .collection('words')
          .where("isPublic", isEqualTo: 1)
          .orderBy("createdAt", descending: true)
          .getDocuments();
      for (var word in words.documents) {
        Map record = word.data;
        record["documentID"] = word.documentID;
        setState(() {
          _allWords.add(record);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;

        getFavList();
      } else {
        print('not login');
      }
    } catch (e) {
      print(e);
    }
  }

  void getFavList() async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('users').document(loggedInUser.uid).get();
      Map record = docSnapshot.data;
      print('get Fav list');

      _saved = record["favWordIDs"].cast<String>();
      var trimList = _saved.map((item) => item.trim()).toList();

      setState(() {
        _saved = trimList;
      });
    } catch (e) {
      print(e);
    }
  }

  void incrementCounter(int index) {
    setState(() {
      _allWords[index]["favCount"] = _allWords[index]["favCount"] + 1;
    });
  }

  void decrementCounter(int index) {
    setState(() {
      _allWords[index]["favCount"] = _allWords[index]["favCount"] - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Build --> PublicListPageWidget');
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 20.0),
                child: CupertinoSlidingSegmentedControl<int>(
                  children: {0: Text("新着順"), 1: Text("人気順")},
                  groupValue: orderByValue,
                  thumbColor: Colors.amberAccent[100],
                  onValueChanged: (int newValue) {
                    setState(() {
                      orderByValue = newValue;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CupertinoSlidingSegmentedControl<int>(
                  children: {0: Text("すべて"), 1: Text("♡のみ")},
                  groupValue: filterValue,
                  thumbColor: Colors.amberAccent[100],
                  onValueChanged: (int newValue) {
                    setState(() {
                      filterValue = newValue;
                    });
                  },
                ),
              ),
            ],
          ),
          //SelectFilter(),
          Expanded(child: _buildListView()),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        return _buildRow(_allWords[i], i);
      },
      itemCount: _allWords.length,
    );
  }

  Widget _buildRow(Map word, int index) {
    print('Build --> PublicListPageWidgetRow' + index.toString());
    //print(word["documentID"]);
    //print(_saved);
    final bool alreadySaved = _saved.contains(word["documentID"]);
    //print(alreadySaved);
    final String age = ageOption[word["ageOption"]];
    final String type = typeOption[word["typeOption"]];
    int favCount = word["favCount"];

    return Card(
      color: Colors.yellow[50],
      child: ListTile(
        leading: Column(
          children: <Widget>[
            Icon(Icons.child_care),
            Text(favCount.toRadixString(10), style: _counterFont),
          ],
        ),
        title: Text(
          word["title"],
          style: _biggerFont,
        ),
        subtitle: Text(
          word["detail"] + "\n" + age + " " + type,
          style: _subFont,
        ),
        isThreeLine: true,
        trailing: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.pink : null,
        ),
        onTap: () async {
          if (alreadySaved) {
            decrementCounter(index);
            _saved.remove(word["documentID"]);
            await _firestore
                .collection('words')
                .document(word["documentID"])
                .updateData({'favCount': word["favCount"] - 1});
//            setState(() {
//              _saved.remove(word["documentID"]);
//            });
//            decrementCounter(index);
          } else {
            incrementCounter(index);
            await _firestore
                .collection('words')
                .document(word["documentID"])
                .updateData({'favCount': word["favCount"] + 1});
            setState(() {
              _saved.add(word["documentID"]);
            });
            await _firestore
                .collection('users')
                .document(loggedInUser.uid)
                .updateData(
                    //{'favWordIDs': FieldValue.arrayUnion(word["documentID"])});
                    {'favWordIDs': _saved});
          }
        },
      ),
    );
  }
}
