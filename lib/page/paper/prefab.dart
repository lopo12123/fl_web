import 'package:bad_fl/bad_fl.dart';
import 'package:fl_web/page/paper/color.dart';
import 'package:flutter/material.dart';
import 'font.dart';
import 'model.dart';

class JournalFragment extends StatelessWidget {
  final SharePaperDTO paper;

  String get journalName => paper.publicationEnName;

  String get journalSrc => paper.publicationCover;

  String get impactFactor {
    final v = paper.impactFactor;
    return v == 0 ? '' : '(IF $v)';
  }

  const JournalFragment(this.paper, {super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      final freeWidth = constraints.maxWidth -
          40 -
          TextMeasureImpl.measure(
            impactFactor,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              fontFamily: AppFonts.pingFang,
            ),
          ).width;

      return Row(
        children: [
          BohrJournalImage.round(
            name: journalName,
            radius: 14,
            src: journalSrc,
          ),
          const SizedBox(width: 4),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: freeWidth),
            child: BadText(
              journalName,
              color: AppColors.grey10,
              fontWeight: FontWeight.w600,
              fontSize: 12,
              lineHeight: 14,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 4),
          BadText(
            impactFactor,
            color: AppColors.grey10,
            fontSize: 12,
          ),
          const Spacer(),
        ],
      );
    });
  }
}

class BohrJournalImage extends StatelessWidget {
  static AssetImage _fallbackStrategy(String name) {
    return const AssetImage('assets/image/cover0.png');
  }

  final double? width;
  final double? height;

  final double? radius;

  /// 期刊名 - 用于计算默认展位图
  final String name;

  /// 图片地址
  final String src;

  Image get _fallback {
    return Image(
      image: _fallbackStrategy(name),
      width: width,
      height: height,
      fit: radius == null ? BoxFit.contain : BoxFit.cover,
    );
  }

  const BohrJournalImage({
    super.key,
    this.width,
    this.height,
    required this.name,
    required this.src,
  })  : assert(width != null || height != null),
        radius = null;

  const BohrJournalImage.round({
    super.key,
    required double this.radius,
    required this.name,
    required this.src,
  })  : width = radius * 2,
        height = radius * 2;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(44),
      child: Image.network(
        src,
        height: 28,
        width: 28,
        errorBuilder: (context, error, stackTrace) => _fallback,
      ),
    );
  }
}

class PaperTitle extends StatelessWidget {
  /// tight style
  static const _style1 = TextStyle(
    color: AppColors.grey10,
    fontSize: 16,
    fontFamily: AppFonts.merriweather,
    fontWeight: FontWeight.w700,
    height: 22 / 16,
  );

  /// normal style
  static const _style2 = TextStyle(
    color: AppColors.grey10,
    fontSize: 18,
    fontFamily: AppFonts.merriweather,
    fontWeight: FontWeight.w700,
    height: 24 / 18,
  );

  final String source;
  final String translation;
  final int sourceMaxLines;
  final int translationMaxLines;

  final bool tight;

  const PaperTitle({
    super.key,
    required this.source,
    required this.translation,
    this.sourceMaxLines = 6,
    this.translationMaxLines = 4,
  }) : tight = false;

  const PaperTitle.tight({
    super.key,
    required this.source,
    required this.translation,
    this.sourceMaxLines = 4,
    this.translationMaxLines = 2,
  }) : tight = true;

  @override
  Widget build(BuildContext context) {
    final sourceWidget = BadKatex(
      raw: source,
      style: tight ? _style1 : _style2,
      maxLines: sourceMaxLines,
    );

    // if (I18nImpl.isEn || translation.isEmpty) return sourceWidget;

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
