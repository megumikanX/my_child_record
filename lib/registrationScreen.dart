import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatelessWidget {

  RegistrationScreen({Key key}) : super(key: key);

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
                  if(newUser != null) {
                    print('ok');

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