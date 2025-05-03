import 'package:event_management_app/data/constants.dart';
import 'package:event_management_app/data/notifiers.dart';
import 'package:event_management_app/presentation/auth/auth_cubit.dart';
import 'package:event_management_app/presentation/auth/login_page.dart';
import 'package:event_management_app/presentation/widgets/filled_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _formKey = GlobalKey<FormState>();

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passController = TextEditingController();
    final confirmPassController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            showPasswordNotifier.value = false;
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          icon: const Icon(
            CupertinoIcons.chevron_left_circle_fill,
            size: 40,
            color: primaryColor,
          ),
        ),
      ),
      body: BlocListener<AuthCubit, Map<String, dynamic>>(
        listener: (context, result) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _formKey.currentState?.validate();
          });
        },
        child: BlocBuilder<AuthCubit, Map<String, dynamic>>(
          builder: (context, result) {
            return ValueListenableBuilder(
              valueListenable: showPasswordNotifier,
              builder: (context, showPassword, child) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      spacing: 20,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'REGISTER',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 34,
                            letterSpacing: 4,
                          ),
                        ),
                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                            hintText: 'Enter your name',
                            label: Text('NAME'),
                          ),
                          validator: (value) => validate(result, 'name'),
                        ),
                        TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                            hintText: 'Enter your email',
                            label: Text('EMAIL'),
                          ),
                          validator: (value) => validate(result, 'email'),
                        ),
                        TextFormField(
                          controller: passController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                            hintText: 'Enter your password',
                            label: const Text('PASSWORD'),
                            suffixIcon: IconButton(
                              onPressed: () {
                                showPasswordNotifier.value = !showPassword;
                              },
                              icon: Icon(
                                (showPassword)
                                    ? CupertinoIcons.eye_slash_fill
                                    : CupertinoIcons.eye_fill,
                              ),
                            ),
                          ),
                          obscureText: !showPassword,
                          validator: (value) => validate(result, 'password'),
                        ),
                        TextFormField(
                          controller: confirmPassController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                            hintText: 'Confirm password',
                            label: const Text('CONFIRM PASSWORD'),
                            suffixIcon: IconButton(
                              onPressed: () {
                                showPasswordNotifier.value = !showPassword;
                              },
                              icon: Icon(
                                (showPassword)
                                    ? CupertinoIcons.eye_slash_fill
                                    : CupertinoIcons.eye_fill,
                              ),
                            ),
                          ),
                          obscureText: !showPassword,
                        ),
                        ValueListenableBuilder(
                          valueListenable: loadingNotifier,
                          builder: (context, isLoading, child) {
                            return (isLoading)
                                ? const CircularProgressIndicator()
                                : FilledButtonWidget(
                                  onPressed: () {
                                    authCubit.registerUser(
                                      nameController.text,
                                      emailController.text,
                                      passController.text,
                                      confirmPassController.text,
                                    );
                                    showPasswordNotifier.value = false;
                                  },
                                  label: 'Register',
                                );
                          },
                        ),

                        (result['statusCode'] == 200)
                            ? const Text('Registered successfully')
                            : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Already have an account?"),
                                TextButton(
                                  onPressed: () {
                                    showPasswordNotifier.value = false;
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LoginPage(),
                                      ),
                                    );
                                  },
                                  child: const Text('Login'),
                                ),
                              ],
                            ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  String? validate(Map<String, dynamic> result, String inputType) {
    if (inputType == 'name') {
      if (result['statusCode'] == 422 && result['errors'].containsKey('name')) {
        return result['errors']['name'].toString();
      }
      return null;
    } else if (inputType == 'email') {
      if (result['statusCode'] == 422 &&
          result['errors'].containsKey('email')) {
        return result['errors']['email'].toString();
      }
      return null;
    } else if (inputType == 'password') {
      if (result['statusCode'] == 422 &&
          result['errors'].containsKey('password')) {
        return result['errors']['password'].toString();
      }
      return null;
    } else {
      return null;
    }
  }
}
