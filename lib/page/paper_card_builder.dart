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
            child: Text('args'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO
              Navigator.of(context).pop(1);
            },
            child: Text('pop'),
          ),
        ],
      ),
    );
  }
}
