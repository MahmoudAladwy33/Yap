import 'package:flutter/widgets.dart';
import 'package:yap/Models/message.dart';

class Chatbuble extends StatelessWidget {
  const Chatbuble({super.key, required this.message});
  final Message message;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          color: Color.fromARGB(255, 210, 210, 210),
        ),
        child: Text(
          message.message,
          style: const TextStyle(
            fontFamily: 'QuickSand',
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
