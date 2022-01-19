import 'package:chatme/models/chatroom.dart';
import 'package:chatme/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Browser_Provoider with ChangeNotifier {
  List<ChatRoomModel> ischatroomcreted = [];

  void chatroomishave(UserModel cuser) async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("Partisipents.${cuser.uid}")
        .get();
    ChatRoomModel chatRoomModel = await ChatRoomModel.fromMap(
        snap.docs[0].data() as Map<String, dynamic>);
    if (chatRoomModel.Chatrromid != null) {
      ischatroomcreted.add(chatRoomModel);
    }
    notifyListeners();
  }
}
