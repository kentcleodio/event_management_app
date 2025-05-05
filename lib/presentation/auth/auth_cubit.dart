import 'package:event_management_app/data/constants.dart';
import 'package:event_management_app/data/notifiers.dart';
import 'package:event_management_app/domain/model/user.dart';
import 'package:event_management_app/domain/repository/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<User> {
  final AuthRepo authRepo;
  AuthCubit(this.authRepo) : super(defaultUser);

  Future<void> registerUser(
    String name,
    String email,
    String password,
    String confirmPassword,
  ) async {
    loadingNotifier.value = true;
    try {
      await authRepo.register(name, email, password, confirmPassword);
      if (responseNotifier.value['statusCode'] != 200) {
        loadingNotifier.value = false;
      }
    } catch (e) {
      loadingNotifier.value = false;
      responseNotifier.value = {'statusCode': 500, 'message': e};
    }
  }

  Future<void> loginUser(String email, String password) async {
    loadingNotifier.value = true;
    try {
      final User currentUser = await authRepo.login(email, password);
      loadingNotifier.value = false;
      debugPrint(currentUser.name);
      emit(currentUser);
    } catch (e) {
      loadingNotifier.value = false;
      responseNotifier.value = {'statusCode': 500, 'message': e};
      emit(defaultUser);
    }
  }

  Future<void> logout() async {
    try {
      await authRepo.logout();
    } catch (e) {
      responseNotifier.value = {'statusCode': 500, 'message': e};
    }
  }
}
