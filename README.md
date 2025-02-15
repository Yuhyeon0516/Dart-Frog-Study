# Dart-Frog-Study

## Route

Route의 구성은 대략 아래와 같다.

http://localhost or http://localhost/index
-> dart_frog/routes/index.dart

http://localhost/hello or http://localhost/hello/index
-> dart_frog/routes/hello.dart or dart_frog/routes/hello/index.dart

http://localhost/complex/path/to/service
-> dart_frog/routes/complex/path/to/service.dart or dart_frog/routes/comples/path/to/service/index.dart

## Method

Express는 `app.get`, `app.post`와 같이 Method에 접근할 수 있으나 Dart Frog는 이런 기능이 없다.  
그래서 어떻게 컨트롤하는게 가장 좋을까 생각해보았고 아래와 같이 구성하니 관리 및 유지하는데 좋았다.

```dart
Response onRequest(RequestContext context) {
  return switch (context.request.method) {
    HttpMethod.get => _handleGet(context),
    HttpMethod.delete => _handleDelete(context),
    HttpMethod.post => _handlePost(context),
    HttpMethod.put => _handlePut(context),
    _ => Response(
        statusCode: HttpStatus.methodNotAllowed,
        body: 'Invalid Request',
      ),
  };
}

Response _handleGet(RequestContext context) {
  return Response(
    body: 'Request Method: ${context.request.method}',
  );
}

Response _handlePost(RequestContext context) {
  return Response(
    statusCode: HttpStatus.created,
    body: 'Request Method: ${context.request.method}',
  );
}

Response _handleDelete(RequestContext context) {
  return Response(
    statusCode: HttpStatus.noContent,
    body: 'Request Method: ${context.request.method}',
  );
}

Response _handlePut(RequestContext context) {
  return Response(
    body: 'Request Method: ${context.request.method}',
  );
}
```

## Headers

Headers는 `RequestContext`를 통해 headers의 값을 가져올 수 있다.

```dart
final headers = context.request.headers;
```

## Query Parameters

Query paramters는 headers와 동일하기 `ReqeustContext`를 통해 값을 가져올 수 있다.

```dart
final queryParamters = context.request.uri.queryParameters;
```

## Body

Body는 `RequestContext`를 통해 async/await으로 가져올 수 있다.

- String

  ```dart
  Future<Response> onRequest(RequestContext context) async {
    final method = context.request.method;

    switch (method) {
      case HttpMethod.post:
        final body = await context.request.body();

        return Response(
          body: 'bodyType: ${body.runtimeType}, context: $body',
        );
      case _:
        return Response(statusCode: HttpStatus.methodNotAllowed);
    }
  }
  ```

- json

  ```dart
  Future<Response> onRequest(RequestContext context) async {
    final method = context.request.method;

    switch (method) {
      case HttpMethod.post:
        final body = await context.request.json();

        return Response.json(
          body: {
            'bodyType': '${body.runtimeType}',
            'content': body,
          },
        );
      case _:
        return Response(statusCode: HttpStatus.methodNotAllowed);
    }
  }
  ```

- form-urlencoded

  ```dart
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
  ```

- form-multipart

  ```dart
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
  ```

## HTTP Status

HTTP status code는 `dart:io`에 `HttpStatus`에 모두 정의되어 있음.

## Dynamic Routes

## Wildcard Routes

## Middleware

## Provider

## Static Files
