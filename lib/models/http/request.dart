import 'dart:io';

import 'package:meta/meta.dart';

abstract class HttpRequest {
  final String path;
  final String overrideUrl;
  final Map<String, dynamic> headers;

  HttpRequest(this.path, this.headers, this.overrideUrl);

  bool get isJsonRequest => this is JsonRequest;

  dynamic get payload {
    return (this as JsonRequest).payload;
  }
}

class JsonRequest extends HttpRequest {
  final Map<String, dynamic> payload;

  JsonRequest({
    @required String path,
    this.payload = const <String, dynamic>{},
    Map<String, String> extraHeader,
    String overrideUrl,
  }) : super(
          path,
          _getHeaders(extraHeader),
          overrideUrl,
        );

  static Map<String, String> _getHeaders(
    Map<String, String> extraHeader,
  ) {
    final merged = <String, String>{};
    final defaultHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    merged.addAll(defaultHeaders);
    if (extraHeader != null) merged.addAll(extraHeader);

    return merged;
  }

  bool get hasPayload => this.payload.isNotEmpty;
}
