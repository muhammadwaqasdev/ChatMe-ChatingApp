import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class Constants {
  static TextStyle regular1 = GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 12.0,
      color: Black,
      fontWeight: FontWeight.normal,
    ),
  );

  static TextStyle regular2 = GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 16.0,
      color: Black,
      fontWeight: FontWeight.normal,
    ),
  );

  static TextStyle regular3 = GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 18.0,
      color: Black,
      fontWeight: FontWeight.normal,
    ),
  );

  static TextStyle heading1 = GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 16.0,
      color: Black,
      fontWeight: FontWeight.bold,
    ),
  );

  static TextStyle heading2 = GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 20.0,
      color: Black,
      fontWeight: FontWeight.bold,
    ),
  );

  static TextStyle heading3 = GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 22.0,
      color: Black,
      fontWeight: FontWeight.bold,
    ),
  );

  // ignore: non_constant_identifier_names
  static HexColor Primery = HexColor("#112854");
  // ignore: non_constant_identifier_names
  static HexColor Secandory = HexColor("#ff6600");
  // ignore: non_constant_identifier_names
  static HexColor Secandorylight = HexColor("#f79554");
  // ignore: non_constant_identifier_names
  static HexColor White = HexColor("#ffffff");
  // ignore: non_constant_identifier_names
  static HexColor Black = HexColor("#000000");
}
