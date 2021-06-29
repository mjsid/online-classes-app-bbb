import 'package:flutter/material.dart';

class StaggerAnimation extends StatelessWidget {
  final VoidCallback onTap;
  final String titleButton;
  final double width;
  final Color color;

  StaggerAnimation(
      {Key key,
      this.buttonController,
      this.onTap,
      this.titleButton,
      this.color,
      this.width = 220})
      : buttonSqueezeanimation = Tween(
          begin: width,
          end: 50.0,
        ).animate(
          CurvedAnimation(
            parent: buttonController,
            curve: Interval(
              0.0,
              0.150,
            ),
          ),
        ),
        containerCircleAnimation = EdgeInsetsTween(
          begin: const EdgeInsets.only(bottom: 30.0),
          end: const EdgeInsets.only(bottom: 0.0),
        ).animate(
          CurvedAnimation(
            parent: buttonController,
            curve: Interval(
              0.500,
              0.800,
              curve: Curves.ease,
            ),
          ),
        ),
        super(key: key);

  final AnimationController buttonController;
  final Animation<EdgeInsets> containerCircleAnimation;
  final Animation buttonSqueezeanimation;

  Widget _buildAnimation(BuildContext context, Widget child) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: buttonSqueezeanimation.value,
        height: 50,
        alignment: FractionalOffset.center,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black38,
                blurRadius: 5.0, // soften the shadow
                spreadRadius: 0.8, //extend the shadow
                offset: Offset(
                  3.0, // Move to right 10  horizontally
                  3.0, // Move to bottom 10 Vertically
                ))
          ],
          color: color,
          borderRadius: BorderRadius.all(const Radius.circular(25.0)),
        ),
        child: buttonSqueezeanimation.value > 75.0
            ? Text(
                titleButton,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              )
            : CircularProgressIndicator(
                value: null,
                strokeWidth: 1.0,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: buttonController,
    );
  }
}
