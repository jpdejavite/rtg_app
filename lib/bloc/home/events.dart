import 'package:equatable/equatable.dart';

abstract class HomeEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class GetBackupEvent extends HomeEvents {}
