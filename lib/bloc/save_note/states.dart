import 'package:equatable/equatable.dart';

import '../../model/note.dart';

abstract class SaveNoteState extends Equatable {
  @override
  List<Object> get props => [];
}

class SaveNoteInitState extends SaveNoteState {}

class NoteLoaded extends SaveNoteState {
  final Note note;
  NoteLoaded({this.note});
  @override
  List<Object> get props => [note];
}

class NoteSaved extends SaveNoteState {}
