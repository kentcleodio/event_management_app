import 'dart:convert';

import 'package:event_management_app/data/constants.dart';
import 'package:event_management_app/domain/repository/auth_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class DbAuthRepo implements AuthRepo {
  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    var userCredentials = {'email': email, 'password': password};

    var response = await http.post(
      Uri.parse(apiUrl + 'login'),
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

      return data;
    } else {
      Map<String, dynamic> data = {
        'statusCode': response.statusCode,
        'message': decodedResponse['message'],
        'errors': decodedResponse['errors'],
      };

      return data;
    }
  }

  @override
  Future<Map<String, dynamic>> register(
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
      Uri.parse(apiUrl + 'register'),
      headers: {'Accept': 'application/json'},
      body: newUser,
    );

    var decodedResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      debugPrint(decodedResponse.toString());
      Map<String, dynamic> data = {
        'statusCode': response.statusCode,
        'message': decodedResponse['status'],
        'user': decodedResponse['data']['user'],
      };

      return data;
    } else {
      debugPrint(decodedResponse.toString());
      Map<String, dynamic> data = {
        'statusCode': response.statusCode,
        'message': decodedResponse['message'],
        'errors': decodedResponse['errors'],
      };

      return data;
    }
  }

  @override
  Future<Map<String, dynamic>> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }
}
