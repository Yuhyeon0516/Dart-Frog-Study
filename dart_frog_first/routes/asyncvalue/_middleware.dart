import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_first/models/user.dart';

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
