import 'package:flutter/material.dart';

import '../constants.dart';

// ignore: camel_case_types
class custominput extends StatelessWidget {
  final String hinttxt;
  final bool ispassword;
  final String textV;
  final Icon icc;
  final TextEditingController conto;
  final Function ontap;

  const custominput({
    Key? key,
    required this.hinttxt,
    required this.ispassword,
    required this.textV,
    required this.icc,
    required this.conto,
    required this.ontap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formkey = GlobalKey<FormState>();
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 12.0,
      ),
      decoration: BoxDecoration(
        color: Constants.White,
      ),
      child: Form(
        key: formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              textV,
              style: Constants.heading1,
            ),
            TextFormField(
              onTap: () {
                ontap();
              },
              validator: (val) {
                return val!.isEmpty ? null : "Please Enter";
              },
              controller: conto,
              obscureText: ispassword,
              decoration: InputDecoration(
                  icon: icc,
                  border: InputBorder.none,
                  hintText: hinttxt,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 5.0,
                    vertical: 3.0,
                  )),
              style: Constants.regular2,
            ),
          ],
        ),
      ),
    );
  }
}

// class CustomInputForUpdate extends StatelessWidget {
//   final String hinttxt;
//   final bool ispassword;
//   final String textV;
//   final Icon icc;
//   final TextEditingController conto;

//   const CustomInputForUpdate(
//       {Key? key,
//       required this.hinttxt,
//       required this.ispassword,
//       required this.textV,
//       required this.icc,
//       required this.conto})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final formkey = GlobalKey<FormState>();
//     return Container(
//       margin: const EdgeInsets.symmetric(
//         horizontal: 24.0,
//         vertical: 12.0,
//       ),
//       decoration: BoxDecoration(
//         color: Constants.White,
//       ),
//       child: Form(
//         key: formkey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               textV,
//               style: Constants.heading1,
//             ),
//             TextFormField(
//               validator: (val) {
//                 return val!.isEmpty ? null : "Please Enter";
//               },
//               controller: conto,
//               obscureText: ispassword,
//               decoration: InputDecoration(
//                   icon: icc,
//                   border: InputBorder.none,
                  
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 5.0,
//                     vertical: 3.0,
//                   )),
//               style: Constants.regular2,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
