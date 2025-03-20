import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:typed_data';

import 'package:fl_web/impl.dart';
import 'package:fl_web/log.dart';
import 'package:flutter/material.dart';

/// Register a method on the global context to call the method on the dart side from the js side.
@JS('@fl.invokeMethod')
external set invokeDart(JSFunction f);

/// A simple guard:
/// - Make sure `'@fl'` exists in the global context and is a [JSObject],
/// - If not (does not exist or is not a [JSObject]), set it to an empty object (`{}` in js).
void guard() {
  final r = globalContext['@fl'].isA<JSObject>();
  if (!r) globalContext['@fl'] = JSObject();
}

void main() {
  guard();

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
  /// Delegate all js call here.
  ///
  /// Declare [args] as optional & nullable to avoid js call with no args or `null`/`undefined`.
  void callFromJs(String name, String serialId, [JSAny? args]) {
    switch (name) {
      case 'echo':
        Echo(serialId).ok(args);
        break;
      case 'paper':
        Paper(serialId).ok(Uint8List(0).toJS);
        break;
      default:
        LogImpl.warn('Unsupported channel name "$name" (serial id: $serialId)');
    }
  }

  @override
  void initState() {
    super.initState();

    invokeDart = callFromJs.toJS;
    LogImpl.log('initialized');

    const Ready().ok(null);
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
