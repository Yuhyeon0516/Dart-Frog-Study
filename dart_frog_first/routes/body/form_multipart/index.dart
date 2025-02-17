import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

final contentTypePng = ContentType('image', 'png');
final contentTypePdf = ContentType('application', 'pdf');

Future<Response> onRequest(RequestContext context) async {
  final method = context.request.method;

  switch (method) {
    case HttpMethod.post:
      return _handlePost(context);
    case _:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _handlePost(RequestContext context) async {
  final formData = await context.request.formData();
  final photo = formData.files['photo'];
  final memo = formData.files['memo'];

  if (photo == null || photo.contentType.mimeType != contentTypePng.mimeType) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'message': 'Please upload a png file with key photo',
      },
    );
  }

  if (memo == null || memo.contentType.mimeType != contentTypePdf.mimeType) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'message': 'Please upload a pdf file with key memo',
      },
    );
  }

  return Response.json(
    body: {
      'multiPartFields': formData.fields,
      'multiPartFiles': '${formData.files}',
      'message': 'SuccessFully uploaded ${photo.name} and ${memo.name}',
    },
  );
}
