import 'package:chatme/constants.dart';
import 'package:chatme/models/user.dart';
import 'package:chatme/screens/profile/blockedusers.dart';
import 'package:chatme/screens/profile/favusers.dart';
import 'package:chatme/screens/profile/intrestprofile.dart';
import 'package:chatme/screens/profile/myprofile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services.dart';
import '../login&signup/login.dart';

class ProfilePage extends StatefulWidget {
  final UserModel userModle;
  final User firebaseuser;

  const ProfilePage(
      {Key? key, required this.userModle, required this.firebaseuser})
      : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // fetchdatabselist() async {
  //   //dynamic resultdata = await searchuser(searchcontroller.text) as List;

  //   DocumentSnapshot<Map<String, dynamic>> docsnap = await FirebaseFirestore
  //       .instance
  //       .collection("users")
  //       .doc(widget.firebaseuser.uid)
  //       .get();

  //   UserModel currentuser =
  //       UserModel.fromMap(docsnap.data() as Map<String, dynamic>);

  //   name = currentuser.fullname.toString();
  //   nname = currentuser.nickname.toString();
  //   tagline = currentuser.intro.toString();
  //   imageuu = currentuser.prifilepic.toString();
  // }

  @override
  void initState() {
    //fetchdatabselist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(widget.firebaseuser.uid)
            .snapshots(),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.active) {
            if (snapshots.hasData) {
              DocumentSnapshot userssnapshots =
                  snapshots.data as DocumentSnapshot;

              UserModel userModel = UserModel.fromMap(
                  userssnapshots.data() as Map<String, dynamic>);
              return Scaffold(
                body: SafeArea(
                  child: Tvs(
                    name: userModel.fullname.toString(),
                    nname: userModel.nickname.toString(),
                    tagline: userModel.intro.toString(),
                    imgurl: userModel.prifilepic.toString(),
                    userModel: widget.userModle,
                    firebaseuser: widget.firebaseuser,
                  ),
                ),
              );
            } else if (snapshots.hasError) {
              print("Error in Profile");
            }
          }
          return CircularProgressIndicator();
        });
  }
}

class Tvs extends StatelessWidget {
  String name;
  String nname;
  String tagline;
  String imgurl;
  final UserModel userModel;
  final User firebaseuser;
  Tvs(
      {Key? key,
      required this.name,
      required this.nname,
      required this.tagline,
      required this.imgurl,
      required this.firebaseuser,
      required this.userModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.White,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: <Widget>[
                AvatarImage(
                  imageurl: imgurl,
                ),
                Text(name,
                    style:
                        Constants.heading2.copyWith(color: Constants.Primery)),
                Text(nname,
                    style: Constants.regular2
                        .copyWith(color: Constants.Secandorylight)),
                const SizedBox(height: 15),
                Text(tagline,
                    textAlign: TextAlign.center,
                    style:
                        Constants.heading1.copyWith(color: Constants.Primery)),
                ProfileListItems(
                    userModel: userModel, firebaseuser: firebaseuser),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class AvatarImage extends StatefulWidget {
  String imageurl;
  AvatarImage({Key? key, required this.imageurl}) : super(key: key);

  @override
  State<AvatarImage> createState() => _AvatarImageState();
}

class _AvatarImageState extends State<AvatarImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      padding: const EdgeInsets.all(8),
      child: Container(
        padding: const EdgeInsets.all(3),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: NetworkImage(widget.imageurl),
                fit: BoxFit.contain,
                scale: 1.0),
          ),
        ),
      ),
    );
  }
}

class Listt extends StatelessWidget {
  final String name;
  final Function onclick;

  const Listt({Key? key, required this.name, required this.onclick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onclick();
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 50.0),
        elevation: 10,
        color: Colors.grey[100],
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name,
                  style: Constants.heading2.copyWith(color: Constants.Primery)),
              const Icon(FontAwesomeIcons.angleRight),
            ],
          ),
        ),
      ),
    );
    //Center(
    //  child: GestureDetector(
    //    onTap: onclick(),
    // /   child: Container(
    //      child: Row(
    //        children: [
    //          Icon(icon.icon),
    //          Text(
    //            name,
    //            style: Constants.heading2,
    //          ),
    //        ],
    //      ),
    //    ),
    //  ),
    //);
  }
}

class ProfileListItems extends StatelessWidget {
  final UserModel userModel;
  final User firebaseuser;

  const ProfileListItems(
      {Key? key, required this.userModel, required this.firebaseuser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20.0,
              ),
              Listt(
                  name: "My Profile",
                  onclick: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyProfileEdit(
                              userModel: userModel,
                              firebaseauthuser: firebaseuser)),
                    );
                  }),
              const SizedBox(
                height: 20.0,
              ),
              Listt(
                  name: "Interst Profile",
                  onclick: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InterestProfile(
                              userModel: userModel,
                              firebaseauthuser: firebaseuser)),
                    );
                  }),
              // const SizedBox(
              //   height: 20.0,
              // ),
              // Listt(
              //     name: "Faviriote Users",
              //     icon: const Icon(FontAwesomeIcons.doorOpen),
              //     onclick: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => const FavUserlist()),
              //       );
              //     }),
              const SizedBox(
                height: 20.0,
              ),
              Listt(
                  name: "Blocked Users",
                  onclick: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BlockedUserlist(
                              userModel: userModel,
                              firebaseuser: firebaseuser)),
                    );
                  }),
              const SizedBox(
                height: 20.0,
              ),
              Listt(
                  name: "Logout",
                  onclick: () async {
                    try {
                      bool shouldnavigate = await logOut();
                      if (shouldnavigate) {
                        Navigator.popUntil(context, (route) => route.isFirst);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LogIn()),
                        );
                      }
                    } catch (e) {
                      // TODO: Connection Error
                    }
                  }),
            ],
          ),
          Positioned(
            bottom: 0,
            child: Center(
                child: GestureDetector(
              child: RichText(
                text: TextSpan(
                  text: 'Powered By ',
                  style: DefaultTextStyle.of(context).style,
                  children: const <TextSpan>[
                    TextSpan(
                        text: 'Perallel Soul',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue)),
                  ],
                ),
              ),
              onTap: () async {
                String _url = 'http://www.parallelsouls.com/';
                if (await canLaunch(_url)) {
                  launch(_url);
                }
              },
            )),
          ),
        ],
      ),
    );
  }
}
