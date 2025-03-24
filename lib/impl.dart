import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:fl_web/log.dart';

/// Register a method on the global context to call the method on the dart side from the js side.
@JS('@fl.invokeMethod')
external set invokeDart(JSFunction f);

/// To invoke js handler from dart side, we should declare it here.
@JS('@fl.generalHandler')
external void invokeJs(
  String channelName,
  String serialId,
  String? error,
  JSAny? response,
);

sealed class JSRequest<T, R extends JSAny?> {
  String get channelName;

  String get serialId;

  T get argument;

  const JSRequest();

  void success(R response) {
    invokeJs(channelName, serialId, null, response);
  }

  void fail(String error) {
    invokeJs(channelName, serialId, error, null);
  }
}

class EchoRequest extends JSRequest<JSAny?, JSAny?> {
  @override
  final channelName = 'echo';

  @override
  final String serialId;

  @override
  final JSAny? argument;

  const EchoRequest(this.serialId, this.argument);
}

// TODO: paper dto
class PaperRequest extends JSRequest<Map<String, dynamic>, JSUint8Array> {
  @override
  final channelName = 'paper';

  @override
  final String serialId;

  @override
  final Map<String, dynamic> argument;

  const PaperRequest(this.serialId, this.argument);
}

typedef JSRequestHandler = void Function(JSRequest request);

abstract class FlWebImpl {
  static JSRequestHandler? handler;

  /// Delegate all js call here.
  ///
  /// Declare [args] as optional & nullable to avoid js call with no args or `null`/`undefined`.
  static void delegate(String name, String serialId, [JSAny? args]) {
    if (handler == null) {
      LogImpl.warn('FLWeb is not ready yet, any calls will be ignored.');
      return;
    }

    JSRequest? request;
    switch (name) {
      case 'echo':
        request = EchoRequest(serialId, args);
        break;
      case 'paper':
        final data = Map<String, dynamic>.from(args!.dartify() as Map);
        request = PaperRequest(serialId, data);
        break;
      default:
        LogImpl.warn('Unsupported channel name "$name" (serial id: $serialId)');
    }

    if (request != null) handler!(request);
  }

  /// A simple guard:
  /// - Make sure `'@fl'` exists in the global context and is a [JSObject],
  /// - If not (does not exist or is not a [JSObject]), set it to an empty object (`{}` in js).
  static void guard() {
    final r = globalContext['@fl'].isA<JSObject>();
    if (!r) globalContext['@fl'] = JSObject();
  }

  static void initialize(void Function(JSRequest request) f) {
    handler = f;
    invokeDart = delegate.toJS;
    LogImpl.log('initialized');
    invokeJs('ready', '', null, null);
  }
}
