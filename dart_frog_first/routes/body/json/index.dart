import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  final method = context.request.method;

  switch (method) {
    case HttpMethod.post:
      final body = await context.request.json();

      return Response.json(
        body: {
          'bodyType': '${body.runtimeType}',
          'content': body,
        },
      );
    case _:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
