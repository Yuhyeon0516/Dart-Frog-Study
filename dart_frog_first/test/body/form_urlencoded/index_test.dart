import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../routes/body/form_urlencoded/index.dart' as route;

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

  group('POST /body/form_urlencoded', () {
    final contentTypeFormUrlEncodedHeader = {
      HttpHeaders.contentTypeHeader:
          ContentType('application', 'x-www-form-urlencoded').mimeType,
    };

    const tMeptyFormData = FormData(fields: {}, files: {});
    const tFormData = FormData(
      fields: {
        'username': 'john',
        'password': '123456',
      },
      files: {},
    );

    test('should respond with 200 and empty formData', () async {
      final request = Request.post(
        Uri.parse('http://localhost/'),
        headers: contentTypeFormUrlEncodedHeader,
      );

      when(() => context.request).thenReturn(request);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));
      expect(
        response.json(),
        completion(
          equals({
            'formDataType': 'FormData',
            'formDataFields': const <String, dynamic>{},
            'formDataFieldsType': 'UnmodifiableMapView<String, String>',
            'formDataFiles': const <String, UploadedFile>{},
            'formDataFilesType': 'UnmodifiableMapView<String, UploadedFile>',
          }),
        ),
      );
    });

    test('should respond with 200 and empty formData with MockRequest',
        () async {
      final request = _MockRequest();

      when(() => context.request).thenReturn(request);
      when(() => request.method).thenReturn(HttpMethod.post);
      when(() => request.headers).thenReturn(contentTypeFormUrlEncodedHeader);
      when(request.formData).thenAnswer((_) async => tMeptyFormData);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));
      expect(
        response.json(),
        completion(
          equals({
            'formDataType': 'FormData',
            'formDataFields': const <String, dynamic>{},
            'formDataFieldsType': 'UnmodifiableMapView<String, String>',
            'formDataFiles': const <String, UploadedFile>{},
            'formDataFilesType': 'UnmodifiableMapView<String, UploadedFile>',
          }),
        ),
      );
    });

    test('should respond with 200, formDataType, formData', () async {
      final request = Request.post(
        Uri.parse('http://localhost/'),
        headers: contentTypeFormUrlEncodedHeader,
        body: 'username=john&password=123456',
      );

      when(() => context.request).thenReturn(request);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));
      expect(
        response.json(),
        completion(
          equals({
            'formDataType': 'FormData',
            'formDataFields': {
              'username': 'john',
              'password': '123456',
            },
            'formDataFieldsType': 'UnmodifiableMapView<String, String>',
            'formDataFiles': const <String, UploadedFile>{},
            'formDataFilesType': 'UnmodifiableMapView<String, UploadedFile>',
          }),
        ),
      );
    });

    test('should respond with 200, formDataType, formData with MockRequest',
        () async {
      final request = _MockRequest();

      when(() => context.request).thenReturn(request);
      when(() => request.method).thenReturn(HttpMethod.post);
      when(() => request.headers).thenReturn(contentTypeFormUrlEncodedHeader);
      when(request.formData).thenAnswer((_) async => tFormData);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));
      expect(
        response.json(),
        completion(
          equals({
            'formDataType': 'FormData',
            'formDataFields': {
              'username': 'john',
              'password': '123456',
            },
            'formDataFieldsType': 'UnmodifiableMapView<String, String>',
            'formDataFiles': const <String, UploadedFile>{},
            'formDataFilesType': 'UnmodifiableMapView<String, UploadedFile>',
          }),
        ),
      );
    });
  });
}
