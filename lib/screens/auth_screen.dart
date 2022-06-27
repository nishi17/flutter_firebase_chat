
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  Future<void> _submitAuthFrom(String email, String userName, String password,
      bool isLogin,BuildContext context) async {
    UserCredential credential;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        credential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        setState(() {
          _isLoading = false;
        });
      } else {
        credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

       await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
          'userName':userName,
          'email':email,
        });
      }
      setState(() {
        _isLoading = false;
      });

    } on PlatformException catch (error) {
      String? message = 'An error occured! Please check credentials';

      if (error.message != null) {
        message = error.message;
      }

      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text(message!), backgroundColor: Theme
              .of(context)
              .errorColor,));
      setState(() {
        _isLoading = false;
      });
    }catch(err)
    {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .primaryColor,
      body: AuthForm(_submitAuthFrom,_isLoading),
    );
  }
}
