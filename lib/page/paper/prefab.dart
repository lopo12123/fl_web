import 'package:bad_fl/bad_fl.dart';
import 'package:fl_web/page/paper/color.dart';
import 'package:flutter/material.dart';
import 'font.dart';
import 'model.dart';

class PaperTitle extends StatelessWidget {
  static const _style = TextStyle(
    color: AppColors.grey10,
    fontSize: 16,
    fontFamily: AppFonts.merriweather,
    fontWeight: FontWeight.w700,
    height: 22 / 16,
  );

  final String source;
  final String translation;
  final int sourceMaxLines;
  final int translationMaxLines;

  const PaperTitle({
    super.key,
    required this.source,
    required this.translation,
    this.sourceMaxLines = 4,
    this.translationMaxLines = 2,
  });

  @override
  Widget build(BuildContext context) {
    final sourceWidget = BadKatex(
      raw: source,
      style: _style,
      maxLines: sourceMaxLines,
    );
    if (translation.isEmpty) return sourceWidget;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        sourceWidget,
        BadKatex(
          raw: translation,
          maxLines: translationMaxLines,
          leading: [
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.only(right: 2),
                child: Image.asset(
                  'assets/image/translation.png',
                  width: 16,
                  height: 16,
                  isAntiAlias: true,
                ),
              ),
            ),
          ],
          style: const TextStyle(
            color: AppColors.trans3,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 22 / 14,
          ),
        )
      ],
    );
  }
}

class PaperStatistic extends StatelessWidget {
  final String date;
  final int popularity;
  final int cite;

  const PaperStatistic({
    super.key,
    required this.date,
    required this.popularity,
    required this.cite,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 14,
      child: Row(
        children: [
          Image.asset(
            'assets/image/calendar.png',
            width: 14,
            height: 14,
            isAntiAlias: true,
          ),
          const SizedBox(width: 4),
          BadText(
            date,
            color: AppColors.grey6,
            fontSize: 13,
            fontFamily: AppFonts.roboto,
            lineHeight: 13,
          ),
          const VerticalDivider(
            width: 16,
            thickness: 1,
            color: AppColors.grey3,
          ),
          Image.asset(
            'assets/image/flame.png',
            width: 14,
            height: 14,
            isAntiAlias: true,
          ),
          const SizedBox(width: 4),
          BadText(
            popularity.readable,
            color: AppColors.grey6,
            fontSize: 13,
            fontFamily: AppFonts.roboto,
            lineHeight: 13,
          ),
          const VerticalDivider(
            width: 16,
            thickness: 1,
            color: AppColors.grey3,
          ),
          Image.asset(
            'assets/image/quote.png',
            width: 14,
            height: 14,
            isAntiAlias: true,
          ),
          const SizedBox(width: 4),
          BadText(
            '$cite',
            color: AppColors.grey6,
            fontSize: 13,
            fontFamily: AppFonts.roboto,
            lineHeight: 13,
          ),
        ],
      ),
    );
  }
}

class AuthorFragment extends StatelessWidget {
  final SharePaperDTO paper;

  List<String> get authors => paper.authors;

  String get author => authors[0];

  String get char {
    assert(author.isNotEmpty);

    return author[0].toUpperCase();
  }

  String? get suffix {
    final plus = authors.length - 1;
    if (plus == 0) return null;
    return '+$plus';
  }

  const AuthorFragment(this.paper, {super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableW = constraints.maxWidth;
        final suffixW = suffix == null
            ? 0.0
            : (TextMeasureImpl.measure(suffix!).width + 16);
        final authorW = (availableW - 20 - suffixW).floorToDouble();

        return Row(
          children: [
            CircleAvatar(
              radius: 8,
              backgroundColor: AppColors.grey4,
              child: BadText(
                char,
                color: AppColors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                lineHeight: 10,
              ),
            ),
            const SizedBox(width: 4),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: authorW, minWidth: 0),
              child: BadText(
                author,
                color: AppColors.grey8,
                fontSize: 13,
                lineHeight: 16,
                maxLines: 1,
              ),
            ),
            if (suffix != null)
              Container(
                height: 16,
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: AppColors.grey4,
                ),
                alignment: Alignment.center,
                child: BadText(
                  suffix!,
                  color: AppColors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  lineHeight: 10,
                ),
              ),
          ],
        );
      },
    );
  }
}
