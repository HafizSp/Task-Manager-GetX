import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/data/models/user_model.dart';

class AuthController extends GetxController {
  static String? token;
  UserModel? user;

  Future<void> saveUserInformation(String t, UserModel model) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('token', t);
    await preferences.setString('user', jsonEncode(model.toJson()));
    token = t;
    user = model;
    update();
  }

  Future<void> updateUserInformation(UserModel model) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('user', jsonEncode(model.toJson()));
    user = model;
    update();
  }

  Future<void> initializeUserCache() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token');
    user =
        UserModel.fromJson(jsonDecode(preferences.getString('user') ?? '{}'));
    update();
  }

  Future<bool> checkAuthState() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey('token')) {
      initializeUserCache();
      return true;
    }
    return false;
  }

  static Future<void> clearAuthData() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    token = null;
  }
}
