import 'dart:js_interop';

@JS('console.log')
external void consoleLog(JSAny? object);

@JS('console.warn')
external void consoleWarn(JSAny? object);

@JS('console.error')
external void consoleError(JSAny? object);

abstract class LogImpl {
  static void log(Object object) {
    consoleLog(object.jsify());
  }

  static void warn(Object object) {
    consoleWarn(object.jsify());
  }

  static void error(Object object) {
    consoleError(object.jsify());
  }
}
