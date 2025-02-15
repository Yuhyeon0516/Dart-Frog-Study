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
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

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
