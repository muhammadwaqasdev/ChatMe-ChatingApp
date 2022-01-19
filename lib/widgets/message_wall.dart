import 'package:chatme/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// ignore: must_be_immutable
class MWallUs extends StatelessWidget {
  final int index;
  final Map<String, dynamic> data;
  const MWallUs({Key? key, required this.data, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
          constraints: const BoxConstraints(
            maxWidth: 250,
          ),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.grey[350],
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "  fghnfdgbfd",
                style: Constants.regular1,
              ),
              Text(
                "message",
                style: Constants.regular2,
              ),
            ],
          )),
    );
  }
}

// ignore: must_be_immutable
class MWallOther extends StatelessWidget {
  String message;
  String timedate;
  MWallOther(this.message, {Key? key, required this.timedate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
          constraints: const BoxConstraints(
            maxWidth: 250,
          ),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Constants.Secandorylight,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style: Constants.regular2,
              ),
              Text(
                "  " + timedate.toString(),
                style: Constants.regular1,
              ),
            ],
          )),
    );
  }
}

class MassageWall extends StatelessWidget {
  final List<QueryDocumentSnapshot> messages;
  const MassageWall({Key? key, required this.messages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return MWallOther(
            "hello",
            timedate: '10:56',
          );
        });
  }
}
