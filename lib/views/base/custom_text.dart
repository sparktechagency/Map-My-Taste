import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  CustomText(
      {super.key,
        this.maxLine,
        this.textOverflow,
        this.fontName,
        this.textDecoration = TextDecoration.none,
        this.textAlign = TextAlign.center,
        this.decorationColor = Colors.grey,
        this.left = 0,
        this.right = 0,
        this.top = 0,
        this.bottom = 0,
        this.fontSize = 14,
        this.textHeight,
        this.fontWeight = FontWeight.w400,
        this.color = Colors.white,
        this.text = ""});

  final double left;
  final TextOverflow? textOverflow;
  final double right;
  final double top;
  final double bottom;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final String text;
  final Color decorationColor;
  final TextAlign textAlign;
  final int? maxLine;
  final String? fontName;
  final double? textHeight;
  final TextDecoration? textDecoration;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      EdgeInsets.only(left: left, right: right, top: top, bottom: bottom),
      child: Text(
        textAlign: textAlign,
        text,
        maxLines: maxLine,
        overflow: textOverflow ?? TextOverflow.ellipsis,
        style: TextStyle(
          decoration: textDecoration,
          fontSize: fontSize,
          decorationColor: Colors.grey,
          fontFamily: fontName ?? "Arial",
          fontWeight: fontWeight,
          color: color,
        ),
      ),
    );
  }
}
