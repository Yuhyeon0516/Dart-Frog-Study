import 'package:basic_auth/user.dart';
import 'package:basic_auth/user_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_auth/dart_frog_auth.dart';

UserRepository? _userRepository;

Handler middleware(Handler handler) {
  return handler
      .use(
        basicAuthentication<User>(
          authenticator: (context, email, password) async {
            final userRepository = context.read<UserRepository>();

            try {
              final user = await userRepository.findUserWithEmailAndPassword(
                email,
                password,
              );

              return user;
            } catch (e) {
              return null;
            }
          },
          applies: (context) async => context.request.method != HttpMethod.post,
        ),
      )
      .use(
        provider<UserRepository>(
          (context) => _userRepository ??= UserRepository(),
        ),
      );
}
