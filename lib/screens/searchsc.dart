import 'package:chatme/constants.dart';
import 'package:chatme/main.dart';
import 'package:chatme/models/chatroom.dart';
import 'package:chatme/models/user.dart';
import 'package:chatme/screens/chatroom.dart';
import 'package:chatme/widgets/custominput.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services.dart';

class SearchScreen extends StatefulWidget {
  final UserModel userModel;
  final User firebaseuser;

  const SearchScreen(
      {Key? key, required this.userModel, required this.firebaseuser})
      : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchcontroller = TextEditingController();

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

      chatRoom = newChatroom;
    }

    return chatRoom;
  }

  List usersearchlist = [];

  // fetchdatabselist() async {
  //   usersearchlist.clear();
  //   //dynamic resultdata = await searchuser(searchcontroller.text) as List;

  //   await FirebaseFirestore.instance
  //       .collection("users")
  //       .where("fullname", isEqualTo: searchcontroller.text.toUpperCase())
  //       .get()
  //       .then(
  //         (querySnapshot) => {
  //           // ignore: avoid_function_literals_in_foreach_calls
  //           querySnapshot.docs.forEach(
  //             (element) {
  //               setState(() {
  //                 usersearchlist.add(element.data());
  //               });
  //             },
  //           ),
  //         },
  //       );
  // }

  Widget searchList() {
    // return StreamBuilder(
    //     stream: FirebaseFirestore.instance
    //         .collection("users")
    //         .where("fullname", isEqualTo: searchcontroller.text.toUpperCase())
    //         .snapshots(),
    //     builder: (context, snapshots) {
    //       if (snapshots.connectionState == ConnectionState.active) {
    //         if (snapshots.hasData) {
    //           QuerySnapshot datasnapshot = snapshots.data as QuerySnapshot;
    //           if (datasnapshot.docs.length > 0) {
    //             Map<String, dynamic> userMap =
    //                 datasnapshot.docs[0].data() as Map<String, dynamic>;

    //             UserModel SearchedUser = UserModel.fromMap(userMap);

    //             return Searchtile(
    //               name: SearchedUser.fullname.toString(),
    //               cuntry: "USA",
    //               imageurl: SearchedUser.prifilepic.toString(),
    //               ontap: () {
    //                 Navigator.push(
    //                     context,
    //                     MaterialPageRoute(
    //                         builder: (context) => ChatRoom(userid: "userid")));
    //               },
    //             );
    //           } else {
    //             return const Text("No Result Found");
    //           }
    //         } else if (snapshots.hasError) {
    //           return const Text("An Error Occured!");
    //         } else {
    //           return const Text("No Result Found");
    //         }
    //       } else {
    //         return const CircularProgressIndicator();
    //       }
    //     });
    //ignore: unnecessary_null_comparison
    // return ListView.builder(
    //     itemCount: usersearchlist.length,
    //     shrinkWrap: true,
    //     itemBuilder: (contaxt, index) {
    //       return Searchtile(
    //         name: usersearchlist[index]["fullname"],
    //         cuntry: usersearchlist[index]["cuntery"],
    //         imageurl: usersearchlist[index]["prifilepic"],
    //         ontap: () async {
    //           String cuid = usersearchlist[index]["uid"].toString();
    //           UserModel? serarchedusermodel =
    //               await FirebaseHelper.getUserModelById(cuid);
    //           ChatRoomModel? chatroomModel =
    //               await getChatroomModel(serarchedusermodel!);
    //           if (chatroomModel != null) {
    //             Navigator.pop(context);
    //             Navigator.push(
    //                 context,
    //                 MaterialPageRoute(
    //                     builder: (context) => ChatRoom(
    //                         targetusermodel: serarchedusermodel,
    //                         chatroom: chatroomModel,
    //                         userModel: widget.userModel,
    //                         firebaseuser: widget.firebaseuser)));
    //           } else {}
    //         },
    //       );
    //     });

    usersearchlist.clear();
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("users")
          .where("fullname", isEqualTo: searchcontroller.text.toUpperCase())
          .snapshots(),
      builder: (context, snapshots) {
        if (snapshots.connectionState == ConnectionState.active) {
          if (snapshots.hasData) {
            QuerySnapshot userssnapshots = snapshots.data as QuerySnapshot;

            return ListView.builder(
              itemCount: userssnapshots.docs.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                UserModel searcheduserModel = UserModel.fromMap(
                    userssnapshots.docs[index].data() as Map<String, dynamic>);
                // Future<bool> ismoveforword =
                //     getchatroommodel(widget.userModel, searcheduserModel);
                // if (ismoveforword == true) {
                if (searcheduserModel.uid != widget.firebaseuser.uid) {
                  return Card(
                    child: Searchtile(
                      name: searcheduserModel.fullname.toString(),
                      cuntry: searcheduserModel.cuntery.toString(),
                      imageurl: searcheduserModel.prifilepic.toString(),
                      ontap: () async {
                        ChatRoomModel? chatroomModel =
                            await getChatroomModel(searcheduserModel);
                        if (chatroomModel != null) {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatRoom(
                                      targetusermodel: searcheduserModel,
                                      chatroom: chatroomModel,
                                      userModel: widget.userModel,
                                      firebaseuser: widget.firebaseuser)));
                        } else {}
                      },
                    ),
                  );
                }
                // }

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

  @override
  void initState() {
    usersearchlist.clear();
    //fetchdatabselist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    String searchsen = "";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.Primery,
        centerTitle: true,
        title: const Text("Search User"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            children: [
              // ignore: avoid_unnecessary_containers
              Container(
                child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      controller: searchcontroller,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search...",
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 5.0,
                            vertical: 3.0,
                          )),
                      style: Constants.regular2,
                    )),
                    IconButton(
                        onPressed: () {
                          //fetchdatabselist();
                          setState(() {});
                        },
                        icon: const Icon(Icons.search)),
                  ],
                ),
              ),
              Divider(
                color: Constants.Black,
                thickness: 2.0,
              ),
              searchList(),
            ],
          ),
        ),
      ),
    );
  }
}

class Searchtile extends StatelessWidget {
  String name;
  String imageurl;
  String cuntry;
  Function ontap;
  Searchtile(
      {Key? key,
      required this.cuntry,
      required this.imageurl,
      required this.name,
      required this.ontap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return GestureDetector(
      onTap: () {
        ontap();
      },
      child: Container(
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
                        image: NetworkImage(imageurl),
                        height: 35,
                        width: 35,
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      name,
                      style: Constants.heading2,
                    ),
                  ],
                ),
                Text(
                  "(" + cuntry + ")",
                  style: Constants.regular1,
                )
              ],
            ),
            const Divider(
              thickness: 0.5,
            )
          ],
        ),
      ),
    );
  }
}
