import 'package:uuid/uuid.dart';

class IdGenerator {
  static final Uuid uuid = Uuid();
  static Uuid _mock;

  static set mock(Uuid mock) {
    _mock = mock;
  }

  static String id() {
    return _mock != null ? _mock.v4() : uuid.v4();
  }
}
