import 'dart:developer';
import 'dart:math';

import 'package:chatme/constants.dart';
import 'package:chatme/main.dart';
import 'package:chatme/models/chat.dart';
import 'package:chatme/models/chatroom.dart';
import 'package:chatme/models/intprofile.dart';
import 'package:chatme/models/user.dart';
import 'package:chatme/screens/login&signup/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMenthods {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference profilelist =
      FirebaseFirestore.instance.collection("user");
  User? user = FirebaseAuth.instance.currentUser;
}

// Future<bool> signUp(String email, String password) async {
//   try {
//     await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
//     return true;
//   } on FirebaseAuthException catch (e) {
//     if (e.code == "weak-password") {
//       //TODO: print("Password Weak");
//     } else if (e.code == "email-already-in-use") {
//       //TODO: print("Account Already Created");
//     }
//     return false;
//   } catch (e) {
//     //TODO: print(e.toString());
//     return false;
//   }
// }

// Future<bool> signIn(String email, String password) async {
//   try {
//     await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
//     return true;
//   } catch (e) {
//     //TODO: print(e.toString());
//     return false;
//   }
// }

// Future<bool> SignIngoogle() async {
//   try {
//     final googlesignin =
//     return true;
//   } catch (e) {
//     //TODO: print(e.toString());
//     return false;
//   }
// }

Future<User?> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  final usercred = await FirebaseAuth.instance.signInWithCredential(credential);
  final User? user = usercred.user;

  assert(!user!.isAnonymous);
  assert(await user!.getIdToken() != null);

  final currentuser = await FirebaseAuth.instance.currentUser;
  assert(currentuser!.uid == user!.uid);

  print(user);
  return user;
}

Future<bool> facebookSignIn(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return true;
  } catch (e) {
    //TODO: print(e.toString());
    return false;
  }
}

Future<bool> logOut() async {
  try {
    final gsign = GoogleSignIn();
    await gsign.signOut();
    await FirebaseAuth.instance.signOut();
    return true;
  } catch (e) {
    //TODO: print(e.toString());
    return false;
  }
}

Future<bool> resetPassword(String email) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    return true;
  } catch (e) {
    //TODO: print(e.toString());
    return false;
  }
}

// Future<bool> adduserinfo(String userid, String name, String nikname,
//     String email, String Pass) async {
//   try {
//     await FirebaseFirestore.instance.collection("user").add(
//       {
//         'id': userid,
//         'name': name.toUpperCase(),
//         'nikname': nikname,
//         'email': email,
//         'Password': Pass,
//         'intro': "",
//         'imageurl': "",
//         'age': "",
//         'country': "",
//         'gender': "",
//         'blockeduser': "",
//         'reportcount': 0,
//         'Favusers': [],
//         'accactive': true,
//       },
//     );
//     return true;
//   } catch (e) {
//     //print(e.toString());
//     return false;
//   }
// }

// Future<bool> adduserinfomore(String name, String nikname, String email,
//     String Pass, String imageurl, int age, String gender) async {
//   try {
//     await FirebaseFirestore.instance.collection("user").add(
//       {
//         'name': name.toUpperCase(),
//         'nikname': nikname,
//         'email': email,
//         'Password': Pass,
//         'imageurl': imageurl,
//         'age': age,
//         'gender': gender,
//       },
//     );
//     return true;
//   } catch (e) {
//     //print(e.toString());
//     return false;
//   }
// }

// Future getuserinfo() async {
//   List userlist = [];

//   try {
//     FirebaseFirestore.instance.collection("user").get().then(
//           (querySnapshot) => {
//             // ignore: avoid_function_literals_in_foreach_calls
//             querySnapshot.docs.forEach(
//               (element) {
//                 userlist.add(element.data());
//               },
//             ),
//           },
//         );
//     return userlist;
//   } catch (e) {
//     print(e.toString());
//     return null;
//   }
// }

// Future searchuser(String uname) async {
//   List userlist = [];
//   try {
//     FirebaseFirestore.instance
//         .collection("users")
//         .where("name", isEqualTo: uname.toUpperCase())
//         .get()
//         .then(
//           (querySnapshot) => {
//             // ignore: avoid_function_literals_in_foreach_calls
//             querySnapshot.docs.forEach(
//               (element) {
//                 userlist.add(element.data());
//               },
//             ),
//           },
//         );
//     return userlist;
//   } catch (e) {
//     print(e.toString());
//     return null;
//   }
// }

// Future searchuserbyid() async {
//   String uid = getCurrentUser();
//   List userlist = [];
//   try {
//     FirebaseFirestore.instance
//         .collection("user")
//         .where("name", isEqualTo: uid)
//         .get()
//         .then(
//           (querySnapshot) => {
//             // ignore: avoid_function_literals_in_foreach_calls
//             querySnapshot.docs.forEach(
//               (element) {
//                 userlist.add(element.data());
//               },
//             ),
//           },
//         );
//     return userlist;
//   } catch (e) {
//     print(e.toString());
//     return null;
//   }
// }

