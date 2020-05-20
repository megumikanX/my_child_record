import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'main.dart';

class RegistrationScreen extends StatelessWidget {
  RegistrationScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //leading: Icon(Icons.child_care),
        title: const Text('新規登録'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: RegistrationForm(),
      ),
    );
  }
}

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;

  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: <Widget>[
          TextFormField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {
              email = value;
            },
            decoration: const InputDecoration(
              hintText: 'Email',
            ),
          ),
          TextFormField(
            textAlign: TextAlign.center,
            obscureText: true,
            onChanged: (value) {
              password = value;
            },
            decoration: const InputDecoration(
              hintText: 'Password',
            ),
          ),
          RaisedButton(
              child: Text('register'),
              onPressed: () async {
                try {
                  final newUser = await _auth.createUserWithEmailAndPassword(
                      email: email, password: password);

                  if (newUser != null) {
                    print('ok');
                    final loginUser = await _auth.currentUser();
                    final result = await _firestore
                        .collection('users')
                        .document(loginUser.uid)
                        .setData({
                      'name': ' ',
                      'createdAt': DateTime.now(),
                    });

                    //Navigator.of(context).pushNamed('/');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainPageWidget(),
                        ));
                  }
                } catch (e) {
                  print(e);
                }
              })
        ],
      ),
    );
  }
}
