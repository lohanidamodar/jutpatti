import 'package:flutter/material.dart';

enum CardSuit {
  spades,
  hearts,
  diamonds,
  clubs,
}

enum CardType {
  one,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  ten,
  jack,
  queen,
  king
}

enum CardColor {
  red,
  black,
}

// Simple playing card model
class PlayingCard {
  CardSuit cardSuit;
  CardType cardType;
  bool faceUp;
  bool opened;

  PlayingCard({
    @required this.cardSuit,
    @required this.cardType,
    this.faceUp = false,
    this.opened = false,
  });

  CardColor get cardColor {
    if(cardSuit == CardSuit.hearts || cardSuit == CardSuit.diamonds) {
      return CardColor.red;
    } else {
      return CardColor.black;
    }
  }

  CardType nextCard() {
    switch(cardType){

      case CardType.one:
        return CardType.two;
        break;
      case CardType.two:
        return CardType.three;
        break;
      case CardType.three:
        return CardType.four;
        break;
      case CardType.four:
        return CardType.five;
        break;
      case CardType.five:
        return CardType.six;
        break;
      case CardType.six:
        return CardType.seven;
        break;
      case CardType.seven:
        return CardType.eight;
        break;
      case CardType.eight:
        return CardType.nine;
        break;
      case CardType.nine:
        return CardType.ten;
        break;
      case CardType.ten:
        return CardType.jack;
        break;
      case CardType.jack:
        return CardType.queen;
        break;
      case CardType.queen:
        return CardType.king;
        break;
      case CardType.king:
        return CardType.one;
        break;
    }
  }

  bool operator ==(o) => o is PlayingCard && o.cardType == cardType && o.cardSuit == cardSuit;

}


List<PlayingCard> getAllCards() {

  List<PlayingCard> allCards = [];
  // Add all cards to deck
  CardSuit.values.forEach((suit) {
    CardType.values.forEach((type) {
      allCards.add(PlayingCard(
        cardType: type,
        cardSuit: suit,
        faceUp: false,
      ));
    });
  });
  return allCards;
}