import 'package:flutter/material.dart';

class MenuListItem extends StatelessWidget {
  const MenuListItem({
    super.key,
    this.name = '',
    required this.photoProvider,
    this.isDepressed = false,
    this.size = 80,
  });

  final String name;
  final ImageProvider photoProvider;
  final bool isDepressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 12,
      //borderRadius: BorderRadius.circular(20),
      child: Container(
        color: Colors.transparent,
        width: 80,
        height: 100,
        padding: const EdgeInsets.all(10),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
            height: isDepressed ? size / 2 : size,
            width: isDepressed ? size / 2 : size,
            child: Image(
              image: photoProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
