import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

// 他のページ
class PageWidget extends StatelessWidget {
  final void Function() onMenuSelected;

  PageWidget({Key key, this.onMenuSelected}) : super(key: key);

  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<FirebaseUser> _handleSignIn() async {
    GoogleSignInAccount googleCurrentUser = _googleSignIn.currentUser;
    try {
      if (googleCurrentUser == null)
        googleCurrentUser = await _googleSignIn.signInSilently();
      if (googleCurrentUser == null)
        googleCurrentUser = await _googleSignIn.signIn();
      if (googleCurrentUser == null) return null;

      GoogleSignInAuthentication googleAuth =
          await googleCurrentUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;
      print("signed in " + user.displayName);

      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  //メインページ遷移
  void transitionNextPage(FirebaseUser user) async {
    if (user == null) return;

    final result = await _firestore
        .collection('users')
        .document(user.uid)
        .setData({'name': ' ', 'createdAt': DateTime.now()});

//    Navigator.push(
//        context,
//        MaterialPageRoute(
//          builder: (context) => MainPageWidget(),
//        ));

    onMenuSelected();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
//            RaisedButton(
//              child: Text('Sign in Google'),
//              onPressed: () {
//                _handleSignIn()
//                    .then((FirebaseUser user) => transitionNextPage(user))
//                    .catchError((e) => print(e));
//              },
//            ),
//            RaisedButton(
//                child: Text('新規登録'),
//                onPressed: () async {
//                  await Navigator.of(context).pushNamed('/register');
//                }),
          RaisedButton(
              child: Text('ログイン'),
              onPressed: () async {
                await Navigator.of(context).pushNamed('/login');
              }),
          RaisedButton(
              child: Text('ログアウト'),
              onPressed: () {
                _auth.signOut();
              }),
          //RegistrationScreen(),
          // Image(
          //   image: AssetImage('images/photo.png'),
          // ),
        ],
      ),
    );
  }
}
