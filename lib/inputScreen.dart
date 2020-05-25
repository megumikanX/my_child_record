import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

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
  final List<String> typeOption = ['言い間違い', '名言/迷言', '印象に残る言葉'];

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

  showDebugPrint() {
    debugPrint('Print from Callback Function');
  }

  deleteWord() async {
    final result = await _firestore
        .collection('words')
        .document(widget.record["documentID"])
        .delete();
    widget.getWords();
    Navigator.of(context).pop();
  }

  saveWord() async {
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
      final ref =
          _firestore.collection('words').document(widget.record["documentID"]);
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        height: double.infinity,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(8.0),
                  child: Text('子が発した面白かわいい言葉を記録してみよう。')),
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                maxLength: 100,
                autofocus: true,
                initialValue:
                    (widget.record != null) ? widget.record["title"] : '',
                decoration: const InputDecoration(
                  hintText: '例：　すたべっきー',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  // _formKey.currentState.validate()でコールされる
                  if (value.isEmpty) {
                    return '必須入力です';
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
                keyboardType: TextInputType.multiline,
                maxLines: null,
                maxLength: 100,
                initialValue:
                    (widget.record != null) ? widget.record["detail"] : '',
                decoration: const InputDecoration(
                  hintText: '例：　スパゲッティー',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  // _formKey.currentState.validate()でコールされる
                  if (value.isEmpty) {
                    return '必須入力です';
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
                          //age = selected ? index : null;
                          age = index;
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
                          //type = selected ? index : null;
                          type = index;
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
                          //public = selected ? index : null;
                          public = index;
                        });
                      },
                    );
                  },
                ).toList(),
              ),
              //publicOptions(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Visibility(
                        visible: widget.record != null,
                        //削除ボタン
                        child: RaisedButton(
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.delete_forever),
                                Text('削除'),
                              ],
                            ),
                            color: Colors.white,
                            elevation: 8.0,
                            shape: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            onPressed: () async {
                              await AwesomeDialog(
                                  context: context,
                                  headerAnimationLoop: false,
                                  dialogType: DialogType.INFO,
                                  animType: AnimType.BOTTOMSLIDE,
                                  tittle: 'このデータを削除しますか？',
                                  desc: '"' + wordText + '"',
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () {
                                    deleteWord();
                                  }).show();
                            }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton.icon(
                        icon: Icon(
                          Icons.save_alt,
                        ),
                        label: Text('保存'),
                        elevation: 8.0,
                        color: Colors.deepPurple,
                        textColor: Colors.white,
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            //this._formKey.currentState.save();

                            AwesomeDialog(
                                context: context,
                                animType: AnimType.LEFTSLIDE,
                                headerAnimationLoop: false,
                                dialogType: DialogType.SUCCES,
                                tittle: '登録しました！',
                                desc: '',
                                btnOkOnPress: () {
                                  saveWord();
                                },
                                btnOkIcon: Icons.check_circle,
                                onDissmissCallback: () {
                                  debugPrint('Dialog Dissmiss from callback');
                                }).show();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
