import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/ui/controllers/pin_verification_controller.dart';
import 'package:task_manager/ui/screens/login_screen.dart';
import 'package:task_manager/ui/screens/reset_password_screen.dart';
import 'package:task_manager/ui/widgets/body_background.dart';

import '../widgets/snack_message.dart';

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({super.key, required this.email});

  final String email;

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  String? PIN;
  final PinVerificationController _pinVerificationController =
      Get.find<PinVerificationController>();

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 80),
                      Text(
                        'Pin Verification',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'A 6 digit OTP will be sent to your email address',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 24),
                      PinCodeTextField(
                        length: 6,
                        obscureText: false,
                        animationType: AnimationType.fade,
                        keyboardType: TextInputType.number,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 50,
                          fieldWidth: 40,
                          activeFillColor: Colors.white,
                          activeColor: Colors.green,
                          selectedFillColor: Colors.white,
                          inactiveFillColor: Colors.white,
                        ),
                        animationDuration: const Duration(milliseconds: 300),
                        enableActiveFill: true,
                        onCompleted: (v) {
                          print("Completed");
                        },
                        onChanged: (value) {
                          PIN = value;
                        },
                        beforeTextPaste: (text) {
                          return true;
                        },
                        appContext: context,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: GetBuilder<PinVerificationController>(
                            builder: (pinVerificationController) {
                          return Visibility(
                            visible:
                                pinVerificationController.verifyOTPInProgress ==
                                    false,
                            replacement: const Center(
                              child: CircularProgressIndicator(),
                            ),
                            child: ElevatedButton(
                              onPressed: verifyPIN,
                              child: const Text(
                                'Verify',
                                style: TextStyle(color: Colors.white),
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
        ],
      ),
    );
  }

  Future<void> verifyPIN() async {
    if (PIN?.trim() != null) {
      final response =
          await _pinVerificationController.verifyPIN(widget.email, PIN!.trim());

      if (response) {
        if (mounted) {
          showSnackMessage(context, _pinVerificationController.message);
          Get.off(ResetPasswordScreen(email: widget.email, pin: PIN!.trim()));
        }
      } else {
        if (mounted) {
          showSnackMessage(context, _pinVerificationController.message);
        }
      }
    }
  }
}
