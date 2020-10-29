import 'package:flutter/material.dart';

class SemiRoundedBorderButton extends StatelessWidget {
  final BorderSide borderSide;
  final Radius radius;
  final Color background;
  final Widget child;

  const SemiRoundedBorderButton({
    Key key,
    @required this.borderSide,
    @required this.radius,
    @required this.background,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ClipRect(
      //clipper: new SemiRoundedBorderClipper(borderSide.width + 1.0),
      child: new DecoratedBox(
        decoration: new ShapeDecoration(
          color: background,
          shape: new RoundedRectangleBorder(
            side: borderSide,
            borderRadius: new BorderRadius.only(
              topRight: radius,
              bottomRight: radius,
            ),
          ),
        ),
        child: child,
      ),
    );
  }
}

class SemiRoundedBorderClipper extends CustomClipper<Rect> {
  final double borderStrokeWidth;

  const SemiRoundedBorderClipper(this.borderStrokeWidth);

  @override
  Rect getClip(Size size) {
    return new Rect.fromLTRB(0.0, 0.0, size.width, size.height - borderStrokeWidth);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    if (oldClipper.runtimeType != SemiRoundedBorderClipper) return true;
    return (oldClipper as SemiRoundedBorderClipper).borderStrokeWidth != borderStrokeWidth;
  }
}