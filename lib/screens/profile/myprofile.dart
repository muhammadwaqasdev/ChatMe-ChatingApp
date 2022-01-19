import 'dart:io';

import 'package:chatme/constants.dart';
import 'package:chatme/main.dart';
import 'package:chatme/models/intprofile.dart';
import 'package:chatme/models/user.dart';
import 'package:chatme/widgets/custombtn.dart';
import 'package:chatme/widgets/custominput.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class MyProfileEdit extends StatefulWidget {
  final UserModel userModel;
  final User firebaseauthuser;

  const MyProfileEdit(
      {Key? key, required this.userModel, required this.firebaseauthuser})
      : super(key: key);

  @override
  State<MyProfileEdit> createState() => _MyProfileEditState();
}

class _MyProfileEditState extends State<MyProfileEdit> {
  TextEditingController fullname = TextEditingController();
  TextEditingController nickname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController intro = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController age = TextEditingController();
  File? imageFile;
  String? imageUrl;

  Future getImage() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uplodeImage();
      }
    });
  }

  Future uplodeImage() async {
    String filename = uuid.v1();
    int ststusval = 1;

    var uploadTask = await FirebaseStorage.instance
        .ref("profilepicture")
        .child(widget.userModel.uid.toString())
        .child("$filename.jpg")
        .putFile(imageFile!)
        .catchError((error) {
      ststusval = 0;
    });
    if (ststusval == 1) {
      imageUrl = await uploadTask.ref.getDownloadURL();
      FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userModel.uid)
          .update({
        "prifilepic": imageUrl,
      });
    }
  }

  Future<bool> updateintprofile() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel.uid)
        .update({
      "fullname": fullname.text.toUpperCase(),
      "nickname": nickname.text,
      "email": email.text,
      "age": age.text,
      "cuntery": country.text.toUpperCase(),
      "gender": gender.text.toUpperCase(),
      "intro": intro.text,
    }).then((value) {
      return true;
    });

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(widget.userModel.uid)
            .snapshots(),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.active) {
            if (snapshots.hasData) {
              DocumentSnapshot userssnapshots =
                  snapshots.data as DocumentSnapshot;
              UserModel upuserModel = UserModel.fromMap(
                  userssnapshots.data() as Map<String, dynamic>);
              fullname =
                  TextEditingController(text: upuserModel.fullname.toString());
              nickname =
                  TextEditingController(text: upuserModel.nickname.toString());
              email = TextEditingController(text: upuserModel.email.toString());
              gender =
                  TextEditingController(text: upuserModel.gender.toString());
              intro = TextEditingController(text: upuserModel.intro.toString());
              country =
                  TextEditingController(text: upuserModel.cuntery.toString());
              age = TextEditingController(text: upuserModel.age.toString());

              return Scaffold(
                resizeToAvoidBottomInset: false,
                body: SafeArea(
                    child: ListView(
                  padding: const EdgeInsets.all(8),
                  children: [
                    Column(
                      children: [
                        const SizedBox(
                          height: 50.0,
                        ),
                        Text(
                          "Update Profile Detail",
                          textAlign: TextAlign.center,
                          style: Constants.heading3,
                        ),
                        //Photo part
                        Container(
                          width: 150,
                          height: 150,
                          padding: const EdgeInsets.all(8),
                          //Image Part
                          child: CupertinoButton(
                            padding: const EdgeInsets.all(3),
                            onPressed: () {
                              getImage();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: NetworkImage(
                                        upuserModel.prifilepic.toString()),
                                    fit: BoxFit.contain,
                                    scale: 1.0),
                              ),
                            ),
                          ),
                        ),
                        // FullName
                        custominput(
                          ontap: () {},
                          conto: fullname,
                          hinttxt: "Please Enter Your Full Name",
                          ispassword: false,
                          textV: "Full Name",
                          icc: const Icon(FontAwesomeIcons.venusMars),
                        ),
                        custominput(
                          ontap: () {},
                          conto: nickname,
                          hinttxt: "Please Enter Your Nick Name",
                          ispassword: false,
                          textV: "Nick Name",
                          icc: const Icon(FontAwesomeIcons.venusMars),
                        ),
                        custominput(
                          ontap: () {},
                          conto: email,
                          hinttxt: "Please Enter Your Email",
                          ispassword: false,
                          textV: "Email",
                          icc: const Icon(FontAwesomeIcons.venusMars),
                        ),
                        custominput(
                          ontap: () {},
                          conto: intro,
                          hinttxt: "Please Enter Your Intro",
                          ispassword: false,
                          textV: "Intro",
                          icc: const Icon(FontAwesomeIcons.venusMars),
                        ),
                        // It's Country Picker Part after selected this all field empty and cant edit
                        custominput(
                          ontap: () {
                            // showCountryPicker(
                            //   context: context,
                            //   exclude: <String>['KN', 'MF'],
                            //   showPhoneCode: false,
                            //   onSelect: (Country countryv) {
                            //     country = TextEditingController(
                            //         text: countryv.displayName);
                            //     FirebaseFirestore.instance
                            //         .collection("users")
                            //         .doc(widget.userModel.uid)
                            //         .update({
                            //       "cuntery": country.text,
                            //     }).then((value) {
                            //       setState(() {});
                            //     });
                            //   },
                            //   // Optional. Sets the theme for the country list picker.
                            //   countryListTheme: CountryListThemeData(
                            //     // Optional. Sets the border radius for the bottomsheet.
                            //     borderRadius: const BorderRadius.only(
                            //       topLeft: Radius.circular(40.0),
                            //       topRight: Radius.circular(40.0),
                            //     ),
                            //     // Optional. Styles the search field.
                            //     inputDecoration: InputDecoration(
                            //       labelText: 'Search',
                            //       hintText: 'Start typing to search',
                            //       prefixIcon: const Icon(Icons.search),
                            //       border: OutlineInputBorder(
                            //         borderSide: BorderSide(
                            //           color: const Color(0xFF8C98A8)
                            //               .withOpacity(0.2),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // );
                          },
                          conto: country,
                          hinttxt: "Please Enter Your Country",
                          ispassword: false,
                          textV: "Country",
                          icc: const Icon(FontAwesomeIcons.globeAsia),
                        ),
                        custominput(
                          ontap: () {},
                          conto: gender,
                          hinttxt: "Please Enter Your Gender",
                          ispassword: false,
                          textV: "Gender",
                          icc: const Icon(FontAwesomeIcons.userAlt),
                        ),
                        custominput(
                          ontap: () {},
                          conto: age,
                          hinttxt: "Please Enter Your Age",
                          ispassword: false,
                          textV: "Age",
                          icc: const Icon(FontAwesomeIcons.userAlt),
                        ),
                        CustomBtn(
                          text: "Update",
                          onpreased: () async {
                            bool isupdate = await updateintprofile();
                            if (isupdate == true) {
                              setState(() {});
                            } else {
                              setState(() {});
                            }
                          },
                          bgcolor: Constants.Primery,
                          textcolor: Constants.White,
                          outlinebtn: true,
                        )
                      ],
                    ),
                  ],
                )),
              );
            } else if (snapshots.hasError) {}
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
