import 'package:flutter/material.dart';
import 'package:test/components/product/product_card.dart';
import 'package:test/models/product_model.dart';

import '../../../../constants.dart';
import '../../../../route/route_constants.dart';
import 'package:test/main.dart';

class TestForm extends StatefulWidget {
  const TestForm({super.key});

  @override
  _TestFormState createState() => _TestFormState();
}

class _TestFormState extends State<TestForm> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: defaultPadding / 2),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            "Access Token",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: GL_access_token,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
