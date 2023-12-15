import 'package:get/get.dart';

import '../../data/network/network_caller.dart';
import '../../data/network/network_response.dart';
import '../../data/utility/urls.dart';

class SignUpController extends GetxController {
  bool _signUpInProgress = false;
  bool get signUpInProgress => _signUpInProgress;
  String _message = '';
  String get message => _message;

  Future<bool> signUp(String email, String firstName, String lastName,
      String mobile, String password) async {
    bool isSuccess = false;
    _signUpInProgress = true;
    update();

    final NetworkResponse response =
        await NetworkCaller().postRequest(Urls.registration, body: {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
      "password": password,
      "photo": ""
    });
    _signUpInProgress = false;

    if (response.isSuccess) {
      isSuccess = true;
      _message = "Successfully account created! Please login.";
    } else {
      _message = "Account creation failed! Please try again.";
    }
    update();
    return isSuccess;
  }
}
