import 'package:chatme/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants.dart';

class FavUserlist extends StatefulWidget {
  const FavUserlist({Key? key}) : super(key: key);

  @override
  State<FavUserlist> createState() => _FavUserlistState();
}

class _FavUserlistState extends State<FavUserlist> {
  List<dynamic> usersearchlist = [];
  List<String> userids = [];
  List blockeduserdata = [];

  fetchdatabselist() async {
    //dynamic resultdata = await searchuser(searchcontroller.text) as List;

    await FirebaseFirestore.instance
        .collection("user")
        .where("id", isEqualTo: getCurrentUser())
        .get()
        .then(
          (querySnapshot) => {
            // ignore: avoid_function_literals_in_foreach_calls
            querySnapshot.docs.forEach(
              (element) {
                setState(() {
                  usersearchlist = element.data()['Favusers'];
                });
              },
            ),
          },
        );
  }

  Widget searchList() {
    return ListView.builder(
        itemCount: usersearchlist.length,
        shrinkWrap: true,
        itemBuilder: (contaxt, index) {
          FirebaseFirestore.instance
              .collection("user")
              .where("id", isEqualTo: usersearchlist[index].toString())
              .get()
              .then(
                (querySnapshot) => {
                  // ignore: avoid_function_literals_in_foreach_calls
                  querySnapshot.docs.forEach(
                    (element) {
                      setState(() {
                        blockeduserdata.add(element.data());
                      });
                    },
                  ),
                },
              );
          return ListView.builder(
              itemCount: blockeduserdata.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Searchtile(
                  name: blockeduserdata[index]["name"],
                  imageurl: blockeduserdata[index]["imageurl"],
                  ontrash: () {},
                );
              });
        });
  }

  @override
  void initState() {
    usersearchlist.clear();
    userids.clear();
    blockeduserdata.clear();
    fetchdatabselist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.Primery,
        centerTitle: true,
        title: const Text("Favorite User"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: searchList(),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Searchtile extends StatefulWidget {
  String name;
  String imageurl;
  Function ontrash;
  Searchtile(
      {Key? key,
      required this.ontrash,
      required this.imageurl,
      required this.name})
      : super(key: key);

  @override
  State<Searchtile> createState() => _SearchtileState();
}

class _SearchtileState extends State<Searchtile> {
  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Constants.Primery,
                    child: Image(
                      image: NetworkImage(widget.imageurl),
                      height: 35,
                      width: 35,
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    widget.name,
                    style: Constants.heading2,
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(FontAwesomeIcons.trash),
                onPressed: () {
                  widget.ontrash();
                },
              )
            ],
          ),
          const Divider(
            thickness: 0.5,
          )
        ],
      ),
    );
  }
}
