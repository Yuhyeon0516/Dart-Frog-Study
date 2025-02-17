import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {
  return switch (context.request.method) {
    HttpMethod.get => _handleGet(context),
    HttpMethod.delete => _handleDelete(context),
    HttpMethod.post => _handlePost(context),
    HttpMethod.put => _handlePut(context),
    _ => Response(
        statusCode: HttpStatus.methodNotAllowed,
        body: 'Invalid Request',
      ),
  };
}

Response _handleGet(RequestContext context) {
  return Response(
    body: 'Request Method: ${context.request.method}',
  );
}

Response _handlePost(RequestContext context) {
  return Response(
    statusCode: HttpStatus.created,
    body: 'Request Method: ${context.request.method}',
  );
}

Response _handleDelete(RequestContext context) {
  return Response(
    statusCode: HttpStatus.noContent,
    body: 'Request Method: ${context.request.method}',
  );
}

Response _handlePut(RequestContext context) {
  return Response(
    body: 'Request Method: ${context.request.method}',
  );
}
