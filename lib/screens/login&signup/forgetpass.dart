import 'package:chatme/constants.dart';
import 'package:chatme/screens/mainpage.dart';
import 'package:chatme/services.dart';
import 'package:chatme/widgets/custombtn.dart';
import 'package:chatme/widgets/custominput.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String email = "";

    final emailcontroller = TextEditingController();

    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          const SizedBox(
            height: 50.0,
          ),
          Text(
            "Forget Password",
            textAlign: TextAlign.center,
            style: Constants.heading3,
          ),
          custominput(
            ontap: () {},
            conto: emailcontroller,
            hinttxt: "Please Enter Email",
            ispassword: false,
            textV: " Email",
            icc: const Icon(FontAwesomeIcons.mailBulk),
          ),
          CustomBtn(
            text: "Login",
            onpreased: () async {
              email = emailcontroller.text;
              try {
                bool shouldnavigate = await resetPassword(email);
                if (shouldnavigate) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      "Check Your Email Box and Reset Password",
                      style:
                          Constants.regular2.copyWith(color: Constants.White),
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
              } catch (e) {
                //print(e);
              }
            },
            bgcolor: Constants.Primery,
            textcolor: Constants.White,
            outlinebtn: true,
          )
        ],
      )),
    );
  }
}
