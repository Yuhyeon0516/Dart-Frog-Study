import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler) {
  return handler
      .use(_rootMiddlewareOne)
      .use(_rootMiddlewareTwo)
      .use(requestLogger())
      .use(tokenProvider());
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

Middleware tokenProvider() {
  return provider((context) => '1234xyz');
}
