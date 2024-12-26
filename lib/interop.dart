import 'dart:js_interop';

/// set a function on globalContext to enable js-side call flutter-side function
@JS('@fl.handler')
external set handleJsCall(JSFunction value);

@JS('@fl.onPing')
external void onPing(String serialId, JSObject echo);

@JS('@fl.onFreeDrawCaptured')
external void onFreeDrawCaptured(String serialId, JSUint8Array bytes);

@JS('@fl.onShareCardGenerated')
external void onShareCardGenerated(String serialId, JSUint8Array bytes);
