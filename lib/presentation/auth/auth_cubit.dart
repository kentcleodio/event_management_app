import 'package:event_management_app/data/notifiers.dart';
import 'package:event_management_app/domain/repository/auth_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<Map<String, dynamic>> {
  final AuthRepo authRepo;
  AuthCubit(this.authRepo) : super({});

  Future<void> registerUser(
    String name,
    String email,
    String password,
    String confirmPassword,
  ) async {
    loadingNotifier.value = true;
    try {
      final Map<String, dynamic> result = await authRepo.register(
        name,
        email,
        password,
        confirmPassword,
      );
      loadingNotifier.value = false;
      emit(result);
    } catch (e) {
      loadingNotifier.value = false;
      emit({'statusCode': 500, 'message': e});
    }
  }

  Future<void> loginUser(String email, String password) async {
    loadingNotifier.value = true;
    try {
      final Map<String, dynamic> result = await authRepo.login(email, password);
      loadingNotifier.value = false;
      debugPrint(result.toString());
      emit(result);
    } catch (e) {
      loadingNotifier.value = false;
      emit({'statusCode': 500, 'message': e});
      debugPrint(e.toString());
    }
  }
}
