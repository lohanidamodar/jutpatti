import 'package:flutter/material.dart';
import '../models/card.dart';

// TransformedCard makes the card draggable and translates it according to
// position in the stack.
enum Position { LEFT, RIGHT, BOTTOM, TOP }

class TransformedCard extends StatelessWidget {
  final PlayingCard playingCard;
  final double transformDistance;
  final int transformIndex;
  final int columnIndex;
  final Map<String, dynamic> dragData;
  final int maxDrags;
  final double rotation;
  final int transformAxis;
  final Position position;

  TransformedCard(
      {@required this.playingCard,
      this.transformDistance = 25.0,
      this.transformIndex = 0,
      this.columnIndex,
      this.maxDrags = 1,
      this.rotation = 0.1,
      this.transformAxis = 0,
      this.position = Position.BOTTOM,
      this.dragData});

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..translate(
          transformAxis == 0 ? -transformIndex * transformDistance : 0.0,
          transformAxis == 1 ? -transformIndex * transformDistance : 0.0,
          transformAxis == 2 ? -transformIndex * transformDistance : 0.0,
        )
        ..rotateZ(rotation),
      child: _buildCard(),
    );
  }

  Widget _buildCard() {
    return Draggable(
      maxSimultaneousDrags: maxDrags,
      data: dragData,
      child: !playingCard.faceUp
          ? Container(
              height: _positionToHeight(),
              width: _positionToWidth(),
              decoration: BoxDecoration(
                color: Colors.blue,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.0),
              ),
            )
          : Container(
              child: _buildFaceUpCard(),
            ),
      feedback: _buildFaceUpCard(),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: _buildFaceUpCard(),
      ),
    );
  }

  double _positionToHeight() {
    switch (position) {
      case Position.TOP:
      case Position.BOTTOM:
        return 80;
      case Position.LEFT:
      case Position.RIGHT:
        return 60;
      default:
        return 80;
    }
  }

  double _positionToWidth() {
    switch (position) {
      case Position.TOP:
      case Position.BOTTOM:
        return 60;
      case Position.LEFT:
      case Position.RIGHT:
        return 80;
      default:
        return 60;
    }
  }

  Alignment _positionToAlignment() {
    switch (position) {
      case Position.TOP:
        return Alignment.bottomRight;
      case Position.BOTTOM:
        return Alignment.topLeft;
      case Position.LEFT:
        return Alignment.topRight;
      case Position.RIGHT:
        return Alignment.bottomLeft;
      default:
        return Alignment.bottomRight;
    }
  }

  bool get isLeftRight =>
      position == Position.LEFT || position == Position.RIGHT;
  bool get isTopBottom =>
      position == Position.TOP || position == Position.BOTTOM;

  bool get isLeft => position == Position.LEFT;
  bool get isRight => position == Position.RIGHT;
  bool get isBottom => position == Position.BOTTOM;
  bool get isTop => position == Position.TOP;

  Widget _buildFaceUpCard() {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
        ),
        height: _positionToHeight(),
        width: _positionToWidth(),
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                height: 30.0,
                child: Transform.rotate(
                    angle: isLeft
                        ? 3.14 / 2
                        : isRight ? -3.14 / 2 : isBottom ? 0 : 3.14,
                    child: _suitToImage()),
              ),
            ),
            if(isTop) _buildTopCard(),
            if (isBottom) _buildBottomCard(),
            if (isRight) _buildRightCard(),
            if(isLeft) _buildLeftCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildRightCard() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Align(
        alignment: _positionToAlignment(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Transform.rotate(
              angle: -3.14 / 2,
              child: Text(
                _cardTypeToString(),
                style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: _suitToColor()),
              ),
            ),
            Container(
              height: 10.0,
              child: Transform.rotate(angle: -3.14 / 2, child: _suitToImage()),
            )
          ],
        ),
      ),
    );
  }
  Widget _buildLeftCard() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Align(
        alignment: _positionToAlignment(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 10.0,
              child: Transform.rotate(angle: 3.14 / 2, child: _suitToImage()),
            ),
            Transform.rotate(
              angle: 3.14 / 2,
              child: Text(
                _cardTypeToString(),
                style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: _suitToColor()),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Padding _buildBottomCard() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Align(
        alignment: _positionToAlignment(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              _cardTypeToString(),
              style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: _suitToColor()),
            ),
            Container(
              height: 10.0,
              child: _suitToImage(),
            )
          ],
        ),
      ),
    );
  }
  Padding _buildTopCard() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Align(
        alignment: _positionToAlignment(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 10.0,
              child: _suitToImage(),
            ),
            Transform.rotate(angle: 3.14,child: Text(
              _cardTypeToString(),
              style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: _suitToColor()),
            ),),
          ],
        ),
      ),
    );
  }

  String _cardTypeToString() {
    switch (playingCard.cardType) {
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

  Color _suitToColor() {
    switch (playingCard.cardSuit) {
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

  Image _suitToImage() {
    switch (playingCard.cardSuit) {
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
}
