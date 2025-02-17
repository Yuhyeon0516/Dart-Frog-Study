import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {
  final queryParamters = context.request.uri.queryParameters;

  return Response.json(
    body: {
      'queryParamters': queryParamters,
    },
  );
}
