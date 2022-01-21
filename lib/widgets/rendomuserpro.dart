import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants.dart';

class RendomUserProfile extends StatelessWidget {
  final String name;
  final String nikname;
  final String conteryname;
  final String introline;
  final String userimage;
  final Function onusertap;
  final Function hellotap;
  const RendomUserProfile(
      {Key? key,
      required this.conteryname,
      required this.hellotap,
      required this.introline,
      required this.name,
      required this.nikname,
      required this.onusertap,
      required this.userimage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onusertap();
      },
      child: Card(
        color: Colors.grey.shade50,
        elevation: 3.0,
        shadowColor: Constants.Primery,
        child: Container(
          height: 80.0,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.transparent,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 10.0,
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      userimage,
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(TextSpan(
                        children: <TextSpan>[
                          TextSpan(text: name, style: Constants.heading1),
                          TextSpan(
                              text: "\n(" + conteryname + ")",
                              style: Constants.regular2),
                        ],
                      )),
                      Text(
                        introline,
                        style: Constants.regular1,
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  hellotap();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      FontAwesomeIcons.handSparkles,
                      color: Constants.Secandory,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
