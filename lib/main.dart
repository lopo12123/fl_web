import 'package:fl_web/impl.dart';
import 'package:fl_web/page/paper_card_builder.dart';
import 'package:fl_web/page/phantom_root.dart';
import 'package:fl_web/wrapper.dart';
import 'package:flutter/material.dart';

void main() {
  FlWebImpl.guard();

  // runApp(const MyApp());
  runWidget(MultiViewApp(viewBuilder: (BuildContext context) => const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlWeb',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      routes: {
        'paper-card-builder': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          // return const PaperCardBuilderPage();
          return Text('xxx');
        },
      },
      home: const PhantomRootPage(),
    );
  }
}
