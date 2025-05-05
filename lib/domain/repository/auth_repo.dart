import 'package:event_management_app/domain/model/user.dart';

abstract class AuthRepo {
  Future<User> login(String email, String password);

  Future<void> register(
    String name,
    String email,
    String password,
    String confirmPassword,
  );

  Future<User> logout();
}
