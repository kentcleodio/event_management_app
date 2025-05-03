import 'package:event_management_app/data/constants.dart';
import 'package:event_management_app/data/notifiers.dart';
import 'package:event_management_app/domain/model/user.dart';
import 'package:event_management_app/presentation/auth/auth_cubit.dart';
import 'package:event_management_app/presentation/auth/register_page.dart';
import 'package:event_management_app/presentation/widgets/filled_button_widget.dart';
import 'package:event_management_app/widget_tree.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _formKey = GlobalKey<FormState>();

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final emailController = TextEditingController();
    final passController = TextEditingController();
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
            if (_formKey.currentState!.validate()) {
              final currentUser = User(
                id: result['user']['id'],
                name: result['user']['name'],
                email: result['user']['email'],
                apiToken: result['apiToken'],
              );

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => WidgetTree(currentUser: currentUser),
                ),
              );
            }
          });
        },
        child: BlocBuilder<AuthCubit, Map<String, dynamic>>(
          builder: (context, result) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'LOGIN',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 34,
                        letterSpacing: 4,
                      ),
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        hintText: 'Enter your email',
                        label: Text('EMAIL'),
                      ),
                      validator: (value) => validateInput(result, 'email'),
                    ),
                    ValueListenableBuilder(
                      valueListenable: showPasswordNotifier,
                      builder: (context, showPassword, child) {
                        return TextFormField(
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
                          validator:
                              (value) => validateInput(result, 'password'),
                        );
                      },
                    ),
                    (result['statusCode'] == 401 || result['statusCode'] == 500)
                        ? Text(
                          result['message'].toString(),
                          style: TextStyle(color: dangerColor),
                        )
                        : Container(),

                    FilledButtonWidget(
                      onPressed: () {
                        authCubit.loginUser(
                          emailController.text,
                          passController.text,
                        );

                        showPasswordNotifier.value = false;
                        // final User(id: id, name: name, email: email, apiToken: apiToken,);
                      },
                      label: 'Login',
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            showPasswordNotifier.value = false;
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            );
                          },
                          child: const Text('Register'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String? validateInput(Map<String, dynamic> result, String inputType) {
    if (inputType == 'email') {
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
