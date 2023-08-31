import 'package:scrumboard_app/models/card_model.dart';

abstract class CardEvent {}

class GetAllCardsEvent implements CardEvent {}

class DeleteAllCardsEvent implements CardEvent {}

class DeleteCardEvent implements CardEvent {
  final CardModel _cardMdl;

  CardModel get cardMdl => _cardMdl;

  DeleteCardEvent(this._cardMdl);
}

class PostCardEvent implements CardEvent {
  final CardModel _cardMdl;

  CardModel get cardMdl => _cardMdl;

  PostCardEvent(this._cardMdl);
}

class UpdateCardEvent implements CardEvent {
  final CardModel _cardMdl;

  CardModel get cardMdl => _cardMdl;

  UpdateCardEvent(this._cardMdl);
}