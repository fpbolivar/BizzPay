import 'package:buysellbiz/Data/AppData/user_data.dart';

import 'app_initializer.dart';
import 'app_media.dart';
import 'app_theme.dart';

class Data with AppTheme, AppMedia, AppInitializer, UserData {
  Data._();

  // Static instance variable
  static final Data app = Data._();

  // Getter to access the instance
  factory Data() {
    return app;
  }

  static const String test = '';
}
