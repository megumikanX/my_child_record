import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 入力画面
class InputScreen extends StatelessWidget {
  final Map record;
  final void Function() getWords;

  InputScreen(this.record, this.getWords);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("入力")),
      body: Center(child: InputFormWidget(record: record, getWords: getWords)),
    );
  }
}

// 入力Form
class InputFormWidget extends StatefulWidget {
  final Map record;
  final void Function() getWords;
  InputFormWidget({Key key, this.record, this.getWords}) : super(key: key);

  @override
  _InputFormWidgetState createState() => _InputFormWidgetState();
}

class _InputFormWidgetState extends State<InputFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  FirebaseUser loggedInUser;

  String wordText;
  String detailText;

  int age = 1;
  final List<String> ageOption = ['2〜3歳', '4〜5歳', '6歳以上'];

  int type = 1;
  final List<String> typeOption = ['言い間違い', '名言', '印象に残る言葉'];

  int public = 0;
  final List<String> publicOption = ['非公開', '公開'];

  @override
  void initState() {
    super.initState();

    if (widget.record == null) {
      getCurrentUser();
    } else {
      wordText = widget.record["title"];
      detailText = widget.record["detail"];
    }
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(padding: EdgeInsets.all(8.0), child: Text('子が発した言葉の記録')),
            TextFormField(
              initialValue:
                  (widget.record != null) ? widget.record["title"] : '',
              decoration: const InputDecoration(
                hintText: '例：　すたべっきー',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                // _formKey.currentState.validate()でコールされる
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null; // 問題ない場合はnullを返す
              },
              onChanged: (value) {
                wordText = value;
              },
              onSaved: (value) {
                // this._formKey.currentState.save()でコールされる
                //Navigator.popUntil(context,ModalRoute.withName('/'));
                //Navigator.of(context).pop(value);
              },
            ),
            Container(padding: EdgeInsets.all(8.0), child: Text('意味や説明')),
            TextFormField(
              initialValue:
                  (widget.record != null) ? widget.record["detail"] : '',
              decoration: const InputDecoration(
                hintText: '例：　スパゲッティー',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                // _formKey.currentState.validate()でコールされる
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null; // 問題ない場合はnullを返す
              },
              onChanged: (value) {
                detailText = value;
              },
            ),
            //AgeOptions(selec),
            Wrap(
              spacing: 5.0,
              children: List<Widget>.generate(
                3,
                (int index) {
                  return ChoiceChip(
                    label: Text(ageOption[index]),
                    selected: age == index,
                    onSelected: (bool selected) {
                      setState(() {
                        age = selected ? index : null;
                        print(age);
                      });
                    },
                  );
                },
              ).toList(),
            ),
            Wrap(
              spacing: 5.0,
              children: List<Widget>.generate(
                3,
                (int index) {
                  return ChoiceChip(
                    label: Text(typeOption[index]),
                    selected: type == index,
                    onSelected: (bool selected) {
                      setState(() {
                        type = selected ? index : null;
                        print(type);
                      });
                    },
                  );
                },
              ).toList(),
            ),
            Wrap(
              spacing: 5.0,
              children: List<Widget>.generate(
                2,
                (int index) {
                  return ChoiceChip(
                    label: Text(publicOption[index]),
                    selected: public == index,
                    onSelected: (bool selected) {
                      setState(() {
                        public = selected ? index : null;
                        print(public);
                      });
                    },
                  );
                },
              ).toList(),
            ),
            //publicOptions(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    //this._formKey.currentState.save();

                    //新規登録の場合
                    if (widget.record == null) {
                      final result = await _firestore.collection('words').add({
                        'userID': loggedInUser.uid,
                        'title': wordText,
                        'detail': detailText,
                        'ageOption': age,
                        'typeOption': type,
                        'favCount': 0,
                        'isPublic': public,
                        'createdAt': DateTime.now(),
                        'updatedAt': DateTime.now(),
                      });

                      //更新の場合
                    } else {
                      final ref = _firestore
                          .collection('words')
                          .document(widget.record["documentID"]);
                      await ref.updateData({
                        'title': wordText,
                        'detail': detailText,
                        'ageOption': age,
                        'typeOption': type,
                        'isPublic': public,
                        'updatedAt': DateTime.now()
                      });
                    }
                    widget.getWords();
                    Navigator.of(context).pop();
                  }
                },
                child: Text('保存'),
                color: Colors.deepPurple[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
