import 'dart:developer';

import 'package:auth_buttons/auth_buttons.dart';
import 'package:chatme/models/intprofile.dart';
import 'package:chatme/models/user.dart';
import 'package:chatme/screens/login&signup/forgetpass.dart';
import 'package:chatme/screens/login&signup/signup.dart';
import 'package:chatme/services.dart';
import 'package:chatme/widgets/custombtn.dart';
import 'package:chatme/widgets/custominput.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../constants.dart';
import '../mainpage.dart';

class LogIn extends StatelessWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController emailcontroller = TextEditingController();
    TextEditingController passwordcontroller = TextEditingController();
    UserCredential? credential;

    void LoggedIn(String mail, String pass) async {
      try {
        credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: mail, password: pass);
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Something went Wrong$e",
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

      if (credential! != null) {
        String uid = getCurrentUser();

        DocumentSnapshot docsnap =
            await FirebaseFirestore.instance.collection("users").doc(uid).get();
        UserModel usermodel =
            UserModel.fromMap(docsnap.data() as Map<String, dynamic>);

        IntrestProfile? intrestuser =
            await FirebaseHelper.getintrestModelById(usermodel);
        if (credential!.user!.uid == usermodel.uid) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => LandPage(
                    intprof: intrestuser!,
                    userModel: usermodel,
                    firebaseuser: credential!.user!)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Your Account is Blocked",
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
      String email = emailcontroller.text.trim();
      String password = passwordcontroller.text.trim();

      if (email == "" || password == "") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Enter Email and Password",
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
        LoggedIn(email, password);
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                "assets/images/chatmebig.png",
                width: 150,
                height: 150,
              ),
              Text(
                "Welcome User\nLogin to your account",
                textAlign: TextAlign.center,
                style: Constants.heading3,
              ),
              Column(
                children: [
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
                  CustomBtn(
                    text: "Login",
                    onpreased: () async {
                      checkvalues();
                      // email = emailcontroller.text;
                      // password = passwordcontroller.text;
                      // try {
                      //   bool shouldnavigate = await signIn(email, password);
                      //   if (shouldnavigate) {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => const LandPage()),
                      //     );
                      //   } else {
                      //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //       content: Text(
                      //         "Enter Correct Credentials",
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
                    outlinebtn: true,
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ForgetPassword()),
                  );
                },
                child: Text(
                  "Forget Password?",
                  style: Constants.heading1,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GoogleAuthButton(
                onPressed: () async {
                  IntrestProfile? intrpof;
                  User? fireuser = await signInWithGoogle();

                  UserModel? existuser =
                      await FirebaseHelper.getUserModelById(fireuser!.uid);
                  try {
                    intrpof =
                        await FirebaseHelper.getintrestModelById(existuser!);
                  } catch (e) {}

                  // ignore: unnecessary_null_comparison
                  if (existuser == null) {
                    // ignore: unnecessary_null_comparison
                    if (fireuser != null) {
                      UserModel newuser = UserModel(
                          uid: fireuser.uid,
                          fullname: fireuser.displayName!.toUpperCase(),
                          nickname: fireuser.displayName,
                          email: fireuser.email,
                          age: "",
                          cuntery: "",
                          gender: "",
                          status: "Offline",
                          reportedcount: 0,
                          intro: "",
                          prifilepic: fireuser.photoURL,
                          favoriteusers: {},
                          chatedides: {},
                          blockeduides: {});

                      IntrestProfile inpro = IntrestProfile(
                          icuntery: "", iagestart: "", iageend: "", gender: "");

                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(fireuser.uid)
                          .set(newuser.toMap())
                          .then(
                        (value) async {
                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(fireuser.uid)
                              .collection("intrest")
                              .doc(fireuser.uid)
                              .set(inpro.toMap())
                              .then((value) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LandPage(
                                      intprof: inpro,
                                      userModel: newuser,
                                      firebaseuser: fireuser)),
                            );
                          });
                        },
                      );
                    }
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LandPage(
                              intprof: intrpof!,
                              userModel: existuser,
                              firebaseuser: fireuser)),
                    );
                  }
                },
                darkMode: false,
                style: const AuthButtonStyle(
                  iconType: AuthIconType.secondary,
                ),
              ),
              CustomBtn(
                text: "Create New Account",
                onpreased: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUp()),
                  );
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
