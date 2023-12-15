import 'dart:convert';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/user_model.dart';
import '../../data/network/network_caller.dart';
import '../../data/network/network_response.dart';
import '../../data/utility/urls.dart';
import 'auth_controller.dart';

class EditProfileController extends GetxController {
  bool _updateProfileInProgress = false;
  bool get updateProfileInProgress => _updateProfileInProgress;
  String _message = '';
  String get message => _message;
  final AuthController _authController = Get.find<AuthController>();

  Future<bool> updateProfile(String email, String firstName, String lastName,
      String mobile, String? password, XFile? photo) async {
    bool isSuccess = false;
    _updateProfileInProgress = true;
    update();

    String? photoInBase64;
    Map<String, dynamic> inputData = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
    };

    if (password!.isNotEmpty) {
      inputData["password"] = password;
    }

    if (photo != null) {
      List<int> imageBytes = await photo.readAsBytes();
      photoInBase64 = base64Encode(imageBytes);
      inputData["photo"] = photoInBase64;
    }

    final NetworkResponse response =
        await NetworkCaller().postRequest(Urls.updateProfile, body: inputData);

    _updateProfileInProgress = false;

    if (response.isSuccess) {
      Get.find<AuthController>().updateUserInformation(
        UserModel(
          email: email,
          firstName: firstName,
          lastName: lastName,
          mobile: mobile,
          photo: photoInBase64 ?? _authController.user?.photo,
        ),
      );
      _message = "Update profile success";
      isSuccess = true;
    } else {
      _message = "Update profile failed";
    }
    update();
    return isSuccess;
  }
}
