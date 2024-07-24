import 'package:flutter/material.dart';

class GoogleButton extends StatelessWidget {
  GoogleButton({this.onTap, required this.txt});

  final String txt;
  VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        width: 480,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.red,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 30,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                txt,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
