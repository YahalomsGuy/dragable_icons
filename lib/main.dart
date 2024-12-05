import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: IconsDragAndDrop(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

@immutable
class IconsDragAndDrop extends StatefulWidget {
  const IconsDragAndDrop({super.key});
  @override
  State<IconsDragAndDrop> createState() => _IconsDragAndDropState();
}

class _IconsDragAndDropState extends State<IconsDragAndDrop>
    with TickerProviderStateMixin {
  final GlobalKey dragKey = GlobalKey();
  List<IconItem> baseIconItems = const [
    IconItem(
      name: 'IsItKosher',
      imageProvider: NetworkImage(
          'https://www.yahaloms.com/wp-content/uploads/2024/08/iconTrns.png'),
    ),
    IconItem(
      name: 'Yafit',
      imageProvider: NetworkImage(
          'https://www.yahaloms.com/wp-content/uploads/2024/07/logoIcon.png'),
    ),
    IconItem(
      name: 'YVMS',
      imageProvider: NetworkImage(
          'https://www.yahaloms.com/wp-content/uploads/2024/07/yvmsHebSplash.png'),
    ),
    IconItem(
      name: 'Ococktails',
      imageProvider: NetworkImage(
          'https://www.yahaloms.com/wp-content/uploads/2024/07/owlSplash.png'),
    ),
    IconItem(
      name: 'YRSC',
      imageProvider: NetworkImage(
          'https://www.yahaloms.com/wp-content/uploads/2024/07/yrscEngSplash.png'),
    ),
  ];
  List<IconItem> iconItems = [];
  List<IconItem> targetIconItems = [];

  @override
  void initState() {
    for (var icon in baseIconItems) {
      iconItems.add(icon);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDropped = false;
    return Scaffold(
      backgroundColor: Colors.grey, //const Color(0xFFF7F7F7),
      appBar: appBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              height: 140,
              child: dragTarget(isDropped)),
          SizedBox(
            height: 140,
            child: iconsList(),
          ),
          SizedBox(
            height: 100,
            child: TextButton(
              onPressed: () => initAreas(),
              child: const Text("Rebuild List"),
            ),
          )
        ],
      ),
    );
  }

  /// Functions
  initAreas() {
    iconItems.clear();
    for (var item in baseIconItems) {
      iconItems.add(item);
    }
    targetIconItems.clear();
    setState(() {});
  }

  /// refactored Widgets
  DragTarget<IconItem> dragTarget(bool isDropped) {
    return DragTarget<IconItem>(
      builder: (
        BuildContext context,
        List<dynamic> accepted,
        List<dynamic> rejected,
      ) {
        return Container(
          height: 200,
          width: 200,
          color: isDropped ? Colors.redAccent : null,
          child: targetIconsList(),
        );
      },
      onWillAcceptWithDetails: (data) {
        targetIconItems.add(data.data);
        setState(() {});
        return true;
      },
    );
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      centerTitle: true,
      title: const Text(
        'Draggable Icons',
      ),
      backgroundColor: Colors.grey,
      elevation: 12,
    );
  }

  Widget iconsList() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(30),
      itemCount: iconItems.length,
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 12,
        );
      },
      itemBuilder: (context, index) {
        final item = iconItems[index];
        return iconItem(
          item: item,
        );
      },
    );
  }

  Widget targetIconsList() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(30),
      itemCount: targetIconItems.length,
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 12,
        );
      },
      itemBuilder: (context, index) {
        final item = targetIconItems[index];
        return iconItem(
          item: item,
        );
      },
    );
  }

  Widget iconItem({required IconItem item}) {
    return LongPressDraggable<IconItem>(
      data: item,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: DraggingListItem(
          dragKey: dragKey, photoProvider: item.imageProvider, name: item.name),
      // onDraggableCanceled: (vel, offset) {
      //   iconItems.removeWhere((ic) => item.name == ic.name);
      //   setState(() {});
      // },
      onDragCompleted: () {
        iconItems.removeWhere((ic) => item.name == ic.name);
        setState(() {});
      },
      childWhenDragging: MenuListItem(
        name: item.name,
        photoProvider: item.imageProvider,
        isDepressed: true,
      ),
      child: MenuListItem(
        name: item.name,
        photoProvider: item.imageProvider,
      ),
    );
  }
}

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

/// Item class
@immutable
class IconItem {
  const IconItem({
    required this.name,
    required this.imageProvider,
  });
  final String name;
  final ImageProvider imageProvider;
}
