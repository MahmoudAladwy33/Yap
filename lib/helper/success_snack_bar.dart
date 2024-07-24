import 'package:flutter/material.dart';

void successSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      backgroundColor: Colors.white,
      content: Text(
        'Success',
        style: TextStyle(
          fontFamily: 'QuickSand',
          fontWeight: FontWeight.bold,
          color: Colors.purple,
        ),
      ),
    ),
  );
}
