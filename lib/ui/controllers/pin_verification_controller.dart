import 'package:get/get.dart';
import 'package:task_manager/ui/screens/reset_password_screen.dart';

import '../../data/network/network_caller.dart';
import '../../data/network/network_response.dart';
import '../../data/utility/urls.dart';

class PinVerificationController extends GetxController {
  bool _verifyOTPInProgress = false;
  bool get verifyOTPInProgress => _verifyOTPInProgress;

  String _message = '';
  String get message => _message;

  Future<bool> verifyPIN(String email, String otp) async {
    bool isSuccess = false;

    _verifyOTPInProgress = true;
    update();
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.verifyOTP(email, otp));
    _verifyOTPInProgress = false;

    if (response.isSuccess && response.jsonResponse["status"] == "success") {
      _message = "Pin verified";
      isSuccess = true;
    } else {
      if (response.statusCode == 401) {
        _message = "Pin is not correct";
      } else {
        _message = "Invalid try again";
      }
    }

    update();
    return isSuccess;
  }
}
