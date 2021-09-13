import 'package:thinkerx/core/runtime_env.dart';

class ServersHelper {
  static String get apiURL {
    return RuntimeEnv.isDev ? "url for dev" : "url for prod";
  }
}
