import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../routes/body/form_multipart/index.dart' as route;

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

  group('POST /body/form_multipart', () {
    late Request request;
    late Stream<List<int>> part1;
    late Stream<List<int>> part2;

    setUp(() {
      request = _MockRequest();
      part1 = Stream.fromIterable([
        [1, 2, 3],
      ]);
      part2 = Stream.fromIterable([
        [1, 2, 3, 4],
      ]);
    });

    test('should respond with 400 if photo == null', () async {
      final tUploadedFile = UploadedFile(
        'memo.pdf',
        ContentType.parse('application/pdf'),
        part2,
      );
      final tFormData = FormData(
        fields: {
          'username': 'john',
          'password': '123456',
        },
        files: {
          'memo': tUploadedFile,
        },
      );

      when(() => context.request).thenReturn(request);
      when(() => request.method).thenReturn(HttpMethod.post);
      when(request.formData).thenAnswer((_) async => tFormData);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.badRequest));
      expect(
        response.json(),
        completion(
          equals({
            'message': 'Please upload a png file with key photo',
          }),
        ),
      );
    });

    test('should respond with 400 if photo mime type is not image/png',
        () async {
      final tUploadedFile1 = UploadedFile(
        'photo.jpg',
        ContentType.parse('application/jpg'),
        part1,
      );
      final tUploadedFile2 = UploadedFile(
        'memo.pdf',
        ContentType.parse('application/pdf'),
        part2,
      );
      final tFormData = FormData(
        fields: {
          'username': 'john',
          'password': '123456',
        },
        files: {
          'photo': tUploadedFile1,
          'memo': tUploadedFile2,
        },
      );

      when(() => context.request).thenReturn(request);
      when(() => request.method).thenReturn(HttpMethod.post);
      when(request.formData).thenAnswer((_) async => tFormData);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.badRequest));
      expect(
        response.json(),
        completion(
          equals({
            'message': 'Please upload a png file with key photo',
          }),
        ),
      );
    });

    test('should respond with 200 with multipartField, multipartFiles, message',
        () async {
      final tUploadedFile1 = UploadedFile(
        'photo.png',
        ContentType.parse('image/png'),
        part1,
      );
      final tUploadedFile2 = UploadedFile(
        'memo.pdf',
        ContentType.parse('application/pdf'),
        part2,
      );
      final tFormData = FormData(
        fields: {
          'username': 'john',
          'password': '123456',
        },
        files: {
          'photo': tUploadedFile1,
          'memo': tUploadedFile2,
        },
      );

      when(() => context.request).thenReturn(request);
      when(() => request.method).thenReturn(HttpMethod.post);
      when(request.formData).thenAnswer((_) async => tFormData);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));
      expect(
        response.json(),
        completion(
          equals({
            'multiPartFields': tFormData.fields,
            'multiPartFiles': '${tFormData.files}',
            'message':
                'SuccessFully uploaded ${tUploadedFile1.name} and ${tUploadedFile2.name}',
          }),
        ),
      );
    });
  });
}
