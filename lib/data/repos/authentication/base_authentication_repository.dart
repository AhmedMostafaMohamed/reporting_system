import 'package:dartz/dartz.dart';
import 'package:reporting_system/data/models/user.dart';

typedef EitherUser<T> = Future<Either<String, T>>;

abstract class BaseAuthRepository {
  EitherUser<String> googleSignInUser();
  EitherUser<User> emailPasswordSignIn(String email, String password);
  EitherUser<String> signOutUser();
}
