import 'dart:math';

import 'package:flutter/material.dart';
import '../models/card.dart';

enum Position { LEFT, RIGHT, BOTTOM, TOP }

class TransformedCard extends StatelessWidget {
  final PlayingCard playingCard;
  final double transformDistance;
  final int transformIndex;
  final int transformAxis;
  final Position position;

  TransformedCard({
    @required this.playingCard,
    this.transformDistance = 25.0,
    this.transformIndex = 0,
    this.transformAxis = 0,
    this.position = Position.BOTTOM,
  });

  @override
  Widget build(BuildContext context) {
    return TransformCard(
      transformAxis: transformAxis,
      transformDistance: transformDistance,
      position: position,
      transformIndex: transformIndex,
      child: PlayingCardUi(
        playingCard: playingCard,
        position: position,
      ),
    );
  }
}

class TransformCard extends StatelessWidget {
  final double transformDistance;
  final int transformIndex;
  final int transformAxis;
  final Position position;
  final Widget child;

  TransformCard({
    this.transformDistance = 25.0,
    this.transformIndex = 0,
    this.transformAxis = 0,
    this.position = Position.BOTTOM,
    this.child
  });

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..translate(
          transformAxis == 0 ? -transformIndex * transformDistance : 0.0,
          transformAxis == 1 ? -transformIndex * transformDistance : 0.0,
          transformAxis == 2 ? -transformIndex * transformDistance : 0.0,
        ),
      child: child,
    );
  }
}

class DraggableCard extends StatelessWidget {
  final PlayingCard playingCard;
  final Map<String, dynamic> dragData;
  final int maxDrags;
  final Function onDragStart;

  DraggableCard(
      {@required this.playingCard,
      this.maxDrags = 1,
      this.onDragStart,
      this.dragData});

  @override
  Widget build(BuildContext context) {
    return _buildCard();
  }

  Widget _buildCard() {
    return Draggable(
      onDragStarted: onDragStart,
      maxSimultaneousDrags: maxDrags,
      data: dragData,
      child: PlayingCardUi(playingCard: playingCard),
      feedback: PlayingCardUi(playingCard: playingCard,),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: PlayingCardUi(playingCard: playingCard,),
      ),
    );
  }
}

class BottomCard extends StatelessWidget {
  const BottomCard({
    Key key,
    @required this.playingCard,
  }) : super(key: key);

  final PlayingCard playingCard;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: Container(
            height: playingCard.cardSuit == CardSuit.diamonds ? 60 : 50.0,
            child: _suitToImage(playingCard),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  _cardTypeToString(playingCard),
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: _suitToColor(playingCard)),
                ),
                Container(
                  height: playingCard.cardSuit == CardSuit.diamonds ? 18 : 12.0,
                  child: _suitToImage(playingCard),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class TopCard extends StatelessWidget {
  const TopCard({
    Key key,
    @required this.playingCard,
  }) : super(key: key);

  final PlayingCard playingCard;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: Container(
            height: playingCard.cardSuit == CardSuit.diamonds ? 60 : 50.0,
            child:
                Transform.rotate(angle: pi, child: _suitToImage(playingCard)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 10.0,
                  child: _suitToImage(playingCard),
                ),
                Transform.rotate(
                  angle: 3.14,
                  child: Text(
                    _cardTypeToString(playingCard),
                    style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: _suitToColor(playingCard)),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class LeftCard extends StatelessWidget {
  const LeftCard({
    Key key,
    @required this.playingCard,
  }) : super(key: key);

  final PlayingCard playingCard;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: Container(
            height: playingCard.cardSuit == CardSuit.diamonds ? 60 : 50.0,
            child: Transform.rotate(
                angle: pi,
                child: Transform.rotate(
                    angle: -pi / 2, child: _suitToImage(playingCard))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Align(
            alignment: Alignment.topRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 10.0,
                  child: Transform.rotate(
                      angle: pi / 2, child: _suitToImage(playingCard)),
                ),
                Transform.rotate(
                  angle: pi / 2,
                  child: Text(
                    _cardTypeToString(playingCard),
                    style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: _suitToColor(playingCard)),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class RightCard extends StatelessWidget {
  const RightCard({
    Key key,
    @required this.playingCard,
  }) : super(key: key);

  final PlayingCard playingCard;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: Container(
            height: playingCard.cardSuit == CardSuit.diamonds ? 60 : 50.0,
            child: Transform.rotate(
                angle: pi,
                child: Transform.rotate(
                    angle: pi / 2, child: _suitToImage(playingCard))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                  child: Transform.rotate(
                    angle: -3.14 / 2,
                    child: Text(
                      _cardTypeToString(playingCard),
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: _suitToColor(playingCard)),
                    ),
                  ),
                ),
                Container(
                  height: 12.0,
                  child: Transform.rotate(
                      angle: -3.14 / 2, child: _suitToImage(playingCard)),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class FaceDownCard extends StatelessWidget {
  final double width;
  final double height;
  const FaceDownCard({
    this.width = 60,
    this.height = 80,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.blue,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}

class PlayingCardUi extends StatelessWidget {
  final PlayingCard playingCard;
  final Position position;

  PlayingCardUi({@required this.playingCard, this.position = Position.BOTTOM});

  @override
  Widget build(BuildContext context) {
    return _buildCard();
  }

  Widget _buildCard() {
    return !playingCard.faceUp
        ? FaceDownCard(
          width: position == Position.BOTTOM  ? 80 : 60,
          height: position == Position.BOTTOM ? 100 : 80,
        )
        : Container(
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                height: 100,
                width: 80,
                child: _positionToCard(),
              ),
            ),
          );
  }

  Widget _positionToCard() {
    switch (position) {
      case Position.TOP:
        return TopCard(
          playingCard: playingCard,
        );
      case Position.LEFT:
        return LeftCard(
          playingCard: playingCard,
        );
      case Position.RIGHT:
        return RightCard(
          playingCard: playingCard,
        );
      default:
        return BottomCard(
          playingCard: playingCard,
        );
    }
  }
}

String _cardTypeToString(PlayingCard card) {
  switch (card.cardType) {
    case CardType.one:
      return "1";
    case CardType.two:
      return "2";
    case CardType.three:
      return "3";
    case CardType.four:
      return "4";
    case CardType.five:
      return "5";
    case CardType.six:
      return "6";
    case CardType.seven:
      return "7";
    case CardType.eight:
      return "8";
    case CardType.nine:
      return "9";
    case CardType.ten:
      return "10";
    case CardType.jack:
      return "J";
    case CardType.queen:
      return "Q";
    case CardType.king:
      return "K";
    default:
      return "";
  }
}

Color _suitToColor(PlayingCard card) {
  switch (card.cardSuit) {
    case CardSuit.hearts:
    case CardSuit.diamonds:
      return Colors.red;
    case CardSuit.clubs:
    case CardSuit.spades:
      return Colors.black;
    default:
      return null;
  }
}

Image _suitToImage(PlayingCard card) {
  switch (card.cardSuit) {
    case CardSuit.hearts:
      return Image.asset('assets/images/hearts.png');
    case CardSuit.diamonds:
      return Image.asset('assets/images/diamonds.png');
    case CardSuit.clubs:
      return Image.asset('assets/images/clubs.png');
    case CardSuit.spades:
      return Image.asset('assets/images/spades.png');
    default:
      return null;
  }
}
