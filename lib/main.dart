import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebasechatapp/screens/auth_screen.dart';
import 'package:flutterfirebasechatapp/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterfirebasechatapp/screens/splash_screen.dart';

Future _connectToFirebaseEmulator() async {
  final localHostString = '192.168.1.195';

  FirebaseFirestore.instance.settings = Settings(
    host: '$localHostString:8080',
    sslEnabled: false,
    persistenceEnabled: false,
  );

  // await FirebaseStorage.instance
  //     .useStorageEmulator('http://$localHostString', 9199);

  //await FirebaseAuth.instance.useAuthEmulator('http://$localHostString', 9099);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //
  //   // FirebaseFirestore.instance.useFirestoreEmulator('localhost', 37976);
  await Firebase.initializeApp();
  // await _connectToFirebaseEmulator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatDemoFlutter',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        primaryColor: Colors.pink,
        backgroundColor: Colors.pink,
        accentColor: Colors.deepPurple,
        accentColorBrightness: Brightness.dark,
        buttonTheme: ButtonTheme.of(context).copyWith(
            buttonColor: Colors.pink,
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return SplashScreen();
            }

            if (userSnapshot.hasData) {
              return ChatScreen();
            } else {
              return AuthScreen();
            }
          }),
    );
  }
}
