import 'package:flutter/material.dart';

class EaseInWidget extends StatefulWidget {
  final Widget child;
  final Function onTap;
  final Function onLongPress;
  final double borderRadius;

  const EaseInWidget(
      {Key key,
      @required this.child,
      @required this.onTap,
      this.borderRadius,
      this.onLongPress})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _EaseInWidgetState();
}


class _EaseInWidgetState extends State<EaseInWidget>
    with TickerProviderStateMixin<EaseInWidget> {
  AnimationController controller;
  Animation<double> easeInAnimation;

  @override
  void initState() {
    super.initState();
   /* controller = AnimationController(
        vsync:  this,
        duration: Duration(
          milliseconds: 50,
        ),
        value: 1.0);
    easeInAnimation = Tween(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
      ),
    );
    controller.reverse();*/
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius))),
      onPressed: () {
        if (widget.onTap == null) {
          return;
        }
        controller.forward().then((val) {
          controller.reverse().then((val) {
            widget.onTap();
          });
        });
      },
      onLongPress: widget.onLongPress,
      child: ScaleTransition(
        scale: easeInAnimation,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
