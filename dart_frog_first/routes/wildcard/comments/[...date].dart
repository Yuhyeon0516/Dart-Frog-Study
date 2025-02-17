import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context, String date) {
  switch (context.request.method) {
    case HttpMethod.get:
      return Response.json(
        body: {
          'date': date,
        },
      );
    case _:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
