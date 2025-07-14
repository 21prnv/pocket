import 'package:flutter/material.dart';

class MiniControlButton extends StatelessWidget {
  final Image image;
  final Color color;
  final bool isLarge;
  final VoidCallback? onTap;

  const MiniControlButton({
    Key? key,
    required this.image,
    required this.color,
    this.isLarge = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(isLarge ? 12 : 8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: image,
      ),
    );
  }
}
