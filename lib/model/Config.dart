// config model:
// all things here will NEVER be reset

import 'package:hive_flutter/hive_flutter.dart';

mixin Config {
  static const boxString = "config";

  static Box getBox() {
    return Hive.box(boxString);
  }

  static String lastOpenedVersion() {
    return getBox().get("lastOpenedVersion", defaultValue: "");
  }

  static void updateLastOpenedVersion(String lastOpenedVersion) {
    getBox().put("lastOpenedVersion", lastOpenedVersion);
  }

  static DateTime? lastLogoffTime() {
    return getBox().get("lastLogoffTime", defaultValue: null);
  }

  static void updateLastLogoffTime(DateTime? lastLogoffTime) {
    getBox().put("lastLogoffTime", lastLogoffTime);
  }

  static DateTime? lastLogonTime() {
    return getBox().get("lastLogonTime", defaultValue: null);
  }

  static void updateLastLogonTime(DateTime? lastLogonTime) {
    getBox().put("lastLogonTime", lastLogonTime);
  }
}
