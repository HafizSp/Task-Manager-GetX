import 'package:get/get.dart';
import 'package:task_manager/ui/screens/login_screen.dart';

import '../../data/network/network_caller.dart';
import '../../data/network/network_response.dart';
import '../../data/utility/urls.dart';

class ResetPasswordController extends GetxController {
  bool _resetPasswordInProgress = false;
  bool get resetPasswordInProgress => _resetPasswordInProgress;

  String _message = '';
  String get message => _message;

  Future<bool> resetPassword(String email, String pin, String password) async {
    bool isSuccess = false;
    _resetPasswordInProgress = true;
    update();
    Map<String, dynamic> item = {
      "email": email,
      "OTP": pin,
      "password": password,
    };

    final NetworkResponse response =
        await NetworkCaller().postRequest(Urls.resetPassword, body: item);

    _resetPasswordInProgress = false;

    if (response.isSuccess && response.jsonResponse["status"] == "success") {
      _message = "Successfully password reset!";
      isSuccess = true;
    } else {
      if (response.statusCode == 401) {
        _message = "Please check password";
      } else {
        _message = "Password reset failed";
      }
    }
    update();
    return isSuccess;
  }
}
