import 'dart:typed_data';

import 'package:flutter/material.dart';

class PaperCardBuilderPage extends StatefulWidget {
  const PaperCardBuilderPage({super.key});

  @override
  State<PaperCardBuilderPage> createState() => _PaperCardBuilderState();
}

class _PaperCardBuilderState extends State<PaperCardBuilderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ElevatedButton(
            onPressed: () {
              // TODO
              // Navigator.of(context);
              final args = ModalRoute.of(context)?.settings.arguments;
              print('$args');
            },
            child: Text('print received args'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO
              Navigator.of(context)
                  .pop(Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8]));
            },
            child: Text('back with sample data'),
          ),
        ],
      ),
    );
  }
}
