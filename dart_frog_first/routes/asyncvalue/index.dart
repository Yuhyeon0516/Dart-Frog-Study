import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_first/models/user.dart';

Future<Response> onRequest(RequestContext context) async {
  final user = context.read<User>();
  final asyncUser = await context.read<Future<User>>();

  return Response.json(
    body: {
      'user': user,
      'asyncUser': asyncUser,
    },
  );
}
