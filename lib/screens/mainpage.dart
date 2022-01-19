import 'package:chatme/constants.dart';
import 'package:chatme/models/chatroom.dart';
import 'package:chatme/models/intprofile.dart';
import 'package:chatme/models/user.dart';
import 'package:chatme/screens/browser.dart';
import 'package:chatme/screens/chateduser.dart';
import 'package:chatme/screens/login&signup/login.dart';
import 'package:chatme/screens/profile/profilepage.dart';
import 'package:chatme/screens/searchsc.dart';
import 'package:chatme/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LandPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseuser;
  final IntrestProfile intprof;

  const LandPage(
      {Key? key,
      required this.userModel,
      required this.firebaseuser,
      required this.intprof})
      : super(key: key);

  @override
  _LandPageState createState() => _LandPageState();
}

class _LandPageState extends State<LandPage> with WidgetsBindingObserver {
  List<ChatRoomModel> Chatroomss = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    setStatus("Online");
  }

  void setStatus(String status) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel.uid)
        .update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //online
      setStatus("Online");
    } else {
      //offline
      setStatus("Offline");
    }
  }

  // void abcdefg(){
  //     // StreamBuilder(stream: FirebaseFirestore.instance
  //     // .collection("chatrooms")
  //     // .where("Partisipents.${widget.userModel.uid}")
  //     // .snapshots(),
  //     // builder: (context, snap){
  //     //   if (snap.connectionState == ConnectionState.active) {
  //     //     if (snap.hasData) {
  //     //           QuerySnapshot userssnapshots = snap.data as QuerySnapshot;

  //     //           for (var i = 0; i < userssnapshots.docs.length; i++) {
  //     //             Chatroomss.add(userssnapshots.docs![i]);
  //     //           }

  //     //     }}

  //     // },);

  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.Primery,
          title: const Text("Chat Me"),
          leading: Image.asset(
            "assets/images/chatmebig.png",
          ),
          actions: [
            IconButton(
              onPressed: () async {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return SearchScreen(
                          userModel: widget.userModel,
                          firebaseuser: widget.firebaseuser);
                    }),
                  );
                });
              },
              icon: const Icon(
                Icons.search_outlined,
              ),
            ),
          ],
          elevation: 20.0,
          bottom: const TabBar(
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              tabs: [
                Tab(
                  icon: Icon(FontAwesomeIcons.users),
                  text: "Browser",
                ),
                Tab(
                  icon: Icon(FontAwesomeIcons.comment),
                  text: "Chat",
                ),
                Tab(
                  icon: Icon(FontAwesomeIcons.user),
                  text: "My Profile",
                ),
              ]),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: TabBarView(
            children: [
              Center(
                  child: BrowserRendom(
                      intprof: widget.intprof,
                      userModel: widget.userModel,
                      firebaseuser: widget.firebaseuser)),
              // const Center(child: Text("Rendom used Page")),
              //-------------------------------------//
              Center(
                  child: ChatedUserPage(
                      userModel: widget.userModel,
                      firebaseuser: widget.firebaseuser)),
              //-------------------------------------//
              Center(
                  child: ProfilePage(
                      userModle: widget.userModel,
                      firebaseuser: widget.firebaseuser)),
            ],
          ),
        ),
      ),
    );
  }
}
