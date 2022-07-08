import 'package:rtg_app/dao/note_dao.dart';
import 'package:rtg_app/model/note.dart';

class NoteRepository {
  final noteDao = NoteDao();

  Future<Note> getNote() => noteDao.getNote();

  Future<Note> save({Note note}) => noteDao.save(note: note);

  Future deleteAll() => noteDao.deleteAll();
}
