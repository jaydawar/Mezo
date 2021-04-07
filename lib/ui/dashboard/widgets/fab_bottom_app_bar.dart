import 'package:app/utils/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FABBottomAppBarItem {
  FABBottomAppBarItem({this.iconPath,this.initialIndex, this.text});

  String iconPath;
  String text;
  int initialIndex;
}

class FABBottomAppBar extends StatefulWidget {
  FABBottomAppBar({
    this.items,

    this.centerItemText,
    this.height: 74.0,
    this.iconSize: 21.0,
    this.backgroundColor,
    this.color,
    this.initialIndex,
    this.selectedColor,
    this.notchedShape,
    this.onTabSelected,
  }) {
    assert(this.items.length == 2 || this.items.length == 4);
  }

  final List<FABBottomAppBarItem> items;
  final String centerItemText;
  final double height;
  final double iconSize;
  final Color backgroundColor;
  final Color color;
  int initialIndex;
   Color selectedColor;
  final NotchedShape notchedShape;
  final ValueChanged<int> onTabSelected;

  @override
  State<StatefulWidget> createState() => FABBottomAppBarState();
}

class FABBottomAppBarState extends State<FABBottomAppBar> {
  int _selectedIndex = 0;

  _updateIndex(int index) {
    widget.onTabSelected(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {

    if(widget.initialIndex!=null){
      _updateIndex(widget.initialIndex);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("initialIndex${widget.initialIndex}");
    List<Widget> items = List.generate(widget.items.length, (int index) {
      return _buildTabItem(
        item: widget.items[index],
        index: index,
        onPressed: _updateIndex,
      );
    });

    return BottomAppBar(
      shape: widget.notchedShape,
      notchMargin: 8.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
      color: widget.backgroundColor,
    );
  }

  Widget _buildTabItem({
    FABBottomAppBarItem item,
    int index,
    ValueChanged<int> onPressed,
  }) {
    Color color = _selectedIndex == index ? widget.selectedColor : widget.color;
    if(widget.initialIndex!=null&&widget.initialIndex==-1){
      widget.selectedColor= ColorResources.bottom_tab_unselected;
    }else{
      widget.selectedColor= ColorResources.bottom_tab_selected;
    }
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(
            right: index == 1 ? 30 : 0, left: index == 2 ? 30.0 : 0),
        height: widget.height,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => onPressed(index),
            child: Center(
              child: SvgPicture.asset(
                item.iconPath,
                color: color,
                height: 21.0,
                width: 21.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
