import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enterdMessage = '';
  final _controller = new TextEditingController();

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    await FirebaseFirestore.instance.collection('chat').add({
      'text': _enterdMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'userName': userData['userName'],
      'userImage':userData['image_url']
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(children: [
        Expanded(
            child: TextField(
              autocorrect: true,
              textCapitalization: TextCapitalization.sentences,
              enableSuggestions: true,
          controller: _controller,
          decoration: InputDecoration(labelText: 'Send a message..'),
          onChanged: (value) {
            setState(() {
              _enterdMessage = value;
            });
          },
        )),
        SizedBox(
          width: 8,
        ),
        IconButton(
          onPressed: _enterdMessage.trim().isEmpty ? null : _sendMessage,
          icon: Icon(Icons.send),
          color: Theme.of(context).primaryColor,
        )
      ]),
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(10),
    );
  }
}
