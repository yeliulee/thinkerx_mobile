class RuntimeEnv {
  static bool _isDev;
  static bool _isProd;

  static bool get isDev => _isDev;
  static bool get isProd => _isProd;

  static void setEnv(bool isDevelopmentMode) {
    _isDev = isDevelopmentMode;
    _isProd = !isDevelopmentMode;
  }
}
