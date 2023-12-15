import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/controllers/edit_profile_controller.dart';
import 'package:task_manager/ui/widgets/body_background.dart';
import 'package:task_manager/ui/widgets/profile_summary_card.dart';
import 'package:task_manager/ui/widgets/snack_message.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final EditProfileController _editProfileController =
      Get.find<EditProfileController>();

  final AuthController _authController = Get.find<AuthController>();

  XFile? photo;

  @override
  void initState() {
    super.initState();
    _emailTEController.text = _authController.user?.email ?? '';
    _firstNameTEController.text = _authController.user?.firstName ?? '';
    _lastNameTEController.text = _authController.user?.lastName ?? '';
    _mobileTEController.text = _authController.user?.mobile ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          const ProfileSummary(enableOnTap: false),
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
                          "Update Profile",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        photoPickerField(),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailTEController,
                          decoration: const InputDecoration(hintText: "Email"),
                          validator: (String? value) {
                            if (value?.trim().isEmpty ?? true) {
                              return "Enter valid email";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _firstNameTEController,
                          decoration:
                              const InputDecoration(hintText: "First Name"),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _lastNameTEController,
                          decoration:
                              const InputDecoration(hintText: "Last Name"),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _mobileTEController,
                          decoration: const InputDecoration(hintText: "Phone"),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordTEController,
                          decoration: const InputDecoration(
                              hintText: "Password (optional)"),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: GetBuilder<EditProfileController>(
                              builder: (editProfileController) {
                            return Visibility(
                              visible: editProfileController
                                      .updateProfileInProgress ==
                                  false,
                              replacement: const Center(
                                child: CircularProgressIndicator(),
                              ),
                              child: ElevatedButton(
                                onPressed: updateProfile,
                                child: const Text(
                                  "Update",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          }),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }

  Container photoPickerField() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    topLeft: Radius.circular(8)),
              ),
              height: 50,
              alignment: Alignment.center,
              child: const Text(
                "Photo",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: () async {
                final XFile? image = await ImagePicker()
                    .pickImage(source: ImageSource.camera, imageQuality: 50);

                if (image != null) {
                  photo = image;
                  if (mounted) {
                    setState(() {});
                  }
                }
              },
              child: Visibility(
                visible: photo == null,
                replacement: Text(photo?.name ?? ''),
                child: Container(
                  padding: const EdgeInsets.only(left: 16),
                  child: const Text("Select a photo"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final response = await _editProfileController.updateProfile(
      _emailTEController.text.trim(),
      _firstNameTEController.text.trim(),
      _lastNameTEController.text.trim(),
      _mobileTEController.text.trim(),
      _passwordTEController.text,
      photo,
    );

    if (response) {
      if (mounted) {
        showSnackMessage(context, _editProfileController.message);
      }
    } else {
      if (mounted) {
        showSnackMessage(context, _editProfileController.message);
      }
    }
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
