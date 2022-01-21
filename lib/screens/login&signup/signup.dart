import 'package:chatme/models/intprofile.dart';
import 'package:chatme/models/user.dart';
import 'package:chatme/screens/login&signup/login.dart';
import 'package:chatme/widgets/custombtn.dart';
import 'package:chatme/widgets/custominput.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants.dart';
import '../../services.dart';
import '../mainpage.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String fullname = "";
  String nickname = "";
  String email = "";
  String password = "";
  String repassword = "";

  TextEditingController fnamecontroller = TextEditingController();
  TextEditingController niknamecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController repasswordcontroller = TextEditingController();

  void signUp(
      String email, String password, String fullname, String nickname) async {
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          e.code.toString(),
          style: Constants.regular2.copyWith(color: Constants.White),
        ),
        duration: const Duration(milliseconds: 5000),
        backgroundColor: Constants.Primery,
        elevation: 10.0,
        padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 15.0 // Inner padding for SnackBar content.
            ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ));
    }

    if (credential != null) {
      String uid = getCurrentUser();

      // UserModel newuser = UserModel(
      //     uid: uid,
      //     fullname: fullname.toUpperCase(),
      //     email: email,
      //     prifilepic: ""
      //     );
      UserModel newuser = UserModel(
          uid: uid,
          fullname: fullname.toUpperCase(),
          nickname: nickname,
          email: email,
          age: "",
          cuntery: "",
          gender: "",
          status: "",
          reportedcount: 0,
          intro: "",
          prifilepic:
              "https://firebasestorage.googleapis.com/v0/b/chatme-33432.appspot.com/o/chatmebig.png?alt=media&token=ac6a2a91-c9ad-43da-8fab-6ea941d8d500",
          favoriteusers: {},
          chatedides: {});
      IntrestProfile inpro =
          IntrestProfile(icuntery: "", iagestart: "", iageend: "", gender: "");

      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(newuser.toMap())
          .then((value) async {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .collection("intrest")
            .doc(uid)
            .set(inpro.toMap())
            .then((value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => LandPage(
                    intprof: inpro,
                    userModel: newuser,
                    firebaseuser: credential!.user!)),
          );
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Enter Correct Credentials",
          style: Constants.regular2.copyWith(color: Constants.White),
        ),
        duration: const Duration(milliseconds: 5000),
        backgroundColor: Constants.Primery,
        elevation: 10.0,
        padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 15.0 // Inner padding for SnackBar content.
            ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ));
    }
  }

  void checkvalues() {
    fullname = fnamecontroller.text.trim();
    nickname = niknamecontroller.text.trim();
    email = emailcontroller.text.trim();
    password = passwordcontroller.text.trim();
    repassword = repasswordcontroller.text.trim();

    if (fullname == "" ||
        nickname == "" ||
        email == "" ||
        password == "" ||
        repassword == "") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Enter Complete Detail",
          style: Constants.regular2.copyWith(color: Constants.White),
        ),
        duration: const Duration(milliseconds: 5000),
        backgroundColor: Constants.Primery,
        elevation: 10.0,
        padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 15.0 // Inner padding for SnackBar content.
            ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ));
    } else if (password != repassword) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "You Password Does Not Match",
          style: Constants.regular2.copyWith(color: Constants.White),
        ),
        duration: const Duration(milliseconds: 5000),
        backgroundColor: Constants.Primery,
        elevation: 10.0,
        padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 15.0 // Inner padding for SnackBar content.
            ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ));
    } else {
      signUp(email, password, fullname, nickname);
    }
  }

  @override
  void dispose() {
    super.dispose();
    fnamecontroller.dispose();
    niknamecontroller.dispose();
    emailcontroller.dispose();
    passwordcontroller.dispose();
    repasswordcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Create New Account",
                textAlign: TextAlign.center,
                style: Constants.heading3,
              ),
              Column(
                children: [
                  custominput(
                    ontap: () {},
                    conto: fnamecontroller,
                    hinttxt: "Please Enter Full Name",
                    ispassword: false,
                    textV: " Full Name",
                    icc: const Icon(FontAwesomeIcons.user),
                  ),
                  custominput(
                    ontap: () {},
                    conto: niknamecontroller,
                    hinttxt: "Please Enter Nick Name",
                    ispassword: false,
                    textV: " Nick Name",
                    icc: const Icon(FontAwesomeIcons.user),
                  ),
                  custominput(
                    ontap: () {},
                    conto: emailcontroller,
                    hinttxt: "Please Enter Email",
                    ispassword: false,
                    textV: " Email",
                    icc: const Icon(FontAwesomeIcons.mailBulk),
                  ),
                  custominput(
                    ontap: () {},
                    conto: passwordcontroller,
                    hinttxt: "Please Enter Password",
                    ispassword: true,
                    textV: " Password",
                    icc: const Icon(FontAwesomeIcons.lock),
                  ),
                  custominput(
                    ontap: () {},
                    conto: repasswordcontroller,
                    hinttxt: "Please Enter Re-Password",
                    ispassword: true,
                    textV: " Re-Password",
                    icc: const Icon(FontAwesomeIcons.lock),
                  ),
                  CustomBtn(
                    text: "Sign Up",
                    onpreased: () async {
                      checkvalues();
                      // fullname = fnamecontroller.text;
                      // nickname = niknamecontroller.text;
                      // email = emailcontroller.text;
                      // password = passwordcontroller.text;
                      // repassword = repasswordcontroller.text;

                      // isempt();
                      // isformat();

                      // try {
                      //   if (validdd) {
                      //     bool shouldnavigate = await signUp(email, password);
                      //     String usid = getCurrentUser();
                      //     if (shouldnavigate) {
                      //       // ignore: non_constant_identifier_names
                      //       bool AddedFullInfo = await adduserinfo(
                      //           usid, fullname, nickname, email, password);
                      //       if (AddedFullInfo) {
                      //         // Navigator.pushReplacement(
                      //         //   context,
                      //         //   MaterialPageRoute(
                      //         //       builder: (context) => const LandPage()),
                      //         // );
                      //       }
                      //     } else {
                      //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //         content: Text(
                      //           "Your Email Already Exist",
                      //           style: Constants.regular2
                      //               .copyWith(color: Constants.White),
                      //         ),
                      //         duration: const Duration(milliseconds: 5000),
                      //         backgroundColor: Constants.Primery,
                      //         elevation: 10.0,
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: 8.0,
                      //             vertical:
                      //                 15.0 // Inner padding for SnackBar content.
                      //             ),
                      //         behavior: SnackBarBehavior.floating,
                      //         shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(10.0),
                      //         ),
                      //       ));
                      //     }
                      //   } else {
                      //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //       content: Text(
                      //         "Please Enter Proper Data",
                      //         style: Constants.regular2
                      //             .copyWith(color: Constants.White),
                      //       ),
                      //       duration: const Duration(milliseconds: 5000),
                      //       backgroundColor: Constants.Primery,
                      //       elevation: 10.0,
                      //       padding: const EdgeInsets.symmetric(
                      //           horizontal: 8.0,
                      //           vertical:
                      //               15.0 // Inner padding for SnackBar content.
                      //           ),
                      //       behavior: SnackBarBehavior.floating,
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(10.0),
                      //       ),
                      //     ));
                      //   }
                      // } catch (e) {
                      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //     content: Text(
                      //       "Something went Wrong$e",
                      //       style: Constants.regular2
                      //           .copyWith(color: Constants.White),
                      //     ),
                      //     duration: const Duration(milliseconds: 5000),
                      //     backgroundColor: Constants.Primery,
                      //     elevation: 10.0,
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: 8.0,
                      //         vertical:
                      //             15.0 // Inner padding for SnackBar content.
                      //         ),
                      //     behavior: SnackBarBehavior.floating,
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(10.0),
                      //     ),
                      //   ));
                      // }
                    },
                    bgcolor: Constants.Primery,
                    textcolor: Constants.White,
                    outlinebtn: false,
                  ),
                ],
              ),
              CustomBtn(
                text: "Back To Login",
                onpreased: () {
                  setState(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LogIn()),
                    );
                  });
                },
                bgcolor: Constants.Secandory,
                textcolor: Constants.White,
                outlinebtn: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
