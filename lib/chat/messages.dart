import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebasechatapp/chat/message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: Future.value(FirebaseAuth.instance.currentUser),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return StreamBuilder<QuerySnapshot>(
          builder: (ctx, chatSnapshot) {
            if (chatSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            final chatDoc = chatSnapshot.data?.docs;

            return ListView.builder(
              reverse: true,
              itemBuilder: (ctx, index) => MessageBubble(
                  chatDoc![index]['text'],
                  chatDoc[index]['userId'] == futureSnapshot.data?.uid
                      ? true
                      : false,
                  /*chatDoc[index]['userId']*/chatDoc[index]['userName'],
                  chatDoc[index]['userImage'],
                  key: ValueKey(chatDoc[index].id)),
              itemCount: chatDoc?.length,
            );
          },
          stream: FirebaseFirestore.instance
              .collection('chat')
              .orderBy('createdAt', descending: true)
              .snapshots(),
        );
      },
    );
  }
}
