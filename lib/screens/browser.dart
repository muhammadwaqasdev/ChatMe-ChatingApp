import 'package:chatme/constants.dart';
import 'package:chatme/main.dart';
import 'package:chatme/models/chatroom.dart';
import 'package:chatme/models/intprofile.dart';
import 'package:chatme/models/user.dart';
import 'package:chatme/screens/browseprovoider.dart';
import 'package:chatme/screens/chatroom.dart';
import 'package:chatme/services.dart';
import 'package:chatme/widgets/rendomuserpro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrowserRendom extends StatefulWidget {
  final UserModel userModel;
  final User firebaseuser;
  final IntrestProfile intprof;

  const BrowserRendom(
      {Key? key,
      required this.userModel,
      required this.firebaseuser,
      required this.intprof})
      : super(key: key);

  @override
  _BrowserRendomState createState() => _BrowserRendomState();
}

class _BrowserRendomState extends State<BrowserRendom> {
  Future<ChatRoomModel?> getChatroomModel(UserModel targetUser) async {
    ChatRoomModel? chatRoom;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("Partisipents.${widget.userModel.uid}", isEqualTo: true)
        .where("Partisipents.${targetUser.uid}", isEqualTo: true)
        .get();

    if (snapshot.docs.length > 0) {
      // Fetch the existing one
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatroom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);

      chatRoom = existingChatroom;
    } else {
      // Create a new one
      ChatRoomModel newChatroom = ChatRoomModel(
        Chatrromid: uuid.v1(),
        lastmessage: "",
        lastmessagetime: DateTime.now(),
        Partisipents: {
          widget.userModel.uid.toString(): true,
          targetUser.uid.toString(): true,
        },
      );

      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newChatroom.Chatrromid)
          .set(newChatroom.toMap());

      await FirebaseFirestore.instance
          .collection("users")
          .doc(targetUser.uid)
          .update({"chatedides.${widget.userModel.uid}": true}).whenComplete(
              () {
        setState(() {});
      });

      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userModel.uid)
          .update({"chatedides.${targetUser.uid}": true}).whenComplete(() {
        setState(() {});
      });

      chatRoom = newChatroom;
    }

    return chatRoom;
  }

  // Future<bool> asdsa(UserModel browseuserModel) async {
  //   bool ismoveforword =
  //       await FirebaseHelper.chatroomishave(widget.userModel, browseuserModel);
  //   if (ismoveforword == false) {
  //     return true;
  //   }
  //   return true;
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("users")
          // .where("gender", isEqualTo: widget.intprof.gender)
          // .where("cuntery", isEqualTo: widget.intprof.icuntery)
          .snapshots(),
      builder: (context, snapshots) {
        if (snapshots.connectionState == ConnectionState.active) {
          if (snapshots.hasData) {
            QuerySnapshot userssnapshots = snapshots.data as QuerySnapshot;

            return ListView.builder(
              itemCount: userssnapshots.docs.length,
              itemBuilder: (context, index) {
                UserModel browseuserModel = UserModel.fromMap(
                    userssnapshots.docs[index].data() as Map<String, dynamic>);

                // Future<bool> ismoveforword = FirebaseHelper.chatroomishave(
                //     widget.userModel, browseuserModel);
                // if (ismoveforword == false) {
                //   print("false");
                // } else if (ismoveforword == true) {
                //   print("true");
                // }

                if (widget.userModel.chatedides!
                    .containsKey(browseuserModel.uid)) {
                  print(browseuserModel.uid);
                } else {
                  if (browseuserModel.uid != widget.firebaseuser.uid) {
                    return Card(
                      child: RendomUserProfile(
                        conteryname: browseuserModel.cuntery.toString(),
                        name: browseuserModel.fullname.toString(),
                        nikname: browseuserModel.nickname.toString(),
                        introline: browseuserModel.intro.toString(),
                        userimage: browseuserModel.prifilepic.toString(),
                        hellotap: () async {
                          ChatRoomModel? chatroomModel =
                              await getChatroomModel(browseuserModel);
                          sayhyfaster(widget.userModel, chatroomModel!);
                        },
                        onusertap: () async {
                          ChatRoomModel? chatroomModel =
                              await getChatroomModel(browseuserModel);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatRoom(
                                    targetusermodel: browseuserModel,
                                    chatroom: chatroomModel!,
                                    userModel: widget.userModel,
                                    firebaseuser: widget.firebaseuser)),
                          );
                        },
                      ),
                    );
                  }

                  print("okay");
                }
                return Container();
              },
            );
          } else if (snapshots.hasError) {
            return Center(
              child: Text(snapshots.error.toString()),
            );
          } else {
            return const Center(
              child: Text("No Chats"),
            );
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
