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

## Request Body

Request Body는 `RequestContext`를 통해 `async/await`으로 가져올 수 있다.

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

## Response Body

Response에 body를 실어서 전달하는 방법은 다음과 같다.

1. `toJson`이 있는 model을 생성하고.
2. Body에 전달할 객체를 생성하고 `toJson`으로 `Response`의 `body`에 전달

```dart
@JsonSerializable()
class User {
  const User({
    required this.id,
    required this.username,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  final String id;
  final String username;
  final String email;

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

Response onRequest(RequestContext context) {
  switch (context.request.method) {
    case HttpMethod.get:
      const user = User(
        id: '1',
        username: 'jone',
        email: 'jone@gmail.com',
      );

      return Response.json(
        body: user.toJson(),
      );
    case _:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
```

## Dynamic Routes

- Single

  Single의 경우 route를 `/dynamic/posts/[id].dart`와 같이 생성하면 아래 코드처럼 `id`에 접근이 가능하다.

  ```dart
  Response onRequest(
    RequestContext context,
    String id,
  ) {
    switch (context.request.method) {
      case HttpMethod.get:
        return Response.json(
          body: {
            'id': id,
            'message': 'Post with $id',
          },
        );
      case _:
        return Response(statusCode: HttpStatus.methodNotAllowed);
    }
  }
  ```

- Multiple

  Multiple의 경우 route를 `/dynamic/users/[userId]/posts/[postId].dart`와 같이 생성하면 아래 코드처럼 `userId`와 `postId`에 접근이 가능하다.

  ```dart
  Response onRequest(
    RequestContext context,
    String userId,
    String postId,
  ) {
    switch (context.request.method) {
      case HttpMethod.get:
        return Response.json(
          body: {
            'routeParameters': {
              'userId': userId,
              'postId': postId,
            },
          },
        );
      case _:
        return Response(statusCode: HttpStatus.methodNotAllowed);
    }
  }
  ```

## Wildcard Routes

Wildcard의 경우 `wildcard/comments/[...date].dart`로 생성하면 되는데 cli 커맨드가 정상 동작하지 않아서 직접 생성해주어야 한다.  
cli 미동작 관련 issue는 하기 github에 있다.  
https://github.com/VeryGoodOpenSource/dart_frog/issues/732  
위와 같이 wildcard url을 맞추었다면 아래와 같이 호출할 수 있다.

```dart
Response onRequest(RequestContext context, String date) {
  switch (context.request.method) {
    case HttpMethod.get:
      return Response.json(
        body: {
          'date': date,
        },
      );
    case _:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
```

## Middleware

Middleware도 route와 같이 cli로 생성이 가능하다.  
생성한 폴더 하위 경로의 모든 route에 middleware가 적용된다. 예를 들어 `/`의 root routes에 middleware를 적용한다면, `/` 하위 모든 route에 middleware가 적용된다.  
Middleware는 아래 코드의 구조로 이루어져 있고 `.use`의 실행 순서의 경우 bottom to top 즉, 마지막에 chain한 middleware가 가장 먼저 실행된다. 아래 코드를 예시로 들자면 `requestLogger` -> `_rootMiddlewareTwo` -> `_rootMiddlewareOne` 순서로 middleware가 실행된다.

```
Handler middleware(Handler handler) {
  return handler
      .use(_rootMiddlewareOne)
      .use(_rootMiddlewareTwo)
      .use(requestLogger());
}

Handler _rootMiddlewareOne(Handler handler) {
  return (RequestContext context) async {
    print('[root] before request');
    final response = await handler(context);

    print('[root] after request');

    return response;
  };
}

Handler _rootMiddlewareTwo(Handler handler) {
  return (RequestContext context) async {
    print('[root2] before request');
    final response = await handler(context);

    print('[root2] after request');

    return response;
  };
}
```

## Provider

Provider는 middleware의 일종으로 Dart Frog에서는 provider를 통해 DI를 진행한다.  
Express와 굉장히 유사성을 띄지만 Express에서는 request에 직접적으로 data를 주입하지만 Dart Frog는 provider -> RequestContext -> context.read로 data의 주입 및 확인이 가능하다. 아래 코드에서 예시를 들어두었다.

```dart
Middleware tokenProvider() {
  return provider((context) => '1234xyz');
}

Handler middleware(Handler handler) {
  return handler
      .use(tokenProvider());
}

Response onRequest(RequestContext context) {
  final token = context.read<String>();

  return Response.json(
    body: {
      'token': token,
      'message': 'hello there',
    },
  );
}
```

Async value도 provider에서 이용이 가능하다.

```dart
Handler middleware(Handler handler) {
  return handler.use(userProvider()).use(asyncUserProvider());
}

Middleware userProvider() {
  return provider<User>(
    (context) => const User(
      id: '1',
      username: 'john',
      email: 'john@gmail.com',
    ),
  );
}

Middleware asyncUserProvider() {
  return provider<Future<User>>((context) async {
    await Future<void>.delayed(
      const Duration(seconds: 3),
    );

    return const User(
      id: '2',
      username: 'jane',
      email: 'jane@gmail.com',
    );
  });
}

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
```

Provider는 lazy loading 방식으로 동작하기 때문에 `context.read`를 호출하지 않는다면 생성되지 않는다.

## Static Files

Root 경로에 `public` 폴더 내에 static file은 접근이 가능하다.  
예를 들어 `/public/hello.txt`의 static file에 접근하고 싶다면 `localhost/hello.txt`의 경로로 접근이 가능하다.

## Dart Frog Test

사실 어느 플랫폼의 test와 별반 다른건 없어서 코드를 보는게 이해가 빠름.

## Authentication
