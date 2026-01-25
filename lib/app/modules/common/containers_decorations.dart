import 'package:flutter/material.dart';

Decoration backgroundDecorationSignUp() {
  return const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF1E7044), Color.fromARGB(255, 188, 248, 180)],
    ),
  );
}

Decoration containerDecorationContents() {
  return BoxDecoration(
    color: Colors.white.withOpacity(0.8),
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(40),
      topRight: Radius.circular(40),
    ),
  );
}
