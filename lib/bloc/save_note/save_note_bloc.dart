import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtg_app/model/note.dart';
import 'package:rtg_app/repository/note_repository.dart';

import 'events.dart';
import 'states.dart';

class SaveNoteBloc extends Bloc<SaveNoteEvents, SaveNoteState> {
  final NoteRepository noteRepository;
  SaveNoteBloc({
    @required this.noteRepository,
  }) : super(SaveNoteInitState());
  @override
  Stream<SaveNoteState> mapEventToState(SaveNoteEvents event) async* {
    if (event is GetNoteEvent) {
      yield await getNote(event);
      return;
    }

    if (event is SaveNoteEvent) {
      yield await saveNote(event);
      return;
    }
  }

  Future<NoteLoaded> getNote(SaveNoteEvents event) async {
    Note note = await noteRepository.getNote();
    return NoteLoaded(note: note);
  }

  Future<NoteSaved> saveNote(SaveNoteEvent event) async {
    Note note = await noteRepository.getNote();
    note.description = event.note;
    await noteRepository.save(note: note);
    return NoteSaved();
  }
}
