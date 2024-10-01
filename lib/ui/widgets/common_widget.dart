import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../util/app_constants.dart';

snackBar(BuildContext context, String message) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    ),
  );
}

smallLabel(BuildContext context, String title,
        {Color? color, TextAlign? alignment, double? textSize}) =>
    Text(
      title,
      style: GoogleFonts.montserrat(
        textStyle: TextStyle(
            fontSize: AdaptiveFontSize.getFontSize(context, textSize ?? 14),
            fontWeight: FontWeight.normal,
            color: color ?? Colors.black),
      ),
      textAlign: alignment ?? TextAlign.start,
    );

label(
  BuildContext context,
  String title,
) =>
    Text(
      title,
      style: GoogleFonts.montserrat(
          textStyle:
              TextStyle(fontSize: AdaptiveFontSize.getFontSize(context, 17))),
      textAlign: TextAlign.center,
    );

labelFullWidth(
  BuildContext context,
  String title,
) =>
    Text(
      title,
      style: GoogleFonts.montserrat(
          textStyle:
              TextStyle(fontSize: AdaptiveFontSize.getFontSize(context, 17))),
      textAlign: TextAlign.start,
    );

labelColor(BuildContext context, String title, {Color? color}) => Text(
      title,
      style: GoogleFonts.montserrat(
          textStyle: TextStyle(
              fontSize: AdaptiveFontSize.getFontSize(context, 17),
              color: color)),
      textAlign: TextAlign.center,
    );

title15BoldColor(BuildContext context, String title, {Color? color}) => Text(
      title,
      style: GoogleFonts.montserrat(
          textStyle: TextStyle(
              fontSize: AdaptiveFontSize.getFontSize(context, 15),
              color: color,
              fontWeight: FontWeight.bold)),
      textAlign: TextAlign.justify,
    );

label13Color(BuildContext context, String title, {Color? color}) => Text(
      title,
      style: GoogleFonts.montserrat(
          textStyle: TextStyle(
              fontSize: AdaptiveFontSize.getFontSize(context, 13),
              color: color)),
      textAlign: TextAlign.start,
    );

titleLabel(BuildContext context, String title, {Color? color}) => Text(
      title,
      style: GoogleFonts.montserrat(
          textStyle: TextStyle(
              fontSize: AdaptiveFontSize.getFontSize(context, 18),
              fontWeight: FontWeight.w600,
              color: color ?? Colors.black)),
      textAlign: TextAlign.start,
    );

bigTitle(BuildContext context, String title, {Color? color}) => Text(
      title,
      style: GoogleFonts.montserrat(
        textStyle: TextStyle(
            fontSize: AdaptiveFontSize.getFontSize(context, 25),
            fontWeight: FontWeight.bold,
            color: color ?? Colors.black),
      ),
      textAlign: TextAlign.start,
    );

class Countdown extends AnimatedWidget {
  Countdown({Key? key, required this.animation})
      : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value ?? 0);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    print('animation.value  ${animation.value ?? 0} ');
    print('inMinutes ${clockTimer.inMinutes.toString()}');
    print('inSeconds ${clockTimer.inSeconds.toString()}');
    print(
        'inSeconds.remainder ${clockTimer.inSeconds.remainder(60).toString()}');

    return Text(
      "$timerText",
      style: GoogleFonts.lato(
          textStyle: TextStyle(
        fontSize: AdaptiveFontSize.getFontSize(context, 20),
        color: Theme.of(context).primaryColor,
      )),
    );
  }
}
