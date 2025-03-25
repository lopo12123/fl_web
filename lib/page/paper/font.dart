import 'package:flutter/material.dart';

/// 支持的字体列表
abstract class AppFonts {
  /// PingFang SC -- 默认
  static const String pingFang = 'PingFang SC';

  /// Merriweather -- 文献标题
  static const String merriweather = 'Merriweather';

  /// Roboto -- 数据行文本 (日期, 热度, 数量, 等)
  static const String roboto = 'Roboto';
}

/// 自定义字体
@deprecated
class StyledText extends StatelessWidget {
  final String data;
  final String fontFamily;
  final bool selectable;
  final Color? color;

  /// 默认 16
  final double? fontSize;

  /// 默认 w500
  final FontWeight? fontWeight;
  final double? lineHeight;
  final bool? underline;
  final List<Shadow>? shadows;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final TextOverflow? overflow;
  final int? maxLines;

  const StyledText(
    this.data, {
    super.key,
    required this.fontFamily,
    this.selectable = false,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.lineHeight,
    this.underline,
    this.shadows,
    this.textAlign,
    this.textDirection,
    this.overflow,
    this.maxLines,
  }) : assert(overflow != null ? selectable == false : true);

  const StyledText.pingFang(
    this.data, {
    super.key,
    this.selectable = false,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.lineHeight,
    this.underline,
    this.shadows,
    this.textAlign,
    this.textDirection,
    this.overflow,
    this.maxLines,
  }) : fontFamily = AppFonts.pingFang;

  const StyledText.merriweather(
    this.data, {
    super.key,
    this.selectable = false,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.lineHeight,
    this.underline,
    this.shadows,
    this.textAlign,
    this.textDirection,
    this.overflow,
    this.maxLines,
  }) : fontFamily = AppFonts.merriweather;

  const StyledText.roboto(
    this.data, {
    super.key,
    this.selectable = false,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.lineHeight,
    this.underline,
    this.shadows,
    this.textAlign,
    this.textDirection,
    this.overflow,
    this.maxLines,
  }) : fontFamily = AppFonts.roboto;

  @override
  Widget build(BuildContext context) {
    return selectable
        ? SelectableText(
            data,
            style: TextStyle(
              color: color,
              fontSize: fontSize ?? 16,
              fontWeight: fontWeight ?? FontWeight.w500,
              fontFamily: fontFamily,
              height:
                  lineHeight != null ? (lineHeight! / (fontSize ?? 16)) : null,
              decoration: underline == true ? TextDecoration.underline : null,
            ),
            textAlign: textAlign,
            textDirection: textDirection,
            maxLines: maxLines,
          )
        : Text(
            data,
            style: TextStyle(
              color: color,
              fontSize: fontSize ?? 16,
              fontWeight: fontWeight ?? FontWeight.w500,
              fontFamily: fontFamily,
              height: (fontSize != null && lineHeight != null)
                  ? (lineHeight! / fontSize!)
                  : null,
              decoration: underline == true ? TextDecoration.underline : null,
              shadows: shadows,
            ),
            textAlign: textAlign,
            textDirection: textDirection,
            overflow: overflow,
            maxLines: maxLines,
          );
  }
}
