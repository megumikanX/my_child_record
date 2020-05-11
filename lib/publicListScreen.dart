import 'package:flutter/material.dart';

// 語録リストのページ
class PublicListPageWidget extends StatefulWidget {
  final List<String> words;

  PublicListPageWidget({Key key, this.words}) : super(key: key);

  @override
  PublicListPageWidgetState createState() => PublicListPageWidgetState();
}

class PublicListPageWidgetState extends State<PublicListPageWidget> {
  final Set<String> _saved = Set<String>();
  final TextStyle _biggerFont = TextStyle(fontSize: 20.0);
  final TextStyle _subFont = TextStyle(color: Colors.deepPurple[700]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: Column(
        children: <Widget>[

          FilterChip(
            Label:
          ),
          Expanded(child: _buildListView()),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        return _buildRow(widget.words[i]);
      },
      itemCount: widget.words.length,
    );
  }

  Widget _buildRow(String word) {
    final bool alreadySaved = _saved.contains(word);
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
        trailing: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.pink : null,
        ),
        onTap: () {
          setState(() {
            if (alreadySaved) {
              _saved.remove(word);
            } else {
              _saved.add(word);
            }
          });
        },
      ),
    );
  }
}
