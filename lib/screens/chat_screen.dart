import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterfirebasechatapp/chat/new_messge.dart';

import '../chat/messages.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FlutterChat'),
        actions: [
          DropdownButton(
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: [
                      Icon(
                        Icons.exit_to_app,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Logout'),
                    ],
                  ),
                ),
                value: 'logout',
              )
            ],
            onChanged: (identifier) {
              if (identifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
          )
        ],
      ),
      body: Container(
        child: Column(children: [
          Expanded(child: Messages(),
          ),
          NewMessage(),
        ]),
      ) /*StreamBuilder<QuerySnapshot>(
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data?.docs;

          return ListView.builder(
              itemBuilder: (ctx, index) => Container(
                    child: Text(data![index]['text']),
                  ),
              itemCount: data?.length);
        },
        stream: FirebaseFirestore.instance
            .collection('chats/1WzhfagVPgzX6O7GBd4Q/messages')
            .snapshots(),
      )*/
      ,
     /* floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            FirebaseFirestore.instance
                .collection('chats/1WzhfagVPgzX6O7GBd4Q/messages')
                .add({'text': 'This click'});
          }),*/
    );
  }
}
