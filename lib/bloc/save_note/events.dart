import 'package:equatable/equatable.dart';

abstract class SaveNoteEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class GetNoteEvent extends SaveNoteEvents {}

class SaveNoteEvent extends SaveNoteEvents {
  final String note;

  SaveNoteEvent(this.note);
}
