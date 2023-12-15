import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:task_manager/ui/controllers/completed_task_controller.dart';
import 'package:task_manager/ui/widgets/task_item_card.dart';

import '../widgets/profile_summary_card.dart';

class CompletedTasksScreen extends StatefulWidget {
  const CompletedTasksScreen({super.key});

  @override
  State<CompletedTasksScreen> createState() => _CompletedTasksScreenState();
}

class _CompletedTasksScreenState extends State<CompletedTasksScreen> {
  final CompletedTaskController _completedTaskController =
      Get.find<CompletedTaskController>();

  @override
  void initState() {
    super.initState();
    _completedTaskController.getCompletedTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummary(),
            Expanded(
              child: GetBuilder<CompletedTaskController>(
                  builder: (completedTaskController) {
                return Visibility(
                  visible: completedTaskController.getCompletedTaskInProgress ==
                      false,
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  child: RefreshIndicator(
                    onRefresh: completedTaskController.getCompletedTaskList,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return TaskItemCard(
                          task: completedTaskController
                              .getTaskListModel.taskList![index],
                          onChangeStatus: () {
                            completedTaskController.getCompletedTaskList();
                          },
                          onDelete: () {
                            completedTaskController.getCompletedTaskList();
                          },
                          clipColor: Colors.green,
                          showProgress: (inProgress) {},
                        );
                      },
                      itemCount: completedTaskController
                          .getTaskListModel.taskList?.length,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
