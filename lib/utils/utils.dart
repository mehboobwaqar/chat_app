import 'package:flutter/material.dart';

class Utils {
  
  static snackBar(String message, BuildContext context){

return ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    behavior: SnackBarBehavior.floating,
    elevation: 8,
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    backgroundColor: Colors.transparent, // 👈 Transparent for gradient
    duration: const Duration(seconds: 3),
    content: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff4dabf7), Color(0xff1b89e2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.emoji_emotions, color: Colors.white, size: 26), // 🐼 Cute icon
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ),
  ),
);


  }
}