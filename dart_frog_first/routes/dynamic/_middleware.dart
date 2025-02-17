import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler) {
  return handler.use(_dynamicRoutesMiddleware);
}

Handler _dynamicRoutesMiddleware(Handler handler) {
  Future<Response> dynamicRoutesMiddleware(RequestContext context) async {
    print('[dynamic] before request');
    final response = await handler(context);

    print('[dynamic] after request');

    return response;
  }

  return dynamicRoutesMiddleware;
}
