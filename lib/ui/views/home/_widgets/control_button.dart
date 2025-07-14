import 'package:flutter/material.dart';

class ControlButton extends StatelessWidget {
  final Image image;
  final bool isLarge;
  final VoidCallback? onTap;

  const ControlButton({
    Key? key,
    required this.image,
    this.isLarge = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(isLarge ? 20 : 15),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isLarge ? Colors.white : Colors.grey.shade800,
        ),
        child: image,
      ),
    );
  }
}
