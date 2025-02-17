import 'dart:io';

import 'package:basic_auth/typedefs.dart';
import 'package:basic_auth/user.dart';
import 'package:basic_auth/user_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:string_validator/string_validator.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _getUser(context, id);
    case HttpMethod.put:
      return _updateUser(context, id);
    case HttpMethod.delete:
      return _deleteUser(context, id);
    case _:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _deleteUser(RequestContext context, String id) async {
  final user = context.read<User>();

  if (user.id != id) {
    return Response.json(
      statusCode: HttpStatus.forbidden,
      body: {
        'message': 'You are not allowed to delete other users',
      },
    );
  }

  try {
    final userRepository = context.read<UserRepository>();

    await userRepository.deleteUser(
      id: id,
    );

    return Response.json(
      statusCode: HttpStatus.noContent,
      body: {
        'message': 'Successfully deleted the user',
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

Future<Response> _updateUser(RequestContext context, String id) async {
  final user = context.read<User>();

  if (user.id != id) {
    return Response.json(
      statusCode: HttpStatus.forbidden,
      body: {
        'message': 'You are not allowed to update other users',
      },
    );
  }

  try {
    final body = await context.request.json() as MapData;
    final username = body['username'] as String?;

    if (username == null || isLength(username.trim(), 2, 12) == false) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {
          'message':
              'The length of the username must be at least 2 and no more than 12',
        },
      );
    }

    final userRepository = context.read<UserRepository>();

    final updatedUser = await userRepository.updateUser(
      id: id,
      username: username,
    );

    return Response.json(
      body: {
        'user': updatedUser,
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

Future<Response> _getUser(RequestContext context, String id) async {
  final user = context.read<User>();

  if (user.id != id) {
    return Response.json(
      statusCode: HttpStatus.forbidden,
      body: {
        'message': 'You are not allowed to see other users',
      },
    );
  }

  return Response.json(
    body: {
      'user': user,
    },
  );
}
