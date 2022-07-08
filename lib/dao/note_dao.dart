import 'dart:async';
import 'package:rtg_app/database/sembast_database.dart';
import 'package:rtg_app/model/note.dart';
import 'package:sembast/sembast.dart';

import '../model/note.dart';

class NoteDao {
  final dbProvider = SembastDatabaseProvider.dbProvider;
  final String recordKey = 'note';

  Future<Note> getNote() async {
    var store = StoreRef.main();
    var db = await dbProvider.database;

    var record = await store.record(recordKey).get(db);
    if (record == null) {
      Note note = Note(description: '');
      await store.record(recordKey).put(db, note.toRecord());
      return note;
    }

    Note note = Note.fromRecord(record);
    return note;
  }

  Future deleteAll() async {
    var db = await dbProvider.database;
    await StoreRef.main().record(recordKey).delete(db);
  }

  Future<Note> save({Note note}) async {
    var store = StoreRef.main();
    var db = await dbProvider.database;

    await store.record(recordKey).put(db, note.toRecord());

    return note;
  }

  Future<Note> getDatabaseDataSummary() async {
    var store = StoreRef.main();
    var db = await dbProvider.database;

    var record = await store.record(recordKey).get(db);
    if (record == null) {
      Note note = Note();
      await store.record(recordKey).put(db, note.toRecord());
      return note;
    }

    Note note = Note.fromRecord(record);
    return note;
  }
}
