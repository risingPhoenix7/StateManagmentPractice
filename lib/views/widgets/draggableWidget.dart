import 'package:flutter/material.dart';

class DraggableWidget extends StatefulWidget {
  DraggableWidget({Key? key, required this.child, required this.onSwipe})
      : super(key: key);
  Widget child;
  Function onSwipe;

  @override
  _DraggableWidgetState createState() => _DraggableWidgetState();
}

class _DraggableWidgetState extends State<DraggableWidget> {
  double swipeThreshold = 50.0;
  double _dragDistance = 0.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final maxDragDistance =
          MediaQuery.of(context).size.width - constraints.maxWidth + 100;

      return GestureDetector(
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          if (details.delta.dx > 0) {
            // Check if the swipe is from left to right
            setState(() {
              _dragDistance += details.delta.dx;
              if (_dragDistance > maxDragDistance) {
                // Check if the swipe is within the limit
                _dragDistance = maxDragDistance;
              }
            });
          }
        },
        onHorizontalDragEnd: (DragEndDetails details) {
          if (_dragDistance > swipeThreshold) {
            widget.onSwipe();
          }

          // Reset the drag distance
          setState(() {
            _dragDistance = 0.0;
          });
        },
        child: Transform.translate(
          offset: Offset(_dragDistance, 0),
          child: widget.child,
        ),
      );
    });
  }
}
