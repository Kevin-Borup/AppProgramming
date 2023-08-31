import '../../../models/card_model.dart';

enum CardStates { initial, uploading, loading, deleting, complete, error }

class CardState {
  final CardStates _state;
  final List<CardModel> _cards;

  CardStates get currentState => _state;
  List<CardModel> get cards => _cards;

  CardState({required CardStates state, List<CardModel>? cards})
    : _state = state,
      _cards = cards ?? [];
}