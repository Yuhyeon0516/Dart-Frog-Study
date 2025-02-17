import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../routes/body/json/index.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

void main() {
  late RequestContext context;

  setUp(() {
    context = _MockRequestContext();
  });

  group('for methods other than POST', () {
    test('should responsd with 405', () async {
      final request = Request.get(
        Uri.parse('http://localhost/'),
      );
      when(() => context.request).thenReturn(request);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
      expect(response.body(), completion(isEmpty));
    });

    test('should respond with 405 with MockRequest', () async {
      final request = _MockRequest();
      when(() => context.request).thenReturn(request);
      when(() => request.method).thenReturn(HttpMethod.get);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
      expect(response.body(), completion(isEmpty));
    });
  });

  group('POST /body/json', () {
    final contentTypeJsonHeader = {
      HttpHeaders.contentTypeHeader:
          ContentType('application', 'json').mimeType,
    };

    test('should respond with a 200, with bodyType and content', () async {
      final request = Request.post(
        Uri.parse('http://localhost/'),
        headers: contentTypeJsonHeader,
        body: jsonEncode({
          'integer': 1,
          'string': 'value',
          'null': null,
          'list': [1, 2, 3],
        }),
      );

      when(() => context.request).thenReturn(request);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));
      expect(
        response.json(),
        completion(
          equals({
            'bodyType': '_Map<String, dynamic>',
            'content': {
              'integer': 1,
              'string': 'value',
              'null': null,
              'list': [1, 2, 3],
            },
          }),
        ),
      );
    });

    test(
        'should respond with a 200, with bodyType and content with MockRequest',
        () async {
      final request = _MockRequest();

      when(() => context.request).thenReturn(request);
      when(() => request.method).thenReturn(HttpMethod.post);
      when(() => request.headers).thenReturn(contentTypeJsonHeader);

      when(request.json).thenAnswer(
        (_) async => <String, dynamic>{
          'integer': 1,
          'string': 'value',
          'null': null,
          'list': [1, 2, 3],
        },
      );

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));
      expect(
        response.json(),
        completion(
          equals({
            'bodyType': '_Map<String, dynamic>',
            'content': {
              'integer': 1,
              'string': 'value',
              'null': null,
              'list': [1, 2, 3],
            },
          }),
        ),
      );
    });
  });
}
