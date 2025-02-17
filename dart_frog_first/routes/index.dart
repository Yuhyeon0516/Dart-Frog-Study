import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {
  final token = context.read<String>();

  return Response.json(
    body: {
      'token': token,
      'message': 'hello there',
    },
  );
}
