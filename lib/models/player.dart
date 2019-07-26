import 'package:jutpatti/models/card.dart';

enum PlayerType{
  HUMAN,
  COMPUTER
}

class Player {
  String name;
  List<PlayingCard> cards;
  PlayerType type;

  Player({this.name, this.cards, this.type = PlayerType.HUMAN});


  List<PlayingCard> getThrowAbleCard(List<PlayingCard> jokers) {
    List<PlayingCard> throwable = [];
    List<PlayingCard> hand = List<PlayingCard>.from(cards);
    for(PlayingCard joker in jokers) {
      if(hand.contains(joker))
        hand.remove(joker);
    }
    while(hand.length > 1) {
      PlayingCard card = hand.removeAt(0);
      var pair = hand.firstWhere((card2)=>card.cardType == card2.cardType,orElse: () => null);
      if(pair != null) {
        hand.remove(pair);
      }else{
        throwable.add(card);
      }
    }
    throwable.addAll(hand);
    return throwable; 
  }

  bool isWinner(List<PlayingCard> jokers, int pairsNeeded) {
    List<PlayingCard> hand = List<PlayingCard>.from(cards);
    int pairsInHand = 0;
    for(PlayingCard joker in jokers) {
      if(hand.contains(joker)) {
        pairsInHand++;
        hand.remove(joker);
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