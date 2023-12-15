import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:task_manager/data/network/network_caller.dart';
import 'package:task_manager/data/network/network_response.dart';
import 'package:task_manager/data/utility/urls.dart';
import 'package:task_manager/ui/controllers/reset_password_controller.dart';
import 'package:task_manager/ui/widgets/body_background.dart';
import 'package:task_manager/ui/widgets/snack_message.dart';

import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen(
      {super.key, required this.email, required this.pin});

  final String email;
  final String pin;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordTEController =
      TextEditingController();
  final TextEditingController _confirmPasswordTEController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ResetPasswordController _resetPasswordController =
      Get.find<ResetPasswordController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BodyBackground(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 80),
                        Text(
                          'Reset Password',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Minimum password length should be 8 letters',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _newPasswordTEController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'New Password',
                          ),
                          validator: (String? value) {
                            if (value?.isEmpty ?? true) {
                              return "Enter a valid password";
                            }
                            if (value!.length < 6) {
                              return "Password length must be more than 6 character";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _confirmPasswordTEController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'Confirm Password',
                          ),
                          validator: (String? value) {
                            if (value?.isEmpty ?? true) {
                              return "Enter a valid password";
                            }
                            if (value!.length < 6) {
                              return "Password length must be more than 6 character";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: GetBuilder<ResetPasswordController>(
                            builder: (resetPasswordController) {
                              return Visibility(
                                visible: resetPasswordController
                                        .resetPasswordInProgress ==
                                    false,
                                replacement: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                child: ElevatedButton(
                                  onPressed: resetPassword,
                                  child: const Text(
                                    'Confirm',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 48),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Have an account?",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w600),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.to(const LoginScreen());
                              },
                              child: const Text(
                                'Sign In',
                                style: TextStyle(fontSize: 16),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> resetPassword() async {
    if (_formKey.currentState!.validate() &&
        _newPasswordTEController.text == _confirmPasswordTEController.text) {
      final response = await _resetPasswordController.resetPassword(
          widget.email, widget.pin, _confirmPasswordTEController.text);

      if (response) {
        if (mounted) {
          showSnackMessage(context, _resetPasswordController.message);
        }
        Get.offAll(const LoginScreen());
      } else {
        if (mounted) {
          showSnackMessage(context, _resetPasswordController.message);
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _newPasswordTEController.dispose();
    _confirmPasswordTEController.dispose();
  }
}
