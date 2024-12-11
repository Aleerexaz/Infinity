/*import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class Pref {
  static late Box _box;

  // Initialize Hive and open the box
  static Future<void> initialize() async {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path); // Set Hive storage directory
    _box = await Hive.openBox('myData'); // Open the box
  }

  // Getter and setter for 'showOnBoarding'
  static bool get showOnBoarding =>
      _box.get('showOnBoarding', defaultValue: true) as bool;
  static set showOnBoarding(bool value) => _box.put('showOnBoarding', value);
}*/
