import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controllers/new_task_controller.dart';
import 'package:task_manager/ui/controllers/task_count_summary_controller.dart';
import 'package:task_manager/ui/widgets/summary_card.dart';

import '../../data/models/task_count.dart';
import '../widgets/profile_summary_card.dart';
import '../widgets/task_item_card.dart';
import 'add_new_task_screen.dart';

class NewTasksScreen extends StatefulWidget {
  const NewTasksScreen({super.key});

  @override
  State<NewTasksScreen> createState() => _NewTasksScreenState();
}

class _NewTasksScreenState extends State<NewTasksScreen> {
  final NewTaskController _newTaskController = Get.find<NewTaskController>();
  final TaskCountSummaryController _taskCountSummaryController =
      Get.find<TaskCountSummaryController>();

  @override
  void initState() {
    super.initState();
    _taskCountSummaryController.getTaskCountSummary();
    _newTaskController.getNewTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummary(),
            GetBuilder<TaskCountSummaryController>(
              builder: (taskCountSummaryController) {
                return Visibility(
                  visible: taskCountSummaryController
                              .getTaskCountSummaryInProgress ==
                          false &&
                      (taskCountSummaryController.getTaskCountSummaryListModel
                              .taskCountList?.isNotEmpty ??
                          false),
                  replacement: const LinearProgressIndicator(),
                  child: SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        TaskCount taskCount = taskCountSummaryController
                            .getTaskCountSummaryListModel.taskCountList![index];
                        return FittedBox(
                          child: SummaryCard(
                            count: taskCount.sum.toString(),
                            title: taskCount.sId ?? '',
                          ),
                        );
                      },
                      itemCount: taskCountSummaryController
                              .getTaskCountSummaryListModel
                              .taskCountList
                              ?.length ??
                          0,
                    ),
                  ),
                );
              },
            ),
            Expanded(
              child: GetBuilder<NewTaskController>(
                builder: (newTaskController) {
                  return Visibility(
                    visible: newTaskController.getNewTaskInProgress == false,
                    replacement: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: RefreshIndicator(
                      onRefresh: () => newTaskController.getNewTaskList(),
                      child: ListView.builder(
                        itemBuilder: (context, index) => TaskItemCard(
                          task: newTaskController
                              .getTaskListModel.taskList![index],
                          onChangeStatus: () {
                            newTaskController.getNewTaskList();
                            _taskCountSummaryController.getTaskCountSummary();
                          },
                          onDelete: () {
                            newTaskController.getNewTaskList();
                            _taskCountSummaryController.getTaskCountSummary();
                          },
                          clipColor: Colors.blue,
                          showProgress: (inProgress) {},
                        ),
                        itemCount: newTaskController
                                .getTaskListModel.taskList?.length ??
                            0,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Get.to(
            AddNewTaskScreen(
              onAddTask: () {
                _newTaskController.getNewTaskList();
                _taskCountSummaryController.getTaskCountSummary();
              },
            ),
          );
        },
      ),
    );
  }
}
