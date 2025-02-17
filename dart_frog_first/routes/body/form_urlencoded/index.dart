import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  final method = context.request.method;

  switch (method) {
    case HttpMethod.post:
      final formData = await context.request.formData();

      return Response.json(
        body: {
          'formDataType': '${formData.runtimeType}',
          'formDataFields': formData.fields,
          'formDataFieldsType': '${formData.fields.runtimeType}',
          'formDataFiles': formData.files,
          'formDataFilesType': '${formData.files.runtimeType}',
        },
      );
    case _:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
