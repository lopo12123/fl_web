import 'package:fl_web/page/free_draw.dart';
import 'package:fl_web/phantom.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
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
        '/': (context) => const PhantomPage(),
        '/free_draw': (context) => const FreeDrawPage(),
      },
    );
  }
}
