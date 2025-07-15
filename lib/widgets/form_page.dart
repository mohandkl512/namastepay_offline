import 'package:flutter/material.dart';

class FormPage extends StatelessWidget {
  const FormPage({
    super.key,
    this.formKey,
    this.title = '',
    this.children = const <Widget>[],
  });

  final String title;
  final Key? formKey;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ),
    );
  }
}
