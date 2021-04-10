import 'package:equatable/equatable.dart';

abstract class HomeEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class GetHomeDataEvent extends HomeEvents {}

class DeleteAllDataEvent extends HomeEvents {}

class DismissRecipeTutorial extends HomeEvents {}
