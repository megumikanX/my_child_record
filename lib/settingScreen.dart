import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:launch_review/launch_review.dart';
import 'package:flutter_share/flutter_share.dart';

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

  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'うちのこ語録',
        text: 'うちのこ語録',
        linkUrl: 'https://flutter.dev/',
        chooserTitle: '');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 50.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: RaisedButton(
                    color: Colors.white,
                    shape: StadiumBorder(
                      side: BorderSide(color: Colors.deepPurple),
                    ),
                    child: Text('ログイン'),
                    onPressed: () async {
                      await Navigator.of(context).pushNamed('/login');
                    }),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: RaisedButton(
                    color: Colors.white,
                    shape: StadiumBorder(
                      side: BorderSide(color: Colors.deepPurple),
                    ),
                    child: Text('ログアウト'),
                    onPressed: () {
                      AwesomeDialog(
                          context: context,
                          animType: AnimType.LEFTSLIDE,
                          headerAnimationLoop: false,
                          dialogType: DialogType.SUCCES,
                          tittle: 'ログアウトしました',
                          desc: ' ',
                          btnOkOnPress: () {
                            _auth.signOut();
                          },
                          btnOkIcon: Icons.check_circle,
                          onDissmissCallback: () {
                            debugPrint('Dialog Dissmiss from callback');
                          }).show();
                    }),
              ),
              //RegistrationScreen(),
              // Image(
              //   image: AssetImage('images/photo.png'),
              // ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: FlatButton(
              onPressed: () {
                String email = 'megumikan.works@gmail.com';
                String subject = Uri.encodeComponent('aaa');
                String body = Uri.encodeComponent('bbb.');
                String url = 'mailto:$email?subject=$subject&body=$body';
                launchURL(url);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.mail),
                  Text(
                    'お問い合わせ',
                    style: TextStyle(
                      fontSize: 16,
                      //decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: FlatButton(
              onPressed: () {
                launchURL('https://flutter.dev');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.book),
                  Text(
                    'プライバシーポリシー',
                    style: TextStyle(
                      fontSize: 16,
                      //decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: FlatButton(
              onPressed: () => LaunchReview.launch(
                androidAppId: "com.iyaffle.kural",
                iOSAppId: "585027354",
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.star),
                  Text(
                    'このアプリを評価する',
                    style: TextStyle(
                      fontSize: 16,
                      //decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: FlatButton(
              onPressed: share,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.share),
                  Text(
                    'このアプリを友達にすすめる',
                    style: TextStyle(
                      fontSize: 16,
                      //decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: SizedBox(
              width: 200.0,
              height: 100.0,
              child: Image(
                image: AssetImage('images/back.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
