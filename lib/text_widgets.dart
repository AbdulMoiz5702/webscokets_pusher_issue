import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'colors.dart';

Widget largeText(
    {title,
      Color color = Colors.white,
      textSize = 20.0,
      FontWeight weight = FontWeight.bold}) {
  return AutoSizeText(
    title,
    style: TextStyle(color: color, fontSize: textSize, fontWeight: weight, fontFamily: "Poppins"),
  );
}

Widget normalText(
    {title,
      Color color = Colors.white,
      textSize = 16.0,
      FontWeight weight = FontWeight.w700}) {
  return AutoSizeText(
    title,
    style: TextStyle(color: color, fontSize: textSize, fontWeight: weight, fontFamily: "Poppins",),
  );
}

Widget smallText(
    {title,
      Color color = Colors.white,
      textSize = 12.0,
      FontWeight weight = FontWeight.w500}) {
  return AutoSizeText(
    title,
    style: TextStyle(color: color, fontSize: textSize, fontWeight: weight, fontFamily: "Poppins"),
  );
}


Widget listTileText(
    {title, Color color = whiteColor, textSize, weight = FontWeight.bold}) {
  return AutoSizeText(
    title,
    style: TextStyle(color: color, fontSize: textSize, fontWeight: weight, fontFamily: "Poppins",letterSpacing:1),
  );
}