// Future uplodemassages(
//     String myid, String uid, String messages, String url) async {
//   try {
//     FirebaseFirestore.instance.collection('chats/$uid/messages').add(
//       {
//         'massage': messages,
//         'senderid': myid,
//         'receiverid': uid,
//         'cretedat': DateTime.now(),
//         'imageurl': url,
//       },
//     );
//     return true;
//   } catch (e) {
//     print(e.toString());
//     return false;
//   }
// }

//Geting Currrent UserID
String getCurrentUser() {
  final User? user = FirebaseAuth.instance.currentUser;
  final _uid = user!.uid;
  return _uid;
}

class FirebaseHelper {
  static Future<UserModel?> getUserModelById(String uid) async {
    UserModel? userModel;

    DocumentSnapshot docSnap =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if (docSnap.data() != null) {
      userModel = UserModel.fromMap(docSnap.data() as Map<String, dynamic>);
    }

    return userModel;
  }

  static Future<IntrestProfile?> getintrestModelById(UserModel cuser) async {
    IntrestProfile? intuserModel;

    DocumentSnapshot docSnap = await FirebaseFirestore.instance
        .collection("users")
        .doc(cuser.uid)
        .collection("intrest")
        .doc(cuser.uid)
        .get();

    if (docSnap.data() != null) {
      intuserModel =
          IntrestProfile.fromMap(docSnap.data() as Map<String, dynamic>);
    }

    return intuserModel;
  }

  static Future<ChatRoomModel?> chatroomishave(
      UserModel cuser, UserModel targetUser, int index) async {
    // ChatRoomModel? chatRoom;

    // QuerySnapshot snapshot = await FirebaseFirestore.instance
    //     .collection("chatrooms")
    //     .where("Partisipents.${cuser.uid}", isEqualTo: true)
    //     .where("Partisipents.${targetUser.uid}", isEqualTo: true)
    //     .get();

    // if (snapshot.docs.length > 0) {
    //   // Fetch the existing one
    //   var docData = snapshot.docs[index].data();
    //   ChatRoomModel existingChatroom =
    //       ChatRoomModel.fromMap(docData as Map<String, dynamic>);

    //   chatRoom = existingChatroom;
    // }
    // return chatRoom;
    // QuerySnapshot snap = await FirebaseFirestore.instance
    //     .collection("chatrooms")
    //     .where("Partisipents.${cuser.uid}")
    //     .get();
    // ChatRoomModel chatRoomModel =
    //     await ChatRoomModel.fromMap(snap.docs[0].data() as Map<String, dynamic>);
    // if (chatRoomModel.Chatrromid != null) {
    //   return false;
    // }
    // return true;
  }
}

//Say Hy fastest
Future<bool> sayhyfaster(UserModel sender, ChatRoomModel chatroom) async {
  ChatModel newMessage = ChatModel(
      messageid: uuid.v1(),
      sender: sender.uid,
      cretedon: DateTime.now(),
      message: "Hay",
      type: "Text");

  FirebaseFirestore.instance
      .collection("chatrooms")
      .doc(chatroom.Chatrromid)
      .collection("messages")
      .doc(newMessage.messageid)
      .set(newMessage.toMap());

  chatroom.lastmessage = newMessage.message;
  FirebaseFirestore.instance
      .collection("chatrooms")
      .doc(chatroom.Chatrromid)
      .set(chatroom.toMap());

  return false;
}

Future<void> blockuser(UserModel sender, ChatRoomModel chatroom) async {
  await FirebaseFirestore.instance
      .collection("chatrooms")
      .doc(chatroom.Chatrromid)
      .update({"Partisipents.${sender.uid}": false}).then((value) {
    print("User Blocked");
  });
}

Future<void> unblockuser(UserModel sender, ChatRoomModel chatroom) async {
  await FirebaseFirestore.instance
      .collection("chatrooms")
      .doc(chatroom.Chatrromid)
      .update({"Partisipents.${sender.uid}": true}).then((value) {
    print("User Un_Blocked");
  });
}

Future<void> favsuer(UserModel cuser, UserModel favmodel) async {
  await FirebaseFirestore.instance
      .collection("users")
      .doc(cuser.uid)
      .update({"favoriteusers.${favmodel.uid}": true}).then((value) {
    print("error in fav");
  });
}

Future<void> un_favsuer(UserModel cuser, UserModel favmodel) async {
  await FirebaseFirestore.instance.collection("users").doc(cuser.uid).update(
      {"favoriteusers.${favmodel.uid}": FieldValue.delete()}).then((value) {
    print("Update in fav");
  });
}

void reportuser(UserModel user) async {
  UserModel? userModel;
  DocumentSnapshot snap =
      await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
  if (snap.data() != null) {
    userModel = UserModel.fromMap(snap.data() as Map<String, dynamic>);
  }
  FirebaseFirestore.instance.collection("users").doc(user.uid).update({
    "reportedcount": userModel!.reportedcount! + 1,
  }).then((value) {
    print("Data Updated");
  });
  // ignore: unrelated_type_equality_checks
  if (userModel.reportedcount == 4) {
    FirebaseFirestore.instance.collection("users").doc(user.uid).delete();
  }
}
