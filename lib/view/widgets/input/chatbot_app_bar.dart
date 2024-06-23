import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ChatBotAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatBotAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: SvgPicture.asset('assets/bus.svg'),
          ),
        ),
        title: const Text(
          'Bus Bot',
          style: TextStyle(
            color: Colors.white60,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
