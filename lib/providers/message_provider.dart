import 'package:flutter/material.dart';

class MessageProvider extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  final List<String> messages = [];

  void addMessage(String message) {
    messages.add(message);
    notifyListeners();
  }

  void clear() {
    messages.clear();
    notifyListeners();
  }
}
