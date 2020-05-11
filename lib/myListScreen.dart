import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// 語録リストのページ
class ListPageWidget extends StatefulWidget {
  //final String uid;
  final List<String> myWords;

  ListPageWidget({Key key, this.myWords}) : super(key: key);

  @override
  ListPageWidgetState createState() => ListPageWidgetState();
}

class ListPageWidgetState extends State<ListPageWidget> {
  final TextStyle _biggerFont = TextStyle(fontSize: 20.0);
  final TextStyle _subFont = TextStyle(color: Colors.deepPurple[700]);

  final _firestore = Firestore.instance;
  //List<String> _myWords = List<String>();

  @override
  void initState() {
    super.initState();

    //getWords();
  }

//  void getWords() async {
//    final words = await _firestore.collection('words').getDocuments();
//    for (var word in words.documents) {
//      print(word.data);
//      Map record = word.data;
//      _myWords.add(record["title"]);
//    }
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: _buildListView(),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        //return _buildRow(widget.words[i]);
        return _buildRow(widget.myWords[i]);
      },
      itemCount: widget.myWords.length,
    );
  }

  Widget _buildRow(String word) {
    return Card(
      color: Colors.yellow[50],
      child: ListTile(
        leading: Icon(Icons.child_care),
        title: Text(
          word,
          style: _biggerFont,
        ),
        subtitle: Text(
          '２歳 言い間違え',
          style: _subFont,
        ),
        isThreeLine: true,
        trailing: Icon(Icons.create, color: Colors.pink),
        onTap: () {},
      ),
    );
  }
}
