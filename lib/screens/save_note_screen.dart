import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rtg_app/bloc/save_note/events.dart';
import 'package:rtg_app/bloc/save_note/states.dart';
import 'package:rtg_app/keys/keys.dart';
import 'package:rtg_app/repository/note_repository.dart';

import '../bloc/save_note/save_note_bloc.dart';

class SaveNoteScreen extends StatefulWidget {
  static String id = 'save_note_screen';

  static newSaveNoteBloc() {
    return BlocProvider(
      create: (context) => SaveNoteBloc(
        noteRepository: NoteRepository(),
      ),
      child: SaveNoteScreen(),
    );
  }

  @override
  _SaveNoteState createState() => _SaveNoteState();
}

class _SaveNoteState extends State<SaveNoteScreen> {
  TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    context.read<SaveNoteBloc>().add(GetNoteEvent());
    _noteController = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SaveNoteBloc, SaveNoteState>(
        builder: (BuildContext context, SaveNoteState state) {
      if (state is NoteLoaded) {
        _noteController.text = state.note.description;
      }

      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).notes),
        ),
        body: ListView(
          padding: EdgeInsets.all(10),
          shrinkWrap: true,
          children: [
            TextFormField(
              key: Key(Keys.saveNoteField),
              controller: _noteController,
              minLines: 20,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).instructions_edit_note,
                hintMaxLines: 10,
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
              onChanged: (String newValue) {
                context.read<SaveNoteBloc>().add(SaveNoteEvent(newValue));
              },
            ),
          ],
        ),
      );
    });
  }
}
