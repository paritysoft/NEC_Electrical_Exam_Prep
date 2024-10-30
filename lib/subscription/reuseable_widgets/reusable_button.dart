import 'package:commonquiz/ui/widgets/common_widget.dart';
import 'package:flutter/material.dart';

import '../../util/pixel_size.dart';


class ReusableButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color textColor;
  final Color backgroundColor;

  const ReusableButton(
      {required this.text,
      required this.onPressed,
      required this.textColor,
      required this.backgroundColor,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                PixelSize.value10,
              ),
            ),
          ),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(
                horizontal: PixelSize.value40, vertical: PixelSize.value16),
          ),
        ),
        onPressed: onPressed,
        child: smallLabel( context,
          text,
        ),
      );
}
