import 'package:dragable_icons/widgets/dragging_list_item.dart';
import 'package:dragable_icons/widgets/menu_list_item.dart';
import 'package:flutter/material.dart';

import '../model/iconItem.dart';

class IconsDragAndDropScreen extends StatefulWidget {
  const IconsDragAndDropScreen({super.key});
  @override
  State<IconsDragAndDropScreen> createState() => _IconsDragAndDropScreenState();
}

class _IconsDragAndDropScreenState extends State<IconsDragAndDropScreen>
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey, //const Color(0xFFF7F7F7),
      appBar: appBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: size.width,
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
