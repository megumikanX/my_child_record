import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatelessWidget {

  LoginScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.child_care),
        title: const Text('うちの子語録'),
        backgroundColor: Colors.pinkAccent,
      ),
      body:
      Padding(
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
              child: Text('login'),
              onPressed: () async {
                try {
                  final user = await _auth.signInWithEmailAndPassword
                    (email: email, password: password);
                  if(user != null) {
                    print('login ok');
                    Navigator.of(context).pushNamed('/');
                  }
                }
                catch (e) {
                  print(e);
                }
              }
          )
        ],
      ),
    );
  }
}