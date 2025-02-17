import 'dart:io';

import 'package:basic_auth/typedefs.dart';
import 'package:basic_auth/user_repository.dart';
import 'package:basic_auth/utils.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:string_validator/string_validator.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.post:
      return _signin(context);
    case _:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _signin(RequestContext context) async {
  try {
    final body = await context.request.json() as MapData;

    final email = body['email'] as String?;
    final password = body['password'] as String?;

    final errors = <String, String>{};

    if (email == null || isEmail(email.trim()) == false) {
      errors['email'] = 'Invalid email';
    }
    if (password == null || isLength(password.trim(), 6, 20) == false) {
      errors['password'] =
          'The length of the password must be at least 6 and no more than 20';
    }

    if (errors.isNotEmpty) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: errors,
      );
    }

    final userRepository = context.read<UserRepository>();

    final user = await userRepository.signin(
      email: email!,
      password: password!,
    );

    return Response.json(
      body: {
        'id': user.id,
        'token': Utils.createToken(email, password),
      },
    );
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'message': e.toString(),
      },
    );
  }
}
