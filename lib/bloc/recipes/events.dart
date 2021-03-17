import 'package:equatable/equatable.dart';

abstract class RecipesEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchRecipesEvent extends RecipesEvents {
  final String lastId;
  FetchRecipesEvent({this.lastId});
}
