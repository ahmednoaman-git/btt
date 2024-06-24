import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ChatBackground extends StatelessWidget {
  const ChatBackground({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/chatgpt-6.svg',
          colorFilter: const ColorFilter.mode(
            Colors.white,
            BlendMode.srcATop,
          ),
          width: 200,
          height: 200,
        ),
        const SizedBox(height: 10),
        const Text(
          'How can I help you?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
