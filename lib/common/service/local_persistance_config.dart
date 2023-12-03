import 'package:get_storage/get_storage.dart';
import 'package:nb_utils/nb_utils.dart';

class LocalStorage {
  final box = GetStorage();

  LocalStorage() {
    //
  }

  void setValue<T>({required String key, required T value}) {
    log('SET $key: $value \n\n');
    box.write(key, value);
  }

  T? getValue<T>({required String key}) {
    T? retrieveValue = box.read<T>(key);
    if (retrieveValue == null) log('Value Is Null For $key');

    log('GET $key : $retrieveValue');

    return retrieveValue;
  }
}
