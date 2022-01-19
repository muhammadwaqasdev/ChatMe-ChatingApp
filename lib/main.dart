import 'package:chatme/constants.dart';
import 'package:chatme/models/intprofile.dart';
import 'package:chatme/models/user.dart';
import 'package:chatme/screens/chatroom.dart';
import 'package:chatme/screens/login&signup/login.dart';
import 'package:chatme/screens/mainpage.dart';
import 'package:chatme/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  User? currentuser = FirebaseAuth.instance.currentUser;

  if (currentuser != null) {
    //logged IN
    UserModel? currentusermodel =
        await FirebaseHelper.getUserModelById(currentuser.uid);

    if (currentusermodel != null) {
      IntrestProfile? intrestuser =
          await FirebaseHelper.getintrestModelById(currentusermodel);
      runApp(MyAppLoggedIn(
          intproff: intrestuser!,
          userModel: currentusermodel,
          firebaseuser: currentuser));
    } else {
      runApp(const MyApp());
    }
  } else {
    runApp(const MyApp());
    //Not Logged In
  }
}

//if Logged In Then Run This
class MyAppLoggedIn extends StatelessWidget {
  final UserModel userModel;
  final User firebaseuser;
  final IntrestProfile intproff;

  const MyAppLoggedIn(
      {Key? key,
      required this.userModel,
      required this.firebaseuser,
      required this.intproff})
      : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Me?',
      home: LandPage(
          intprof: intproff, userModel: userModel, firebaseuser: firebaseuser),
      debugShowCheckedModeBanner: false,
    );
  }
}

//if Not Logged In Then Run This
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Chat Me?',
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Image.asset(
        "assets/images/chatmebig.png",
        height: 800,
        width: 800,
      ),
      splashIconSize: 150.0,
      duration: 3000,
      splashTransition: SplashTransition.scaleTransition,
      backgroundColor: Constants.Secandorylight,
      nextScreen: const LogIn(),
    );
  }
}

// class OnBoardScreens extends StatefulWidget {
//   const OnBoardScreens({Key? key}) : super(key: key);

//   @override
//   _OnBoardScreensState createState() => _OnBoardScreensState();
// }

// class _OnBoardScreensState extends State<OnBoardScreens> {
//   List<PageViewModel> getpages() {
//     return [
//       PageViewModel(
//         title: "Fractional shares",
//         body:
//             "Instead of having to buy an entire share, invest any amount you want.",
//         image: Image.network(
//             "https://www.gstatic.com/images/branding/product/2x/photos_96dp.png"),
//       ),
//       PageViewModel(
//         title: "Fractional shares",
//         body:
//             "Instead of having to buy an entire share, invest any amount you want.",
//         image: Image.network(
//             "https://www.gstatic.com/images/branding/product/2x/photos_96dp.png"),
//       ),
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IntroductionScreen(
//         next: Text(
//           "Next",
//           style: Constants.heading1,
//         ),
//         done: Text(
//           "SignIN",
//           style: Constants.heading2,
//         ),
//         onDone: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => LogIn()),
//           );
//         },
//         pages: getpages(),
//         globalBackgroundColor: Constants.Secandorylight,
//       ),
//     );
//   }
// }
