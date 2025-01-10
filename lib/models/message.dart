import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class Message {
  final String senderID;
  final String senderEmail;
  final String message;
  final String reciverID;
  final Timestamp timestamp;

  Message({required this.senderID, required this.senderEmail, required this.message, required this.reciverID, required this.timestamp});
  
  //convert to a map
  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'senderEmail': senderEmail,
      'message': message,
      'reciverId': reciverID,
      'timestamp': timestamp
      };
      }

}