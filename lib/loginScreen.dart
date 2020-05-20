import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //leading: Icon(Icons.child_care),
        title: const Text('ログイン'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final AppleSignIn _appleSignIn = AppleSignIn();

  String email;
  String password;

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

  //ログイン後
  void transitionNextPage(FirebaseUser user) async {
    if (user == null) return;

    final result =
        await _firestore.collection('users').document(user.uid).setData({
      'name': ' ',
      'recentLoginAt': DateTime.now(),
    });

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainPageWidget(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Center(
        child: Column(
          children: <Widget>[
//          RaisedButton(
//            child: Text('Googleでサインイン'),
//            onPressed: () {
//              _handleSignIn()
//                  .then((FirebaseUser user) => transitionNextPage(user))
//                  .catchError((e) => print(e));
//            },
//          ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SignInButton(
                Buttons.Apple,
                // mini: true,
                text: 'Appleでサインイン',
                // padding: const EdgeInsets.all(0),
                shape: StadiumBorder(
                  side: const BorderSide(width: 1),
                ),
                onPressed: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SignInButton(
                Buttons.Google,
                // mini: true,
                text: 'Googleでサインイン',
                // padding: const EdgeInsets.all(0),
                shape: StadiumBorder(
                  side: const BorderSide(width: 1),
                ),
                onPressed: () {
                  _handleSignIn()
                      .then((FirebaseUser user) => transitionNextPage(user))
                      .catchError((e) => print(e));
                },
              ),
            )
//          TextFormField(
//            textAlign: TextAlign.center,
//            keyboardType: TextInputType.emailAddress,
//            onChanged: (value) {
//              email = value;
//            },
//            decoration: const InputDecoration(
//              hintText: 'Email',
//            ),
//          ),
//          TextFormField(
//            textAlign: TextAlign.center,
//            obscureText: true,
//            onChanged: (value) {
//              password = value;
//            },
//            decoration: const InputDecoration(
//              hintText: 'Password',
//            ),
//          ),
//          RaisedButton(
//              child: Text('login'),
//              onPressed: () async {
//                try {
//                  final user = await _auth.signInWithEmailAndPassword(
//                      email: email, password: password);
//                  final loginUser = await _auth.currentUser();
//                  if (user != null) {
//                    print('login ok');
//                    print(loginUser.uid);
//                    //Navigator.of(context).pushNamed('/');
//                    Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                          builder: (context) => MainPageWidget(),
//                        ));
//                  }
//                } catch (e) {
//                  print(e);
//                }
//              })
          ],
        ),
      ),
    );
  }
}
