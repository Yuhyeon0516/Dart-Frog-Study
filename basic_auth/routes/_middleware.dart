import 'package:basic_auth/jwt_service.dart';
import 'package:basic_auth/user.dart';
import 'package:basic_auth/user_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_auth/dart_frog_auth.dart';

UserRepository? _userRepository;
JwtService? _jwtService;

Handler middleware(Handler handler) {
  return handler
      .use(
        bearerAuthentication<User>(
          authenticator: (context, token) async {
            final jwtService = context.read<JwtService>();
            final payload = jwtService.verify(token);
            if (payload == null) {
              return null;
            }

            final userRepository = context.read<UserRepository>();

            try {
              final user = await userRepository.findUserById(
                payload['id'] as String,
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
      )
      .use(
        provider<JwtService>(
          (context) => _jwtService ??= JwtService(),
        ),
      );
}
