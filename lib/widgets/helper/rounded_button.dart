import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({super.key, required this.lable, required this.onTap, this.width = double.infinity, 
  this.height = 50, this.color = Colors.blue , this.textColor = Colors.white, this.borderRadius = 12, this.isUploading = false});

  final String lable;
  final void Function() onTap;
  final double width;
  final double height;
  final Color color;
  final Color textColor;
  final double borderRadius;
  final bool isUploading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
  onTap: onTap,
  child: Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Center(
      child: isUploading ? CircularProgressIndicator()
      :
      Text(
        lable,
        style: TextStyle(
          fontSize: 18,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  ),
)
;
  }
}