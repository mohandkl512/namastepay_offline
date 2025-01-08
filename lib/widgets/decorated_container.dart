import 'package:flutter/material.dart';
import '../theme/app_decoration.dart';

class DecoratedContainer extends StatelessWidget {
  final Widget widget;

  const DecoratedContainer({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 16,
        ),
        Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade100,
            borderRadius: BorderRadiusStyle.roundedBorder10,
          ),
          child: Padding(padding: const EdgeInsets.all(28), child: widget),
        )
      ],
    );
  }
}
