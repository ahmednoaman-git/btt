import 'package:btt/view/widgets/input/chatbot_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../providers/message_provider.dart';
import 'components/bot_message_box.dart';
import 'components/chat_text_field.dart';
import 'components/user_message_box.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final List<String> messages = context.watch<MessageProvider>().messages;
    return SafeArea(
      child: Scaffold(
        appBar: const ChatBotAppBar(),
        backgroundColor: Colors.white10,
        body: Padding(
          padding: const EdgeInsets.only(bottom: 15, right: 15, left: 15),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: SingleChildScrollView(
                    controller: context.read<MessageProvider>().scrollController,
                    child: Column(
                      children: [
                        for (var i = 0; i < messages.length; i++) ...[
                          if (messages[i].length < 2)
                            UserMessageBox(message: messages[i])
                                .animate()
                                .fade(duration: const Duration(milliseconds: 100))
                                .slideY(duration: const Duration(milliseconds: 100), begin: 0.5, end: 0)
                          else
                            (messages[i].substring(0, 2) == 'b%')
                                ? BotMessageBox(message: messages[i].substring(2)).animate().fade(duration: const Duration(milliseconds: 100)).slideY(
                                      duration: const Duration(milliseconds: 100),
                                      begin: 0.5,
                                      end: 0,
                                    )
                                : UserMessageBox(message: messages[i]).animate().fade(duration: const Duration(milliseconds: 100)).slideY(
                                      duration: const Duration(milliseconds: 100),
                                      begin: 0.5,
                                      end: 0,
                                    ),
                          const SizedBox(height: 20),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              // Expanded(
              //   child: ChatBackground(),
              // ),
              const ChatTextField(),
            ],
          ),
        ),
      ),
    );
  }
}
