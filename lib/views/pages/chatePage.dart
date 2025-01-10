import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hire_harmony/services/auth_services.dart';
import 'package:hire_harmony/services/chat/chat_services.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class Chatepage extends StatelessWidget {
  final String reciverEmail;
  final String reciverID;
  final ChatServices _chatServices = ChatServices();
  final AuthServices _authServices = AuthServicesImpl();
  final TextEditingController _messageController = TextEditingController();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      //send the message
      await _chatServices.sendMessages(
        reciverID,
        _messageController.text,
      );
      _messageController.clear();
    }
  }

  Chatepage({super.key, required this.reciverEmail, required this.reciverID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(reciverEmail),
        ),
        body: Column(
          children: [
            //display all messages
            Expanded(
              child: _buildMessageList(),
            ),

            //userinput
            _buildUserInput(),
          ],
        ));
  }

  //buildMessageList
  Widget _buildMessageList() {
    final senderID = _authServices.getCurrentUser()!.uid;

    return StreamBuilder(
      stream:  _chatServices.getMessage(senderID,reciverID),
      builder: (context, snapshot) {
  if (snapshot.hasError) {
    return const Text("ERROR");
  }
  if (snapshot.connectionState == ConnectionState.waiting) {
    return const Text("Loading ...");
  }
  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
    return const Text("No messages yet.");
  }
  
  // طباعة البيانات للتأكد
  print(snapshot.data!.docs);
  
  return ListView(
    children: snapshot.data!.docs.map((doc) => _buildMessageitem(doc)).toList(),
  );
}

    );
  }

  Widget _buildMessageitem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser= data['senderID'] == _authServices.getCurrentUser()!.uid;
    var alignment = isCurrentUser ? Alignment.centerLeft : Alignment.centerRight;

    return Container(
      alignment: alignment,
      child: Column(
        mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Text(data["message"]),
        ],
      )
      );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(children: [
        Expanded(
            child: TextField(
          controller: _messageController,
          decoration: const InputDecoration(hintText: "Type a message"),
        )),
        Container(
          margin: const EdgeInsets.only(left: 25.0),
          decoration: BoxDecoration(color: AppColors().orange,
          shape: BoxShape.circle,
          ),

          child: IconButton(
            icon: Icon(Icons.send, color: AppColors().white,),
            onPressed: () {
              sendMessage();
            },
          ),
        ),
      ]),
    );
  }
}
