import 'package:chatme/models/chatroom.dart';
import 'package:chatme/models/user.dart';
import 'package:chatme/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants.dart';

class BlockedUserlist extends StatefulWidget {
  final UserModel userModel;
  final User firebaseuser;

  const BlockedUserlist(
      {Key? key, required this.userModel, required this.firebaseuser})
      : super(key: key);

  @override
  State<BlockedUserlist> createState() => _BlockedUserlistState();
}

class _BlockedUserlistState extends State<BlockedUserlist> {
  // List<dynamic> usersearchlist = [];
  // List<String> userids = [];
  // List blockeduserdata = [];

  // fetchdatabselist() async {
  //   //dynamic resultdata = await searchuser(searchcontroller.text) as List;

  //   await FirebaseFirestore.instance
  //       .collection("user")
  //       .where("id", isEqualTo: getCurrentUser())
  //       .get()
  //       .then(
  //         (querySnapshot) => {
  //           // ignore: avoid_function_literals_in_foreach_calls
  //           querySnapshot.docs.forEach(
  //             (element) {
  //               setState(() {
  //                 usersearchlist = element.data()['Favusers'];
  //               });
  //             },
  //           ),
  //         },
  //       );
  // }

  Widget searchList() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("chatrooms").snapshots(),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.active) {
            if (snapshots.hasData) {
              QuerySnapshot chatroomsnapshots = snapshots.data as QuerySnapshot;
              return ListView.builder(
                  itemCount: chatroomsnapshots.docs.length,
                  itemBuilder: (context, index) {
                    ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                        chatroomsnapshots.docs[index].data()
                            as Map<String, dynamic>);

                    Map<String, dynamic> participents =
                        chatRoomModel.Partisipents!;
                    if (participents.containsValue(false)) {
                      List<String> partisipntskeys = participents.keys.toList();
                      if (partisipntskeys.contains(widget.userModel.uid)) {
                        partisipntskeys.remove(widget.userModel.uid);
                        return ListView.builder(
                            itemCount: partisipntskeys.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index2) {
                              return StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(partisipntskeys[index2])
                                      .snapshots(),
                                  builder: (context, snap) {
                                    if (snap.data != null) {
                                      DocumentSnapshot ssnapshots =
                                          snap.data! as DocumentSnapshot;
                                      UserModel blockedusernew =
                                          UserModel.fromMap(ssnapshots.data()
                                              as Map<String, dynamic>);
                                      return Searchtile(
                                        name:
                                            blockedusernew.fullname.toString(),
                                        imageurl: blockedusernew.prifilepic
                                            .toString(),
                                        ontrash: () async {
                                          await unblockuser(widget.userModel,
                                              blockedusernew, chatRoomModel);
                                          setState(() {});
                                        },
                                      );
                                    }

                                    return Container();
                                  });
                            });
                      }
                    }
                    return Container();
                  });
            } else if (snapshots.hasError) {
              return Container();
            }
          }
          return Container();
        });
  }

  @override
  void initState() {
    // usersearchlist.clear();
    // userids.clear();
    // blockeduserdata.clear();
    // fetchdatabselist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.Primery,
        centerTitle: true,
        title: const Text("Blocked User"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: searchList(),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Searchtile extends StatefulWidget {
  String name;
  String imageurl;
  Function ontrash;
  Searchtile(
      {Key? key,
      required this.ontrash,
      required this.imageurl,
      required this.name})
      : super(key: key);

  @override
  State<Searchtile> createState() => _SearchtileState();
}

class _SearchtileState extends State<Searchtile> {
  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Constants.Primery,
                    child: Image(
                      image: NetworkImage(widget.imageurl),
                      height: 35,
                      width: 35,
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    widget.name,
                    style: Constants.heading2,
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(FontAwesomeIcons.trash),
                onPressed: () {
                  widget.ontrash();
                },
              )
            ],
          ),
          const Divider(
            thickness: 0.5,
          )
        ],
      ),
    );
  }
}
