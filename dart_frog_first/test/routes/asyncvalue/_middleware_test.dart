import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_first/models/user.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../routes/asyncvalue/_middleware.dart';

typedef UserCallback = User Function();
typedef FutureUserCallback = Future<User> Function();

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  const tUser1 = User(
    id: '1',
    username: 'john',
    email: 'john@gmail.com',
  );
  const tAsyncUser = User(
    id: '2',
    username: 'jane',
    email: 'jane@gmail.com',
  );

  group('asyncvalue middleware', () {
    test('should provide user instances', () async {
      final handler = middleware((_) => Response());
      final context = _MockRequestContext();

      when(() => context.provide<User>(any(that: isA<UserCallback>())))
          .thenReturn(context);
      when(
        () => context.provide<Future<User>>(
          any(that: isA<FutureUserCallback>()),
        ),
      ).thenReturn(context);

      await handler(context);

      final create = verify(
        () => context.provide<User>(
          captureAny(
            that: isA<UserCallback>(),
          ),
        ),
      ).captured;

      final create0 = create[0] as UserCallback;

      final createAsync = verify(
        () => context.provide<Future<User>>(
          captureAny(
            that: isA<FutureUserCallback>(),
          ),
        ),
      ).captured;

      final createAsync0 = createAsync[0] as FutureUserCallback;

      expect(create0(), equals(tUser1));
      expect(createAsync0(), equals(completion(tAsyncUser)));
    });
  });
}
