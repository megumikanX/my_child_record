import 'package:flutter/material.dart';

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
              validator: (value) { // _formKey.currentState.validate()でコールされる
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null; // 問題ない場合はnullを返す
              },
              onSaved: (value) { // this._formKey.currentState.save()でコールされる
                //Navigator.popUntil(context,ModalRoute.withName('/'));
                Navigator.of(context).pop(value);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    this._formKey.currentState.save();
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