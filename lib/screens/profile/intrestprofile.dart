import 'package:chatme/constants.dart';
import 'package:chatme/models/intprofile.dart';
import 'package:chatme/models/user.dart';
import 'package:chatme/services.dart';
import 'package:chatme/widgets/custombtn.dart';
import 'package:chatme/widgets/custominput.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// enum gendersenum { Male, Female, Other }

class InterestProfile extends StatefulWidget {
  final UserModel userModel;
  final User firebaseauthuser;

  const InterestProfile(
      {Key? key, required this.userModel, required this.firebaseauthuser})
      : super(key: key);

  @override
  State<InterestProfile> createState() => _InterestProfileState();
}

class _InterestProfileState extends State<InterestProfile> {
  // gendersenum? _character;
  TextEditingController gender = TextEditingController();
  TextEditingController Contery = TextEditingController();
  TextEditingController agestartfrom = TextEditingController();
  TextEditingController ageendfrom = TextEditingController();

  Future<bool> updateintprofile() async {
    IntrestProfile intproo = IntrestProfile(
      iageend: ageendfrom.text,
      iagestart: agestartfrom.text,
      icuntery: Contery.text.toUpperCase(),
      gender: gender.text.toUpperCase(),
    );
    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel.uid)
        .collection("intrest")
        .doc(widget.userModel.uid)
        .update(intproo.toMap())
        .then((value) {
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
            .collection("intrest")
            .doc(widget.userModel.uid)
            .snapshots(),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.active) {
            if (snapshots.hasData) {
              DocumentSnapshot userssnapshots =
                  snapshots.data as DocumentSnapshot;
              IntrestProfile interuserModel = IntrestProfile.fromMap(
                  userssnapshots.data() as Map<String, dynamic>);
              agestartfrom = TextEditingController(
                  text: interuserModel.iagestart.toString());
              ageendfrom = TextEditingController(
                  text: interuserModel.iageend.toString());
              Contery = TextEditingController(
                  text: interuserModel.icuntery.toString());
              gender =
                  TextEditingController(text: interuserModel.gender.toString());

              return Scaffold(
                resizeToAvoidBottomInset: false,
                body: SafeArea(
                    child: Column(
                  children: [
                    const SizedBox(
                      height: 50.0,
                    ),
                    Text(
                      "Update Intrest User",
                      textAlign: TextAlign.center,
                      style: Constants.heading3,
                    ),
                    custominput(
                      ontap: () {},
                      conto: gender,
                      hinttxt: "Please Enter Your Gender",
                      ispassword: false,
                      textV: "Gender",
                      icc: const Icon(FontAwesomeIcons.venusMars),
                    ),
                    custominput(
                      ontap: () {
                        // showCountryPicker(
                        //   context: context,
                        //   exclude: <String>['KN', 'MF'],
                        //   showPhoneCode: false,
                        //   onSelect: (Country country) {
                        //     Contery.clear();
                        //     Contery = TextEditingController(
                        //         text: country.displayName);
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
                        //           color:
                        //               const Color(0xFF8C98A8).withOpacity(0.2),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // );
                      },
                      conto: Contery,
                      hinttxt: "Please Select Countery",
                      ispassword: false,
                      textV: "Country",
                      icc: const Icon(FontAwesomeIcons.globeAsia),
                    ),
                    custominput(
                      ontap: () {},
                      conto: agestartfrom,
                      hinttxt: "Please Enter Start Age",
                      ispassword: false,
                      textV: "Stating Age",
                      icc: const Icon(FontAwesomeIcons.userAlt),
                    ),
                    custominput(
                      ontap: () {},
                      conto: ageendfrom,
                      hinttxt: "Please Enter End Age",
                      ispassword: false,
                      textV: "End Age",
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
                )),
              );
            } else if (snapshots.hasError) {}
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
