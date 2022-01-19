import 'package:chatme/constants.dart';
import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  final String text;
  final Function onpreased;
  final bool outlinebtn;
  final Color bgcolor;
  final Color textcolor;

  // ignore: use_key_in_widget_constructors
  const CustomBtn(
      {required this.text,
      required this.onpreased,
      required this.outlinebtn,
      required this.bgcolor,
      required this.textcolor});

  @override
  Widget build(BuildContext context) {
    bool _outline = outlinebtn;
    return GestureDetector(
      onTap: () {
        onpreased();
      },
      child: Container(
          height: 50.0,
          decoration: BoxDecoration(
              color: bgcolor,
              border: Border.all(
                  color: _outline ? Constants.Primery : Colors.transparent,
                  width: 2.0),
              borderRadius: BorderRadius.circular(25.0)),
          margin: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 24.0,
          ),
          child: Stack(
            children: [
              Center(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: textcolor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
