import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {
  final headers = context.request.headers;

  return Response.json(
    body: {
      'request_headers': headers,
    },
  );
}
