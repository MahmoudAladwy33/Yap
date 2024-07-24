import 'package:flutter/material.dart';
import 'package:yap/Models/message.dart';

class Chatbublefriend extends StatelessWidget {
  const Chatbublefriend({super.key, required this.message});
  final Message message;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
          color: Color(0xffc476f5),
        ),
        child: Text(
          message.message,
          style: const TextStyle(
            fontFamily: 'QuickSand',
            fontSize: 15,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
