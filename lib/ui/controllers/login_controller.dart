import 'package:get/get.dart';

import '../../data/models/user_model.dart';
import '../../data/network/network_caller.dart';
import '../../data/network/network_response.dart';
import '../../data/utility/urls.dart';
import 'auth_controller.dart';

class LoginController extends GetxController {
  bool _loginInProgress = false;
  bool get loginInProgress => _loginInProgress;

  String _failedMessage = '';
  String get failureMessage => _failedMessage;

  Future<bool> login(String email, String password) async {
    _loginInProgress = true;
    update();
    NetworkResponse response = await NetworkCaller().postRequest(
      Urls.login,
      body: {"email": email, "password": password},
      isLogin: true,
    );
    _loginInProgress = false;
    update();

    if (response.isSuccess) {
      await Get.find<AuthController>().saveUserInformation(
          response.jsonResponse['token'],
          UserModel.fromJson(response.jsonResponse['data']));
      return true;
    } else {
      if (response.statusCode == 401) {
        _failedMessage = "Email/password is wrong";
      } else {
        _failedMessage = "Login failed, try again";
      }
    }
    return false;
  }
}
