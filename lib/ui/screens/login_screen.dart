import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:task_manager/data/models/user_model.dart';
import 'package:task_manager/data/network/network_caller.dart';
import 'package:task_manager/data/network/network_response.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/controllers/login_controller.dart';
import 'package:task_manager/ui/screens/forgot_password_screen.dart';
import 'package:task_manager/ui/screens/sign_up_screen.dart';
import 'package:task_manager/ui/widgets/body_background.dart';
import 'package:task_manager/ui/widgets/snack_message.dart';

import '../../data/utility/urls.dart';
import 'main_bottom_nav_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loginInProgress = false;
  final LoginController _loginController = Get.find<LoginController>();

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
                          'Get Started With',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _emailTEController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'Email',
                          ),
                          validator: (String? value) {
                            if (value?.trim().isEmpty ?? true) {
                              return "Enter valid email";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordTEController,
                          obscureText: true,
                          decoration:
                              const InputDecoration(hintText: 'Password'),
                          validator: (String? value) {
                            if (value?.isEmpty ?? true) {
                              return "Enter valid password";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: GetBuilder<LoginController>(
                              builder: (loginController) {
                            return Visibility(
                              visible: loginController.loginInProgress == false,
                              replacement: const Center(
                                child: CircularProgressIndicator(),
                              ),
                              child: ElevatedButton(
                                onPressed: login,
                                child: const Icon(
                                  Icons.arrow_circle_right_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 48),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Get.to(const ForgotPasswordScreen());
                            },
                            child: const Text(
                              'Forget Password',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account?",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w600),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.to(const SignUpScreen());
                              },
                              child: const Text(
                                'Sign Up',
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

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final response = await _loginController.login(
        _emailTEController.text.trim(), _passwordTEController.text);

    if (response) {
      Get.offAll(const MainBottomNavScreen());
    } else {
      if (mounted) {
        showSnackMessage(context, _loginController.failureMessage);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailTEController.dispose();
    _passwordTEController.dispose();
  }
}
