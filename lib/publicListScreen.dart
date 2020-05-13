import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// 語録リストのページ
class PublicListPageWidget extends StatefulWidget {
  //final List<Map> words;

  PublicListPageWidget({Key key}) : super(key: key);

  @override
  PublicListPageWidgetState createState() => PublicListPageWidgetState();
}

class PublicListPageWidgetState extends State<PublicListPageWidget> {
  final Set<String> _saved = Set<String>();
  final TextStyle _biggerFont = TextStyle(fontSize: 20.0);
  final TextStyle _subFont = TextStyle(color: Colors.deepPurple[700]);

  final List<String> ageOption = ['2〜3歳', '4〜5歳', 'それ以上'];
  final List<String> typeOption = ['言い間違い', '名言', '印象に残る言葉'];

  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  FirebaseUser loggedInUser;

  List<Map> _allWords = List<Map>();

  @override
  void initState() {
    super.initState();

    getAllWords();
  }

  void getAllWords() async {
    final words = await _firestore
        .collection('words')
        .where("isPublic", isEqualTo: 1)
        .getDocuments();
    for (var word in words.documents) {
      Map record = word.data;
      setState(() {
        _allWords.add(record);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Build --> PublicListPageWidget');
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: Column(
        children: <Widget>[
          CastFilter(),
          Expanded(child: _buildListView()),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        return _buildRow(_allWords[i]);
      },
      itemCount: _allWords.length,
    );
  }

  Widget _buildRow(Map word) {
    final bool alreadySaved = _saved.contains(word);
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
          style: _subFont,
        ),
        isThreeLine: true,
        trailing: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.pink : null,
        ),
        onTap: () {
          setState(() {
            if (alreadySaved) {
              _saved.remove(word["id"]);
            } else {
              _saved.add(word["id"]);
            }
          });
        },
      ),
    );
  }
}

class ActorFilterEntry {
  const ActorFilterEntry(this.name, this.initials);
  final String name;
  final String initials;
}

class CastFilter extends StatefulWidget {
  @override
  State createState() => CastFilterState();
}

class CastFilterState extends State<CastFilter> {
  final List<ActorFilterEntry> _cast = <ActorFilterEntry>[
    const ActorFilterEntry('2〜3歳', ' '),
    const ActorFilterEntry('4〜5歳', ' '),
    const ActorFilterEntry('それ以上', ' '),
    const ActorFilterEntry('♡のみ', ' '),
    const ActorFilterEntry('言い間違い', ' '),
    const ActorFilterEntry('名言', ' '),
    const ActorFilterEntry('印象に残る言葉', ' '),
  ];
  List<String> _filters = <String>[];

  Iterable<Widget> get actorWidgets sync* {
    for (final ActorFilterEntry actor in _cast) {
      yield Padding(
        padding: const EdgeInsets.all(4.0),
        child: FilterChip(
          //avatar: CircleAvatar(child: Text(actor.initials)),
          backgroundColor: Colors.white,
          checkmarkColor: Colors.pinkAccent,
          selectedColor: Colors.amberAccent,
          label: Text(actor.name),
          selected: _filters.contains(actor.name),
          onSelected: (bool value) {
            setState(() {
              if (value) {
                _filters.add(actor.name);
              } else {
                _filters.removeWhere((String name) {
                  return name == actor.name;
                });
              }
            });
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Wrap(
          spacing: 5.0,
          runSpacing: 3.0,
          children: actorWidgets.toList(),
        ),
        //Text('Look for: ${_filters.join(', ')}'),
      ],
    );
  }
}
