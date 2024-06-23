import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../providers/message_provider.dart';
import '../../../../services/chat_services.dart';

class ChatTextField extends StatefulWidget {
  const ChatTextField({
    super.key,
  });

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  late final TextEditingController ctrl;
  Future<Response>? replyMessage;

  @override
  void initState() {
    super.initState();
    ctrl = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final scrollController = context.read<MessageProvider>().scrollController;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/chatgpt-6.svg',
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcATop),
            width: 35,
            height: 35,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextField(
              controller: ctrl,
              textAlignVertical: TextAlignVertical.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              decoration: const InputDecoration(
                hintText: 'What do you want to talk about?',
                hintStyle: TextStyle(
                  color: Colors.white60,
                  fontSize: 16,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (ctrl.text.isEmpty) return;
              context.read<MessageProvider>().addMessage(ctrl.text);
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                scrollController.animateTo(
                  scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInExpo,
                );
              });
              setState(() {
                replyMessage = ChatServices.sendAndRecieveMessage(ctrl.text);
              });
              replyMessage?.then((message) {
                final String reply = message.data['results'][0]['generated_text'];
                context.read<MessageProvider>().addMessage('b%$reply');
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  scrollController.animateTo(
                    scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInExpo,
                  );
                });
              });

              ctrl.clear();
            },
            child: CircleAvatar(
              backgroundColor: const Color(0xff04395c),
              child: FutureBuilder<Response>(
                  future: replyMessage,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(snapshot.error.toString())));
                      }
                    }
                    return const Icon(
                      Icons.send_outlined,
                      size: 24,
                      color: Colors.white,
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }
}
