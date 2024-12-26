import 'dart:js_interop';
import 'dart:typed_data';

import 'package:bad_fl/bad_fl.dart';
import 'package:fl_web/interop.dart';
import 'package:flutter/material.dart';

/// Generally there have no view to render to the host element,
/// this page is just a phantom page to provide lifecycle hooks for necessary setup.
class PhantomPage extends StatefulWidget {
  const PhantomPage({super.key});

  @override
  State<PhantomPage> createState() => _PhantomPageState();
}

class _PhantomPageState extends State<PhantomPage> {
  /// delegate of all js call
  ///
  /// optional & nullable args to avoid js call with no args or null/undefined
  void jsCallHandler(String name, String serialId, [JSObject? args]) {
    switch (name) {
      case 'ping':
        final echo = (args?.dartify() ?? {}) as Map;
        echo['@t'] = DateTime.now().millisecondsSinceEpoch;
        onPing(serialId, echo.jsify() as JSObject);
        break;
      case 'share-card':
        print('TODO');
        final bytes = Uint8List.fromList([1, 2, 3, 4]);
        onShareCardGenerated(serialId, bytes.toJS);
        break;
      default:
        print('Unsupport js call: $name');
    }
  }

  @override
  void initState() {
    super.initState();

    print('PhantomPage::initState');
    handleJsCall = jsCallHandler.toJS;
  }

  @override
  void dispose() {
    print('PhantomPage::dispose');

    super.dispose();
  }

  final FreeDrawController fdc = FreeDrawController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      // This list is more for debugging purpose.
      // Please use the imperative form to implement the actual needs.
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              // TODO: navigate to /free_draw with serialId when called from js
              Navigator.pushNamed(
                context,
                '/free_draw',
                arguments: {'serialId': '111'},
              );
            },
            child: const Text('to /free_draw'),
          ),
        ],
      ),
    );
  }
}
