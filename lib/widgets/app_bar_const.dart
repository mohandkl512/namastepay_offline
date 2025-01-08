import 'package:flutter/material.dart';

class AppBarConstant extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppBarConstant({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_outlined,
              size: 30,
            )),
      ),
      title: Text(
        title,
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
