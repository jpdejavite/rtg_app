import 'package:rtg_app/helper/custom_date_time.dart';

enum AccountRegistrationStatus { none, registering, registered }

enum AccountPuchaseStatus { none, purchasing, puchased }

class Account {
  Account({
    this.createdAt,
    this.updatedAt,
    this.puchaseStatus,
    this.registrationStatus,
  });

  int createdAt;
  int updatedAt;
  AccountPuchaseStatus puchaseStatus;
  AccountRegistrationStatus registrationStatus;

  factory Account.fromRecord(Map<String, Object> record) {
    return Account(
      createdAt: record["createdAt"],
      updatedAt: record["updatedAt"],
      puchaseStatus:
          AccountPuchaseStatus.values[record["puchaseStatus"] as int],
      registrationStatus:
          AccountRegistrationStatus.values[record["registrationStatus"] as int],
    );
  }

  factory Account.emptyAccount() {
    return Account(
      createdAt: CustomDateTime.current.millisecondsSinceEpoch,
      updatedAt: CustomDateTime.current.millisecondsSinceEpoch,
      puchaseStatus: AccountPuchaseStatus.none,
      registrationStatus: AccountRegistrationStatus.none,
    );
  }

  Object toRecord() {
    return {
      'createdAt': this.createdAt,
      'updatedAt': this.updatedAt,
      'puchaseStatus': this.puchaseStatus.index,
      'registrationStatus': this.registrationStatus.index,
    };
  }
}
