import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BotMessageBox extends StatelessWidget {
  final String message;
  const BotMessageBox({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: const Color(0xff04395c),
          child: SvgPicture.asset(
            'assets/icons/chatgpt-6.svg',
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcATop),
            width: 30,
            height: 30,
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }
}
