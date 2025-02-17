import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_first/models/user.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../routes//asyncvalue/index.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  group('GET /asyncvalue', () {
    test('should read the injected values', () async {
      const tUser1 = User(
        id: '1',
        username: 'john',
        email: 'john@gmail.com',
      );
      const tUser2 = User(
        id: '2',
        username: 'jane',
        email: 'jane@gmail.com',
      );
      final context = _MockRequestContext();
      when(() => context.read<User>()).thenReturn(tUser1);
      when(() => context.read<Future<User>>()).thenAnswer((_) async => tUser2);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));
      expect(
        response.json(),
        completion(
          equals({
            'user': tUser1.toJson(),
            'asyncUser': tUser2.toJson(),
          }),
        ),
      );
    });
  });
}
