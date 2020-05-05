import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 入力画面
class InputPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("入力画面")),
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
                Navigator.of(context).pop(value);
              },
            ),
            MyThreeOptions(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    this._formKey.currentState.save();
                  }
                  //wordText + loggedInUser.email
                  _firestore
                      .collection('words')
                      .add({'title': wordText, 'userID': loggedInUser.email});
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

class MyThreeOptions extends StatefulWidget {
  @override
  _MyThreeOptionsState createState() => _MyThreeOptionsState();
}

class _MyThreeOptionsState extends State<MyThreeOptions> {
  int _value = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: List<Widget>.generate(
          3,
          (int index) {
            return ChoiceChip(
              label: Text('Item $index'),
              selected: _value == index,
              onSelected: (bool selected) {
                setState(() {
                  _value = selected ? index : null;
                });
              },
            );
          },
        ).toList(),
      ),
    );
  }
}
