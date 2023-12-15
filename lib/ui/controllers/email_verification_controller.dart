import 'package:get/get.dart';

import '../../data/network/network_caller.dart';
import '../../data/network/network_response.dart';
import '../../data/utility/urls.dart';

class EmailVerificationController extends GetxController {
  bool _verifyEmailInProgress = false;
  bool get verifyEmailInProgress => _verifyEmailInProgress;

  String _message = '';
  String get message => _message;

  Future<bool> verifyEmail(String email) async {
    bool isSuccess = false;

    _verifyEmailInProgress = true;
    update();

    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.verifyEmail(email));

    _verifyEmailInProgress = false;

    if (response.isSuccess && response.jsonResponse["status"] == "success") {
      _message = "Email Verification Successful!";
      isSuccess = true;
    } else {
      if (response.statusCode == 401) {
        _message = "Please give the correct email";
      } else {
        _message = "Invalid try again";
      }
    }

    update();
    return isSuccess;
  }
}
