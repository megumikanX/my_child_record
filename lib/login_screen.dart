import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:device_info/device_info.dart';

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
      body: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

/// Apple認証で取得したフルネームを保存して使用するためのクラス
class AuthCredentialWithApple {
  AuthCredentialWithApple({
    @required this.authCredential,
    this.givenName,
    this.familyName,
  });
  AuthCredential authCredential;
  String givenName;
  String familyName;
}

class _LoginFormState extends State<LoginForm> {
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final AppleSignIn _appleSignIn = AppleSignIn();

  Future<bool> _canSignInWithApple() async {
    //if (!Platform.isIOS) return false; // Android ではこの機能を提供しない方針の場合。
    final iosInfo = await DeviceInfoPlugin().iosInfo;
    final version = iosInfo.systemVersion;
    // 13 以上なら〜
  }

  bool showSpinner = false;

  /// Sign in with Googleが押された
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

  /// Sign in with Appleが押された
  Future<FirebaseUser> _signInWithApple() async {
    final result = await AppleSignIn.performRequests([
      AppleIdRequest(
        requestedScopes: [Scope.fullName],
        requestedOperation: OpenIdOperation.operationLogin,
      )
    ]);

    const oAuthProvider = OAuthProvider(providerId: 'apple.com');
    final credential = oAuthProvider.getCredential(
      idToken: String.fromCharCodes(result.credential.identityToken),
      accessToken: String.fromCharCodes(result.credential.authorizationCode),
    );
    final FirebaseUser user =
        (await FirebaseAuth.instance.signInWithCredential(credential)).user;
    return user;
  }

  //ログイン後
  void afterLoginProcess(FirebaseUser user) async {
    if (user == null) return;

    final result =
        await _firestore.collection('users').document(user.uid).setData({
      'name': ' ',
      'recentLoginAt': DateTime.now(),
    });

    setState(() {
      showSpinner = false;
    });

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainPageWidget(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Form(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: Column(
              children: <Widget>[
//          RaisedButton(
//            child: Text('Googleでサインイン'),
//            onPressed: () {
//              _handleSignIn()
//                  .then((FirebaseUser user) => afterLoginProcess(user))
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
                    onPressed: () {
                      setState(() {
                        showSpinner = true;
                      });
                      _signInWithApple()
                          .then((FirebaseUser user) => afterLoginProcess(user))
                          .catchError((e) => print(e));
                    },
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
                      setState(() {
                        showSpinner = true;
                      });
                      _handleSignIn()
                          .then((FirebaseUser user) => afterLoginProcess(user))
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
        ),
      ),
    );
  }
}
