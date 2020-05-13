import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 入力画面
class InputPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("入力")),
      body: Center(child: InputFormWidget()),
    );
  }
}

// 入力Form
class InputFormWidget extends StatefulWidget {
  InputFormWidget({Key key}) : super(key: key);
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
  final List<String> ageOption = ['2〜3歳', '4〜5歳', 'それ以上'];

  int type = 1;
  final List<String> typeOption = ['言い間違い', '名言', '印象に残る言葉'];

  int public = 0;
  final List<String> publicOption = ['非公開', '公開'];

  @override
  void initState() {
    super.initState();

    getCurrentUser();
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
            TextFormField(
              decoration: const InputDecoration(
                hintText: '子供の可愛い言い間違えや名言を登録しよう',
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
            TextFormField(
              decoration: const InputDecoration(
                hintText: '意味や説明を簡単に',
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
                onPressed: () {
//                  if (_formKey.currentState.validate()) {
//                    this._formKey.currentState.save();
//                  }
                  _firestore.collection('words').add({
                    'userID': loggedInUser.email,
                    'title': wordText,
                    'detail': detailText,
                    'ageOption': age,
                    'typeOption': type,
                    'favCount': 0,
                    'isPublic': public,
                    'createdAt': DateTime.now(),
                    'updatedAt': DateTime.now(),
                  });
                  Navigator.of(context).pop();
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
