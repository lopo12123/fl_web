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
            onPressed: () async {
              final r = await Navigator.of(context).pushNamed(
                'paper-card-builder',
                arguments: {'name': 'aaa'},
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
