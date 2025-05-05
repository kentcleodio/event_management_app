import 'dart:convert';
import 'package:event_management_app/data/constants.dart';
import 'package:event_management_app/data/notifiers.dart';
import 'package:event_management_app/domain/model/user.dart';
import 'package:event_management_app/domain/repository/auth_repo.dart';
import 'package:http/http.dart' as http;

class DbAuthRepo implements AuthRepo {
  @override
  Future<User> login(String email, String password) async {
    var userCredentials = {'email': email, 'password': password};

    try {
      var response = await http.post(
        Uri.parse('${apiUrl}login'),
        headers: {'Accept': 'application/json'},
        body: userCredentials,
      );

      var decodedResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = {
          'statusCode': response.statusCode,
          'message': decodedResponse['status'],
          'user': decodedResponse['data']['user'],
          'apiToken': decodedResponse['data']['token'],
        };

        final User currentUser = User(
          id: data['user']['id'],
          name: data['user']['name'].toString(),
          email: data['user']['email'].toString(),
        );
        responseNotifier.value = data;
        apiTokenNotifier.value = data['apiToken'];
        return currentUser;
      } else {
        Map<String, dynamic> data = {
          'statusCode': response.statusCode,
          'message': decodedResponse['message'],
          'errors': decodedResponse['errors'],
        };
        responseNotifier.value = data;
        return defaultUser;
      }
    } catch (e) {
      responseNotifier.value = {'statusCode': 500, 'message': e.toString()};
      return defaultUser;
    }
  }

  @override
  Future<void> register(
    String name,
    String email,
    String password,
    String confirmPassword,
  ) async {
    var newUser = {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': confirmPassword,
    };
    var response = await http.post(
      Uri.parse('${apiUrl}register'),
      headers: {'Accept': 'application/json'},
      body: newUser,
    );

    var decodedResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = {
        'statusCode': response.statusCode,
        'message': decodedResponse['status'],
        'user': decodedResponse['data']['user'],
      };

      responseNotifier.value = data;
    } else {
      Map<String, dynamic> data = {
        'statusCode': response.statusCode,
        'message': decodedResponse['message'],
        'errors': decodedResponse['errors'],
      };

      responseNotifier.value = data;
    }
  }

  @override
  Future<User> logout() async {
    try {
      var response = await http.post(
        Uri.parse('${apiUrl}logout'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${apiTokenNotifier.value}',
        },
      );

      var decodedResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = {
          'statusCode': response.statusCode,
          'user': decodedResponse['data']['message'],
        };

        responseNotifier.value = data;
        return defaultUser;
      } else {
        Map<String, dynamic> data = {
          'statusCode': response.statusCode,
          'message': decodedResponse['message'],
        };
        responseNotifier.value = data;
        return defaultUser;
      }
    } catch (e) {
      responseNotifier.value = {'statusCode': 500, 'message': e.toString()};
      return defaultUser;
    }
  }
}
