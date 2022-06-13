import 'package:flutter/material.dart';

import '../Homepage/bottom_nav_bar.dart';
import 'chat_page.dart';

class ChatMain extends StatelessWidget {
  const ChatMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatPage(),
    return Container(
      child: Center(
        child: Text(
          "Chat page",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
