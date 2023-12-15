import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:task_manager/ui/controllers/add_new_task_controller.dart';
import 'package:task_manager/ui/controllers/new_task_controller.dart';
import 'package:task_manager/ui/widgets/body_background.dart';
import 'package:task_manager/ui/widgets/profile_summary_card.dart';
import 'package:task_manager/ui/widgets/snack_message.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key, required this.onAddTask});

  final VoidCallback onAddTask;

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AddNewTaskController _addNewTaskController =
      Get.find<AddNewTaskController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummary(),
            Expanded(
              child: BodyBackground(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 32),
                          Text(
                            "Add New Task",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          TextFormField(
                            controller: _titleTEController,
                            decoration:
                                const InputDecoration(hintText: "Title"),
                            validator: (String? value) {
                              if (value?.trim().isEmpty ?? true) {
                                return "Enter valid title";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _descriptionTEController,
                            maxLines: 4,
                            decoration:
                                const InputDecoration(hintText: "Description"),
                            validator: (String? value) {
                              if (value?.trim().isEmpty ?? true) {
                                return "Enter valid description";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: GetBuilder<AddNewTaskController>(
                                builder: (addNewTaskController) {
                              return Visibility(
                                visible: addNewTaskController
                                        .getCreateTaskInProgress ==
                                    false,
                                replacement: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                child: ElevatedButton(
                                  onPressed: createTask,
                                  child: const Text(
                                    "Add",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> createTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final response = await _addNewTaskController.createTask(
        _titleTEController.text.trim(), _descriptionTEController.text.trim());

    if (response) {
      widget.onAddTask();
      _titleTEController.clear();
      _descriptionTEController.clear();
      Get.find<NewTaskController>().getNewTaskList();
      if (mounted) {
        showSnackMessage(context, _addNewTaskController.getMessage);
      }
    } else {
      if (mounted) {
        showSnackMessage(context, _addNewTaskController.getMessage, true);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _titleTEController.dispose();
    _descriptionTEController.dispose();
  }
}
