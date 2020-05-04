import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 他のページ
class PageWidget extends StatelessWidget {
  final Color color;
  final String title;

  PageWidget({Key key, this.color, this.title}) : super(key: key);

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: Column(
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            RaisedButton(
              child: Text('新規登録'),
              onPressed: () async {
                await Navigator.of(context).pushNamed('/register');
              }
            ),
            RaisedButton(
                child: Text('ログイン'),
                onPressed: () async {
                  await Navigator.of(context).pushNamed('/login');
                }
            ),
            RaisedButton(
                child: Text('ログアウト'),
                onPressed: () {
                  _auth.signOut();
                }
            ),
            //RegistrationScreen(),
            // Image(
            //   image: AssetImage('images/photo.png'),
            // ),
          ],
        ),
      ),
    );
  }
}

