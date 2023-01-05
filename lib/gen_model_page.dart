import 'package:flutter/material.dart';

class GenModelPage extends StatefulWidget {
  GenModelPage({
    Key? key,
  }) : super(key: key);

  @override
  State<GenModelPage> createState() => _GenModelPageState();
}

class _GenModelPageState extends State<GenModelPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text('GenModelPage'),
        ],
      ),
    );
  }
}
