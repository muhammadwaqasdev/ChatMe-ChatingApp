import 'package:chatme/constants.dart';
import 'package:chatme/models/chatroom.dart';
import 'package:chatme/models/user.dart';
import 'package:chatme/screens/chatroom.dart';
import 'package:chatme/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatedUserPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseuser;

  const ChatedUserPage(
      {Key? key, required this.userModel, required this.firebaseuser})
      : super(key: key);

  @override
  State<ChatedUserPage> createState() => _ChatedUserPageState();
}

class _ChatedUserPageState extends State<ChatedUserPage> {
  @override
  Widget build(BuildContext context) {
    Future<UserModel?> getfavusers() async {
      UserModel? currentusermod;
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userModel.uid)
          .get();

      if (snap.data() != null) {
        currentusermod = UserModel.fromMap(snap.data() as Map<String, dynamic>);
      }

      return currentusermod;
    }

    return Container(
        color: Constants.White,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("chatrooms")
              .orderBy("lastmessagetime", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                QuerySnapshot chatroomsnapshots =
                    snapshot.data as QuerySnapshot;

                return ListView.builder(
                    itemCount: chatroomsnapshots.docs.length,
                    itemBuilder: (context, index) {
                      ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                          chatroomsnapshots.docs[index].data()
                              as Map<String, dynamic>);

                      Map<String, dynamic> participents =
                          chatRoomModel.Partisipents!;
                      if (participents.containsValue(false)) {
                        print("OK");
                      } else {
                        List<String> partisipntskeys =
                            participents.keys.toList();
                        // ignore: unrelated_type_equality_checks
                        if (partisipntskeys.contains(widget.userModel.uid)) {
                          partisipntskeys.remove(widget.userModel.uid);

                          return FutureBuilder(
                            future: FirebaseHelper.getUserModelById(
                                partisipntskeys[0]),
                            builder: (context, userdata) {
                              if (userdata.hasError) {
                                print(userdata.error);
                              }
                              if (userdata.connectionState ==
                                  ConnectionState.done) {
                                UserModel? targetusernew =
                                    userdata.data as UserModel;

                                return InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ChatRoom(
                                          targetusermodel: targetusernew,
                                          chatroom: chatRoomModel,
                                          userModel: widget.userModel,
                                          firebaseuser: widget.firebaseuser);
                                    }));
                                  },
                                  child: Card(
                                    elevation: 3.0,
                                    color: Colors.grey[100],
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            targetusernew.prifilepic
                                                .toString()),
                                      ),
                                      title: Text(
                                        targetusernew.fullname.toString(),
                                        style: Constants.heading2,
                                      ),
                                      subtitle: Text(
                                        chatRoomModel.lastmessage.toString(),
                                        style: Constants.regular1,
                                      ),
                                      trailing: Column(
                                        children: [
                                          (targetusernew.status.toString() ==
                                                  "Online")
                                              ? Text(
                                                  targetusernew.status
                                                      .toString(),
                                                  style: Constants.regular1
                                                      .copyWith(
                                                          color: Colors.green),
                                                )
                                              : Text(
                                                  targetusernew.status
                                                      .toString(),
                                                  style: Constants.regular1
                                                      .copyWith(
                                                          color: Colors.red),
                                                ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          FutureBuilder(
                                              future: getfavusers(),
                                              builder: (context, snapuserdata) {
                                                if (snapuserdata.hasError) {
                                                  print(snapuserdata.error);
                                                }
                                                if (snapuserdata
                                                        .connectionState ==
                                                    ConnectionState.done) {
                                                  UserModel? favusernew =
                                                      snapuserdata.data
                                                          as UserModel;
                                                  Map<String, dynamic>?
                                                      favuids =
                                                      favusernew.favoriteusers;
                                                  List<String> favuidskeys =
                                                      favuids!.keys.toList();
                                                  if (favuidskeys.contains(
                                                      targetusernew.uid)) {
                                                    //if on Fav
                                                    return GestureDetector(
                                                      onTap: () {
                                                        un_favsuer(favusernew,
                                                            targetusernew);
                                                        setState(() {});
                                                      },
                                                      child: Icon(
                                                        FontAwesomeIcons
                                                            .solidHeart,
                                                        color:
                                                            Constants.Secandory,
                                                      ),
                                                    );
                                                  } else {
                                                    //if on Un-Fav
                                                    return GestureDetector(
                                                      onTap: () {
                                                        favsuer(favusernew,
                                                            targetusernew);
                                                        setState(() {});
                                                      },
                                                      child: Icon(
                                                        FontAwesomeIcons.heart,
                                                        color:
                                                            Constants.Primery,
                                                      ),
                                                    );
                                                  }
                                                }
                                                return CircularProgressIndicator();
                                              }),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            },
                          );
                        }
                      }
                      return Container();
                    });
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
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
        ));
  }
}
