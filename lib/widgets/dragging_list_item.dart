import 'package:flutter/material.dart';

class DraggingListItem extends StatelessWidget {
  const DraggingListItem(
      {super.key,
      required this.dragKey,
      required this.photoProvider,
      required this.name});

  final GlobalKey dragKey;
  final ImageProvider photoProvider;
  final String name;

  @override
  Widget build(BuildContext context) {
    return FractionalTranslation(
      translation: const Offset(-0.5, -0.5),
      child: Column(
        children: [
          ClipRRect(
            key: dragKey,
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 100,
              width: 80,
              child: Opacity(
                opacity: 0.85,
                child: Image(
                  image: photoProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
