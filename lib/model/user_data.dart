class UserData {
  UserData({
    this.dimissRecipeTutorial,
    this.updatedAt,
  });

  bool dimissRecipeTutorial;
  int updatedAt;

  factory UserData.fromRecord(Map<String, Object> record) {
    return UserData(
      dimissRecipeTutorial: record["dimissRecipeTutorial"],
      updatedAt: record['updatedAt'],
    );
  }

  Object toRecord() {
    return {
      'dimissRecipeTutorial': this.dimissRecipeTutorial,
      'updatedAt': this.updatedAt,
    };
  }
}
