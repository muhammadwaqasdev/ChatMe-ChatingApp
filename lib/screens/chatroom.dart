import 'dart:io';

import 'package:chatme/constants.dart';
import 'package:chatme/main.dart';
import 'package:chatme/models/chat.dart';
import 'package:chatme/models/chatroom.dart';
import 'package:chatme/models/user.dart';
import 'package:chatme/services.dart';
import 'package:chatme/widgets/message_wall.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ChatRoom extends StatefulWidget {
  final UserModel targetusermodel;
  final ChatRoomModel chatroom;
  final UserModel userModel;
  final User firebaseuser;

  const ChatRoom(
      {Key? key,
      required this.targetusermodel,
      required this.chatroom,
      required this.userModel,
      required this.firebaseuser})
      : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final currentmassage = TextEditingController();
  String massage = "";
  File? imageFile;
  String? imageUrl;

  Future getImage() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.camera).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uplodeImage();
      }
    });
  }

  Future uplodeImage() async {
    String filename = uuid.v1();
    int ststusval = 1;

    ChatModel newMessage = ChatModel(
        messageid: uuid.v1(),
        sender: widget.userModel.uid,
        cretedon: DateTime.now(),
        imagepic: "",
        type: "Img");

    FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(widget.chatroom.Chatrromid)
        .collection("messages")
        .doc(newMessage.messageid)
        .set(newMessage.toMap());

    var uploadTask = await FirebaseStorage.instance
        .ref("shareimage")
        .child(widget.chatroom.Chatrromid.toString())
        .child("$filename.jpg")
        .putFile(imageFile!)
        .catchError((error) {
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.Chatrromid)
          .collection("messages")
          .doc(newMessage.messageid)
          .delete();
      ststusval = 0;
    });
    if (ststusval == 1) {
      imageUrl = await uploadTask.ref.getDownloadURL();
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.Chatrromid)
          .collection("messages")
          .doc(newMessage.messageid)
          .update({
        "imagepic": imageUrl,
      });

      print(imageUrl);
    }
  }

  // String? imageUrl;
  // //String cruntuserid = getCurrentUser();

  // void selectImage(ImageSource source) async {
  //   XFile? pickedFile = await ImagePicker().pickImage(source: source);

  //   if (pickedFile != null) {
  //     cropImage(pickedFile);
  //     pickedFile = null;
  //   }
  // }

  // void cropImage(XFile file) async {
  //   File? croppedImage = await ImageCropper.cropImage(
  //       sourcePath: file.path,
  //       aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
  //       compressQuality: 20);

  //   if (croppedImage != null) {
  //     setState(() {
  //       imageFile = croppedImage;
  //       croppedImage = null;
  //     });
  //   }
  // }

  // if (imageFile != null) {
  //     UploadTask uploadTask = FirebaseStorage.instance
  //         .ref("shareimage")
  //         .child(widget.chatroom.Chatrromid.toString())
  //         .putFile(imageFile!);

  //     imageFile = null;

  //     TaskSnapshot snapshot = await uploadTask;

  //     imageUrl = await snapshot.ref.getDownloadURL();
  //   }

  void sendMessages() async {
    FocusScope.of(context).unfocus();
    currentmassage.clear();

    if (massage != "") {
      // Send Message
      ChatModel newMessage = ChatModel(
          messageid: uuid.v1(),
          sender: widget.userModel.uid,
          cretedon: DateTime.now(),
          message: massage,
          type: "Text");

      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.Chatrromid)
          .collection("messages")
          .doc(newMessage.messageid)
          .set(newMessage.toMap());

      widget.chatroom.lastmessage = massage;
      widget.chatroom.lastmessagetime = DateTime.now();
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.Chatrromid)
          .set(widget.chatroom.toMap());

      massage = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.Primery,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  NetworkImage(widget.targetusermodel.prifilepic.toString()),
            ),
            const SizedBox(
              width: 5.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.targetusermodel.fullname.toString(),
                  style: Constants.heading1.copyWith(color: Constants.White),
                ),
                Text(
                  widget.targetusermodel.status.toString(),
                  style: Constants.regular1.copyWith(color: Constants.White),
                )
              ],
            ),
          ],
        ),
        actions: [
          PopupMenuButton(
              icon: const Icon(
                FontAwesomeIcons.ellipsisV,
                size: 18.0,
              ),
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Text("Block"),
                      onTap: () =>
                          blockuser(widget.targetusermodel, widget.chatroom),
                    ),
                    PopupMenuItem(
                      child: const Text("Report"),
                      onTap: () => reportuser(widget.targetusermodel),
                    ),
                    PopupMenuItem(
                      child: const Text("Block & Report"),
                      onTap: () {
                        blockuser(widget.targetusermodel, widget.chatroom);
                        reportuser(widget.targetusermodel);
                      },
                    )
                  ]),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              // ignore: avoid_unnecessary_containers
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("chatrooms")
                        .doc(widget.chatroom.Chatrromid)
                        .collection("messages")
                        .orderBy("cretedon", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      DateFormat dateFormat = DateFormat("HH:mm");
                      if (snapshot.connectionState == ConnectionState.active) {
                        if (snapshot.hasData) {
                          QuerySnapshot dataSnapshot =
                              snapshot.data as QuerySnapshot;

                          return ListView.builder(
                            reverse: true,
                            itemCount: dataSnapshot.docs.length,
                            itemBuilder: (context, index) {
                              ChatModel currentMessage = ChatModel.fromMap(
                                  dataSnapshot.docs[index].data()
                                      as Map<String, dynamic>);

                              return (currentMessage.type == "Text")
                                  ? Row(
                                      mainAxisAlignment:
                                          (currentMessage.sender ==
                                                  widget.userModel.uid)
                                              ? MainAxisAlignment.end
                                              : MainAxisAlignment.start,
                                      children: [
                                        Container(
                                            margin: const EdgeInsets.symmetric(
                                              vertical: 2,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                              horizontal: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color: (currentMessage.sender ==
                                                      widget.userModel.uid)
                                                  ? Constants.Primery
                                                  : Constants.Secandory,
                                              borderRadius: (currentMessage
                                                          .sender ==
                                                      widget.userModel.uid)
                                                  ? const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      topRight:
                                                          Radius.circular(20),
                                                      bottomLeft:
                                                          Radius.circular(20))
                                                  : const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      topRight:
                                                          Radius.circular(20),
                                                      bottomRight:
                                                          Radius.circular(20)),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  (currentMessage.sender ==
                                                          widget.userModel.uid)
                                                      ? CrossAxisAlignment.end
                                                      : CrossAxisAlignment
                                                          .start,
                                              children: [
                                                Text(
                                                    currentMessage.message
                                                        .toString(),
                                                    style: Constants.regular2
                                                        .copyWith(
                                                            color: Constants
                                                                .White)),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  dateFormat.format(
                                                      currentMessage.cretedon!
                                                          .toLocal()),
                                                  style: (currentMessage
                                                              .sender ==
                                                          widget.userModel.uid)
                                                      ? Constants.regular1
                                                          .copyWith(
                                                              color: Constants
                                                                  .Secandory)
                                                      : Constants.regular1
                                                          .copyWith(
                                                              color: Constants
                                                                  .Primery),
                                                )
                                              ],
                                            )),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          (currentMessage.sender ==
                                                  widget.userModel.uid)
                                              ? MainAxisAlignment.end
                                              : MainAxisAlignment.start,
                                      children: [
                                        Container(
                                            margin: const EdgeInsets.symmetric(
                                              vertical: 2,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                              horizontal: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color: (currentMessage.sender ==
                                                      widget.userModel.uid)
                                                  ? Constants.Primery
                                                  : Constants.Secandory,
                                              borderRadius: (currentMessage
                                                          .sender ==
                                                      widget.userModel.uid)
                                                  ? const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      topRight:
                                                          Radius.circular(20),
                                                      bottomLeft:
                                                          Radius.circular(20))
                                                  : const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      topRight:
                                                          Radius.circular(20),
                                                      bottomRight:
                                                          Radius.circular(20)),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  (currentMessage.sender ==
                                                          widget.userModel.uid)
                                                      ? CrossAxisAlignment.end
                                                      : CrossAxisAlignment
                                                          .start,
                                              children: [
                                                Image(
                                                  image: NetworkImage(
                                                    currentMessage.imagepic
                                                        .toString(),
                                                  ),
                                                  height: 300,
                                                  width: 300,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  dateFormat.format(
                                                      currentMessage.cretedon!
                                                          .toLocal()),
                                                  style: (currentMessage
                                                              .sender ==
                                                          widget.userModel.uid)
                                                      ? Constants.regular1
                                                          .copyWith(
                                                              color: Constants
                                                                  .Secandory)
                                                      : Constants.regular1
                                                          .copyWith(
                                                              color: Constants
                                                                  .Primery),
                                                )
                                              ],
                                            )),
                                      ],
                                    );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Text(
                                "An error occured! Please check your internet connection."),
                          );
                        } else {
                          return const Center(
                            child: Text("Say hi to your new friend"),
                          );
                        }
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ),
            ),
            // ignore: avoid_unnecessary_containers
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: currentmassage,
                      textCapitalization: TextCapitalization.sentences,
                      autocorrect: true,
                      enableSuggestions: true,
                      decoration: InputDecoration(
                        focusColor: Constants.Primery,
                        hoverColor: Constants.Secandory,
                        filled: true,
                        fillColor: Colors.grey[100],
                        hintText: "Type Your Massage",
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0, color: Constants.Black),
                          gapPadding: 10,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      minLines: 1,
                      maxLines: 10,
                      onChanged: (val) {
                        massage = val;
                      },
                    ),
                  ),
                  IconButton(
                      color: Constants.Primery,
                      onPressed: () {
                        //selectImage(ImageSource.camera);
                        getImage();
                      },
                      icon: const Icon(FontAwesomeIcons.image)),
                  IconButton(
                      color: Constants.Primery,
                      onPressed: () {
                        (massage.trim().isEmpty) ? null : sendMessages();
                      },
                      icon: const Icon(FontAwesomeIcons.paperPlane)),
                ],
              ),
            )
          ],
        )),
      ),
    );
  }
}
