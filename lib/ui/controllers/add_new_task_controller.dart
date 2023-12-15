import 'package:get/get.dart';

import '../../data/network/network_caller.dart';
import '../../data/network/network_response.dart';
import '../../data/utility/urls.dart';

class AddNewTaskController extends GetxController {
  bool _createTaskInProgress = false;
  bool get getCreateTaskInProgress => _createTaskInProgress;
  String _message = '';
  String get getMessage => _message;

  Future<bool> createTask(String title, String description) async {
    bool isSuccess = false;
    _createTaskInProgress = true;
    update();

    final NetworkResponse response = await NetworkCaller().postRequest(
      Urls.createTask,
      body: {"title": title, "description": description, "status": "New"},
    );
    _createTaskInProgress = false;

    if (response.isSuccess) {
      _message = 'Successfully new task created!';
      isSuccess = true;
    } else {
      _message = 'Create new task failed!';
    }

    update();
    return isSuccess;
  }
}
