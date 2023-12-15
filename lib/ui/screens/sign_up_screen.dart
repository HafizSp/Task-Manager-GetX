import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:task_manager/ui/controllers/sign_up_controller.dart';
import 'package:task_manager/ui/screens/login_screen.dart';
import 'package:task_manager/ui/widgets/body_background.dart';
import 'package:task_manager/ui/widgets/snack_message.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SignUpController _signUpController = Get.find<SignUpController>();

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
                          'Join With Us',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _emailTEController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'Email',
                          ),
                          autofillHints: const [AutofillHints.email],
                          validator: (String? value) {
                            // EmailValidator.validate(value!);
                            if (value?.trim().isEmpty ?? true) {
                              return "Enter your valid email";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _firstNameTEController,
                          decoration: const InputDecoration(
                            hintText: 'First Name',
                          ),
                          validator: (String? value) {
                            if (value?.trim().isEmpty ?? true) {
                              return "Enter your valid first name";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _lastNameTEController,
                          decoration: const InputDecoration(
                            hintText: 'Last Name',
                          ),
                          validator: (String? value) {
                            if (value?.trim().isEmpty ?? true) {
                              return "Enter your valid last name";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _mobileTEController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            hintText: 'Mobile',
                          ),
                          validator: (String? value) {
                            if (value?.trim().isEmpty ?? true) {
                              return "Enter your valid mobile";
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
                              return "Enter your valid password";
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
                          child: GetBuilder<SignUpController>(
                              builder: (signUpController) {
                            return Visibility(
                              visible:
                                  signUpController.signUpInProgress == false,
                              replacement: const Center(
                                child: CircularProgressIndicator(),
                              ),
                              child: ElevatedButton(
                                onPressed: _signUp,
                                child: const Icon(
                                  Icons.arrow_circle_right_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }),
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

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      final response = await _signUpController.signUp(
          _emailTEController.text.trim(),
          _firstNameTEController.text.trim(),
          _lastNameTEController.text.trim(),
          _mobileTEController.text.trim(),
          _passwordTEController.text);

      if (response) {
        clearTextFields();
        if (mounted) {
          showSnackMessage(context, _signUpController.message);
        }
        Get.offAll(const LoginScreen());
      } else {
        if (mounted) {
          showSnackMessage(
            context,
            _signUpController.message,
            true,
          );
        }
      }
    }
  }

  void clearTextFields() {
    _emailTEController.clear();
    _firstNameTEController.clear();
    _lastNameTEController.clear();
    _mobileTEController.clear();
    _passwordTEController.clear();
  }

  @override
  void dispose() {
    super.dispose();
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
  }
}
