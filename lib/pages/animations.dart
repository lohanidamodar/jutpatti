import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

class LeftToThrow extends StatelessWidget {
  const LeftToThrow({
    Key key,
    @required this.child,
    @required AnimationController controller,
  }) : _controller = controller, super(key: key);

  final Widget child;
  final AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Transform(
      transform: Matrix4.identity()
        ..translate(Vector3(_controller.value*(size.width/2 + 10),size.height/2-30,0))
        ..scale(_controller.value),
      child: child,
    );
  }
}
class ThrowToLeft extends StatelessWidget {
  const ThrowToLeft({
    Key key,
    @required this.child,
    @required AnimationController controller,
  }) : _controller = controller, super(key: key);

  final Widget child;
  final AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Transform(
      transform: Matrix4.identity()
        ..translate(Vector3((1-_controller.value)*(size.width/2+10),size.height/2-30,0))
        ..scale(1-_controller.value),
      child: child,
    );
  }
}
class DeckToLeft extends StatelessWidget {
  const DeckToLeft({
    Key key,
    @required this.child,
    @required AnimationController controller,
  }) : _controller = controller, super(key: key);

  final Widget child;
  final AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Transform(
      transform: Matrix4.identity()
        ..translate(Vector3((1-_controller.value)*(size.width/2-80),size.height/2-30,0))
        ..scale(1-_controller.value),
      child: child,
    );
  }
}


class RightToThrow extends StatelessWidget {
  const RightToThrow({
    Key key,
    @required this.child,
    @required AnimationController controller,
  }) : _controller = controller, super(key: key);

  final Widget child;
  final AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Transform(
      transform: Matrix4.identity()
        ..translate(Vector3(size.width - _controller.value*(size.width/2 + 10),size.height/2-30,0))
        ..scale(_controller.value),
      child: child,
    );
  }
}
class ThrowToRight extends StatelessWidget {
  const ThrowToRight({
    Key key,
    @required this.child,
    @required AnimationController controller,
  }) : _controller = controller, super(key: key);

  final Widget child;
  final AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Transform(
      transform: Matrix4.identity()
        ..translate(Vector3(size.width - (1-_controller.value)*(size.width/2+10),size.height/2-30,0))
        ..scale(1-_controller.value),
      child: child,
    );
  }
}
class DeckToRight extends StatelessWidget {
  const DeckToRight({
    Key key,
    @required this.child,
    @required AnimationController controller,
  }) : _controller = controller, super(key: key);

  final Widget child;
  final AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Transform(
      transform: Matrix4.identity()
        ..translate(Vector3(size.width - (1-_controller.value)*(size.width/2-80),size.height/2-30,0))
        ..scale(1-_controller.value),
      child: child,
    );
  }
}

class TopToThrow extends StatelessWidget {
  const TopToThrow({
    Key key,
    @required this.child,
    @required AnimationController controller,
  }) : _controller = controller, super(key: key);

  final Widget child;
  final AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Transform(
      transform: Matrix4.identity()
        ..translate(Vector3(size.width/2 + 10,_controller.value * size.height/2-30,0))
        ..scale(_controller.value),
      child: child,
    );
  }
}
class ThrowToTop extends StatelessWidget {
  const ThrowToTop({
    Key key,
    @required this.child,
    @required AnimationController controller,
  }) : _controller = controller, super(key: key);

  final Widget child;
  final AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Transform(
      transform: Matrix4.identity()
        ..translate(Vector3(size.width/2+10,(1-_controller.value)* (size.height/2-30),0))
        ..scale(1-_controller.value),
      child: child,
    );
  }
}
class DeckToTop extends StatelessWidget {
  const DeckToTop({
    Key key,
    @required this.child,
    @required AnimationController controller,
  }) : _controller = controller, super(key: key);

  final Widget child;
  final AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Transform(
      transform: Matrix4.identity()
        ..translate(Vector3(size.width/2-80,(1-_controller.value)* size.height/2-30,0))
        ..scale(1-_controller.value),
      child: child,
    );
  }
}
