import 'package:pimpmynurse/utils/boxes.dart';
import 'package:pimpmynurse/utils/kv_store.dart';

class FlowsheetLimitSetting {
  static const String _settingName = 'flowsheet_limit';
  static const int _default = 5;
  static const int min = 2;
  static const int max = 100;

  static int get() {
    return KVStore.localStorage.getInt(_settingName) ?? _default;
  }

  static bool increase() {
    if (get() + 1 <= max) {
      KVStore.localStorage.setInt(_settingName, get() + 1);
      return true;
    }
    return false;
  }

  static bool decrease() {
    var curr = get();
    if (curr - 1 >= min) {
      if (AppBoxes.flowsheets.length <= curr - 1) {
        KVStore.localStorage.setInt(_settingName, get() - 1);
        return true;
      }
    }
    return false;
  }
}
