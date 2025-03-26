import 'dart:async';
import 'dart:ui' as ui;
import 'package:bad_fl/bad_fl.dart';
import 'package:fl_web/log.dart';
import 'package:fl_web/page/paper/color.dart';
import 'package:fl_web/page/paper/prefab.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'paper/model.dart';

class PaperCardBuilderPage extends StatefulWidget {
  const PaperCardBuilderPage({super.key});

  @override
  State<PaperCardBuilderPage> createState() => _PaperCardBuilderState();
}

class _PaperCardBuilderState extends State<PaperCardBuilderPage> {
  final _cc = CaptureController();
  late SharePaperDTO _shareInfo;
  late ImageProvider _avatarImage;
  late ImageProvider _publishImage;
  bool _isChinese = false;
  bool _showAiSum = false;

  get scientistStr => _isChinese ? '科学家' : 'Scientist';

  get sharePaperStr => _isChinese ? '分享了一篇文献' : 'Shared a literature article';

  get scanStr => _isChinese ? '扫一扫\n查看文献详情' : 'Scan\nView Document\nDetails';

  get researchDirectionStr => _isChinese ? '研究方向' : 'Research Direction';

  get sumStr => _isChinese ? '总结' : 'Summary';

  get introductionStr => _isChinese ? '简介' : 'Introduction';

  get referenceStr => _isChinese ? '摘要' : 'Abstract';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    LogImpl.log('args is$args');
    if (args != null && args is Map) {
      _shareInfo = SharePaperDTO.fromJson(Map<String, dynamic>.from(args));
      _isChinese = _shareInfo.languageType == 0;
      _showAiSum = _shareInfo.summary.isNotEmpty;
      _showAiSum = true;
    }
  }

  Future<Uint8List> get u8list async {
    final image = _cc.capture(4);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List buffer = byteData!.buffer.asUint8List();
    return buffer;
  }

  Future<bool> _loadAvatar() async {
    try {
      final completer = Completer<ImageInfo>();
      _avatarImage = NetworkImage(_shareInfo.avatarUrl);
      _avatarImage.resolve(const ImageConfiguration()).addListener(
            ImageStreamListener((info, _) {
              completer.complete(info);
            }, onError: (exception, stackTrace) {
              completer.completeError(exception, stackTrace);
            }),
          );
      await completer.future;
      return true;
    } catch (e) {
      LogImpl.error('Failed to load avatar $e');
      return false;
    }
  }

  Future<bool> _loadPublicationCover() async {
    try {
      final completer = Completer<ImageInfo>();
      _publishImage = NetworkImage(_shareInfo.publicationCover);
      _publishImage.resolve(const ImageConfiguration()).addListener(
            ImageStreamListener((info, _) {
              completer.complete(info);
            }, onError: (exception, stackTrace) {
              completer.completeError(exception, stackTrace);
            }),
          );
      await completer.future;
      return true;
    } catch (e) {
      LogImpl.error('Failed to load publication cover: $e');
      return false;
    }
  }

  List<Widget> _buildAiSumOrAbstract() {
    return _showAiSum
        ? [
            BadText(
              researchDirectionStr,
              fontWeight: FontWeight.w500,
              color: AppColors.grey10,
              fontSize: 14,
            ),
            const SizedBox(height: 8),
            BadText(
              _shareInfo.summary,
              fontWeight: FontWeight.w400,
              color: AppColors.grey10,
              fontSize: 14,
              maxLines: 5,
              lineHeight: 20,
            ),
            const SizedBox(height: 16),
            if (_showAiSum)
              BadText(
                introductionStr,
                fontWeight: FontWeight.w500,
                color: AppColors.grey10,
                fontSize: 13,
              ),
            if (_shareInfo.introduction.isNotEmpty) const SizedBox(height: 8),
            if (_shareInfo.introduction.isNotEmpty)
              BadText(
                _shareInfo.introduction,
                fontWeight: FontWeight.w400,
                color: AppColors.grey10,
                fontSize: 14,
                maxLines: 9,
                lineHeight: 20,
              ),
          ]
        : [
            BadText(
              _isChinese ? _shareInfo.zhAbstract : _shareInfo.enAbstract,
              fontWeight: FontWeight.w400,
              maxLines: 10,
              fontSize: 14,
              lineHeight: 20,
            ),
          ];
  }

  Widget _buildColumn() {
    return Column(
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(44),
              child: Image(
                image: _avatarImage,
                height: 36,
                width: 36,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/image/avatar_holder.png',
                  width: 36,
                  height: 36,
                  isAntiAlias: true,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        left: 4,
                        right: 4,
                        top: 3,
                        bottom: 3,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xff6e72ea),
                            Color(0xff292b64),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: BadText(
                        scientistStr,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(width: 4),
                    BadText(
                      _shareInfo.userName,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: AppColors.themeBlue,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                BadText(
                  sharePaperStr,
                  fontWeight: FontWeight.w400,
                  fontSize: 11,
                  color: const Color(0xff8689a6),
                )
              ],
            )
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(top: 24, bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(builder: (_, constraints) {
                return Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(44),
                      child: Image(
                        image: _publishImage,
                        height: 28,
                        width: 28,
                        errorBuilder: (context, error, stackTrace) =>
                            const Image(
                          image: AssetImage('assets/image/cover0.png'),
                          width: 28,
                          height: 28,
                          isAntiAlias: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: BadText(
                        _shareInfo.publicationEnName,
                        color: AppColors.grey10,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        lineHeight: 14,
                        maxLines: 1,
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 16),
              PaperStatistic(
                date: _shareInfo.coverDateStart,
                popularity: _shareInfo.popularity,
                cite: _shareInfo.citationNums,
              ),
              const SizedBox(height: 16),
              PaperTitle(
                source: _shareInfo.enName,
                translation: _shareInfo.zhName,
              ),
              const SizedBox(height: 16),
              if (_shareInfo.authors.isNotEmpty) AuthorFragment(_shareInfo),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(
                        height: 1,
                        color: AppColors.grey3,
                      ),
                    ),
                    const SizedBox(width: 16),
                    if (_showAiSum)
                      Image.asset(
                        'assets/image/ai.png',
                        width: 14,
                        height: 14,
                      ),
                    if (_showAiSum) const SizedBox(width: 1),
                    BadText(
                      _showAiSum ? sumStr : referenceStr,
                      fontSize: 13,
                      lineHeight: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey3,
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      flex: 1,
                      child: Container(
                        height: 1,
                        color: AppColors.grey3,
                      ),
                    ),
                  ],
                ),
              ),
              ..._buildAiSumOrAbstract()
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              _isChinese
                  ? 'assets/image/logo_zh.png'
                  : 'assets/image/logo_en.png',
              height: 28,
              isAntiAlias: true,
            ),
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  margin: const EdgeInsets.only(right: 8),
                  color: Colors.blue,
                  child: Image.asset(
                    'assets/image/bohrium_wx.png',
                    width: 56,
                    height: 56,
                  ),
                ),
                BadText(
                  scanStr,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff4e5969),
                  fontSize: 12,
                  lineHeight: 18,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  void _onReady() async {
    // Navigator.of(context).pop(await u8list);
    LogImpl.log('ready to capture');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Future.wait([_loadAvatar(), _loadPublicationCover()]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            _onReady();
          }

          return ListView(
            children: [
              UnconstrainedBox(
                child: BadCapture(
                  controller: _cc,
                  child: Container(
                    width: 375,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xffe5eafb),
                          Color(0xffa8c4f5),
                          Color(0xffe6ecfe),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 24,
                      bottom: 24,
                    ),
                    child: _buildColumn(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
