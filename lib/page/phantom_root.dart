import 'dart:js_interop';
import 'dart:typed_data';

import 'package:fl_web/impl.dart';
import 'package:flutter/material.dart';

/// Generally there have no view to render to the host element,
/// this page is just a phantom page to provide lifecycle hooks for necessary setup.
class PhantomRootPage extends StatefulWidget {
  const PhantomRootPage({super.key});

  @override
  State<PhantomRootPage> createState() => _PhantomRootPageState();
}

class _PhantomRootPageState extends State<PhantomRootPage> {
  void jsRequestHandler(JSRequest request) async {
    switch (request) {
      case EchoRequest():
        request.success(request.argument);
        break;
      case PaperRequest():
        final buffer = (
          await Navigator.of(context).pushNamed(
            'paper-card-builder',
            arguments: request.argument,
          ),
        ) as Uint8List?;
        if (buffer == null) {
          request.fail('No data');
        } else {
          request.success(buffer.toJS);
        }
        break;
    }
  }

  @override
  void initState() {
    super.initState();

    FlWebImpl.initialize(jsRequestHandler);
  }

  @override
  Widget build(BuildContext context) {
    final testMap = {
      'userName': 'imfondof',
      'avatarUrl':
          'https://dp-storage-test2.oss-cn-zhangjiakou.aliyuncs.com/bohrium-test/article/112233/0cea4efc22204a26ad03a0c774d4ba38/9f1a57df-5192-4475-9a6a-1ac913752cfd.jpg',
      'publicationEnName':
          'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
      'publicationCover': 'https://example.com/cover.jpg',
      'enName':
          'Example Paper TitleExample Paper TitleExample Paper TitleExample Paper TitleExample Paper TitleExample Paper TitleExample Paper TitleExample Paper TitleExample Paper TitleExample Paper TitleExample Paper Title',
      'zhName':
          '示例论文标题示例论文标题示例论文标题示例论文标题示例论文标题示例论文标题示例论文标题示例论文标题示例论文标题示例论文标题示例论文标题示例论文标题示例论文标题示例论文标题示例论文标题示例论文标题示例论文标题示例论文标题示例论文标题示例论文标题',
      'enAbstract': 'This is an example abstract in English.',
      'zhAbstract':
          '这是中文的示例摘要。这是中文的示例摘要。这是中文的示例摘要。这是中文的示例摘要。这是中文的示例摘要。这是中文的示例摘要。这是中文的示例摘要。这是中文的示例摘要。这是中文的示例摘要。这是中文的示例摘要。这是中文的示例摘要。这是中文的示例摘要。这是中文的示例摘要。这是中文的示例摘要。这是中文的示例摘要。这是中文的示例摘要。这是中文的示例摘要。这是中文的示例摘要。这是中文的示例摘要。',
      'authors': ['Author One', 'Author Two', 'Author Two'],
      'coverDateStart': '2023-01-01',
      'impactFactor': 3.5,
      'citationNums': 42,
      'popularity': 100,
      'summary': 'summary/summary',
      'introduction': 'introduction.introduction',
    };

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () async {
              final r = await Navigator.of(context).pushNamed(
                'paper-card-builder',
                arguments: testMap,
              );
              print('r: $r');
            },
            child: const Text('xxx'),
          ),
        ],
      ),
    );
  }
}
