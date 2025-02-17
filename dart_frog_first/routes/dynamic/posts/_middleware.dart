import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler) {
  return handler.use(_postsRoutesMiddleware);
}

Handler _postsRoutesMiddleware(Handler handler) {
  return (RequestContext context) async {
    print('[posts] before request');
    final response = await handler(context);

    print('[posts] after request');

    return response;
  };
}
