import 'package:jutpatti/models/card.dart';

class Player {
  String name;
  List<PlayingCard> cards;

  Player({this.name, this.cards});

  bool isWinner(List<PlayingCard> jokers, int pairsNeeded) {
    List<PlayingCard> hand = List<PlayingCard>.from(cards);
    int pairsInHand = 0;
    for(PlayingCard card in hand) {
      if(jokers.contains(card)) {
        pairsInHand++;
        hand.remove(card);
      }
    }
    while(hand.length > 1) {
      PlayingCard card = hand.removeAt(0);
      var pair = hand.firstWhere((card2)=>card.cardType == card2.cardType,orElse: () => null);
      if(pair != null) {
        pairsInHand++;
        hand.remove(pair);
      }
    }
    print(pairsInHand);
    return pairsNeeded == pairsInHand;
  }

}