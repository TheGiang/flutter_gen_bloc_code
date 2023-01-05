import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  const InputWidget({
    required this.title,
    this.hint,
    required this.controller,
    Key? key,
  }) : super(key: key);

  final String title;
  final String? hint;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: Text(title)),
        const SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(hintText: hint),
          ),
        ),
      ],
    );
  }
}
