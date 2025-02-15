import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_first/models/user.dart';

Response onRequest(RequestContext context) {
  switch (context.request.method) {
    case HttpMethod.get:
      const user = User(
        id: '1',
        username: 'jone',
        email: 'jone@gmail.com',
      );

      return Response.json(
        body: user.toJson(),
      );
    case _:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
