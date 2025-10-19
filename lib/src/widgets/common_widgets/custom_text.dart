import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String title;
  final double? fontSize;
  final TextAlign? alignText;
  final int? maxLines;
  final TextOverflow? overflow;
  final FontWeight? weight;
  final Color? color;
  final int? maxWords;
  final int? maxChars;
  final bool underLine;
  final String? fontFamily;
  final FontStyle? fontStyle;

  const CustomText({
    super.key,
    required this.title,
    this.fontSize,
    this.alignText,
    this.maxLines,
    this.overflow,
    this.weight,
    this.color,
    this.maxWords,
    this.maxChars,
    this.underLine = false,
    this.fontFamily = 'Roboto Flex',
    this.fontStyle,
  });

  String _truncateByWords(String text, {int maxWords = 3}) {
    final words = text.split(' ');
    if (words.length <= maxWords) {
      return text;
    }
    return '${words.take(maxWords).join(' ')}...';
  }

  String _truncateByChars(String text, {int maxChars = 30}) {
    if (text.length <= maxChars) {
      return text;
    }
    return '${text.substring(0, maxChars)}...';
  }

  @override
  Widget build(BuildContext context) {
    String displayText = title;
    if (maxWords != null) {
      displayText = _truncateByWords(title, maxWords: maxWords!);
    } else if (maxChars != null) {
      displayText = _truncateByChars(title, maxChars: maxChars!);
    }
    return Text(
      displayText,
      style: TextStyle(
        fontSize: fontSize ?? 16,
        fontWeight: weight,
        color: color ?? Colors.black,
        decoration: underLine ? TextDecoration.underline : null,
        fontStyle: fontStyle ?? FontStyle.normal,
        fontFamily:
            fontFamily ??
            GoogleFonts.poppins(
              fontSize: fontSize ?? 16,
              fontWeight: weight,
              color: color ?? Colors.black,
              decoration: underLine ? TextDecoration.underline : null,
              fontStyle: fontStyle ?? FontStyle.normal,
            ).fontFamily,
      ),
      textAlign: alignText,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
