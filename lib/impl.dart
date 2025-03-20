import 'dart:js_interop';

/// To invoke js handler from dart side, we should declare it here.
@JS('@fl.generalHandler')
external void invokeJs(
  String channelName,
  String serialId,
  String? error,
  JSAny? response,
);

sealed class ResponseToJs<R extends JSAny?> {
  String get channelName;

  String get serialId;

  const ResponseToJs();

  void ok(R response) {
    invokeJs(channelName, serialId, null, response);
  }

  void error(String error) {
    invokeJs(channelName, serialId, error, null);
  }
}

class Ready extends ResponseToJs<Null> {
  @override
  final channelName = 'ready';

  @override
  final serialId = '';

  const Ready();
}

class Echo extends ResponseToJs<JSAny?> {
  @override
  final channelName = 'echo';

  @override
  final String serialId;

  const Echo(this.serialId);
}

class Paper extends ResponseToJs<JSUint8Array> {
  @override
  final channelName = 'paper';

  @override
  final String serialId;

  const Paper(this.serialId);
}
