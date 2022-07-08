class Note {
  Note({
    this.description,
  });

  String description;

  factory Note.fromRecord(Map<String, Object> record) {
    return Note(
      description: record['description'],
    );
  }

  Object toRecord() {
    return {
      'description': this.description,
    };
  }

  @override
  bool operator ==(other) {
    if (other == null) {
      return false;
    }
    if (!(other is Note)) {
      return false;
    }

    return description == other.description;
  }

  @override
  int get hashCode => this.description.hashCode;
}
