import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  final method = context.request.method;

  switch (method) {
    case HttpMethod.post:
      final body = await context.request.body();

      return Response(
        body: 'bodyType: ${body.runtimeType}, context: $body',
      );
    case _:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
