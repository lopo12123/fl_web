import 'dart:js_interop';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bad_fl/bad_fl.dart';
import 'package:fl_web/interop.dart';
import 'package:flutter/material.dart';

class FreeDrawPage extends StatefulWidget {
  const FreeDrawPage({super.key});

  @override
  State<FreeDrawPage> createState() => _FreeDrawPageState();
}

class _FreeDrawPageState extends State<FreeDrawPage> {
  final FreeDrawController fdc = FreeDrawController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FreeDraw'),
        actions: [
          IconButton(
            tooltip: 'Undo All',
            onPressed: () => fdc.undoAll(),
            icon: const Icon(Icons.keyboard_double_arrow_left),
          ),
          IconButton(
            tooltip: 'Undo',
            onPressed: () => fdc.undo(),
            icon: const Icon(Icons.keyboard_arrow_left),
          ),
          IconButton(
            tooltip: 'Take a Image',
            onPressed: () async {
              final image = fdc.toImage();
              final byteData =
                  await image.toByteData(format: ui.ImageByteFormat.png);
              final Uint8List buffer = byteData!.buffer.asUint8List();

              //
              final args = ModalRoute.of(context)!.settings.arguments!
                  as Map<String, String>;
              final serialId = args['serialId'] as String;
              onFreeDrawCaptured(serialId, buffer.toJS);
            },
            icon: const Icon(Icons.camera_alt_outlined),
          ),
          IconButton(
            tooltip: 'Redo',
            onPressed: () => fdc.redo(),
            icon: const Icon(Icons.keyboard_arrow_right),
          ),
          IconButton(
            tooltip: 'Redo All',
            onPressed: () => fdc.redoAll(),
            icon: const Icon(Icons.keyboard_double_arrow_right),
          ),
        ],
      ),
      body: BadFreeDraw(controller: fdc),
    );
  }
}
