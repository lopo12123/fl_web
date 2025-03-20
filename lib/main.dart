import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:typed_data';

import 'package:fl_web/impl.dart';
import 'package:flutter/material.dart';

void main() {
  FlWebImpl.guard();

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
      home: const PhantomPage(),
    );
  }
}

/// Generally there have no view to render to the host element,
/// this page is just a phantom page to provide lifecycle hooks for necessary setup.
class PhantomPage extends StatefulWidget {
  const PhantomPage({super.key});

  @override
  State<PhantomPage> createState() => _PhantomPageState();
}

class _PhantomPageState extends State<PhantomPage> {
  void jsRequestHandler(JSRequest request) async {
    switch (request) {
      case EchoRequest():
        request.success(request.argument);
        break;
      case PaperRequest():
        request.success(Uint8List(0).toJS);
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
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              final bridge = globalContext['@fl'].isA<JSObject>();
              print(bridge);
            },
            child: const Text('to /free_draw'),
          ),
          ElevatedButton(
            onPressed: () {
              // globalContext['@fl'] = <String, String>{}.jsify();
              globalContext['@fl'] = JSObject();
              //
            },
            child: const Text('init'),
          ),
        ],
      ),
    );
  }
}
