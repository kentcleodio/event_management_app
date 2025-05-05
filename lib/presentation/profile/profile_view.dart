import 'package:event_management_app/data/constants.dart';
import 'package:event_management_app/data/notifiers.dart';
import 'package:event_management_app/data/repository/db_auth_repo.dart';
import 'package:event_management_app/domain/model/user.dart';
import 'package:event_management_app/presentation/auth/auth_cubit.dart';
import 'package:event_management_app/presentation/auth/login_page.dart';
import 'package:event_management_app/presentation/auth/register_page.dart';
import 'package:event_management_app/widget_tree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileView extends StatelessWidget {
  final User currentUser;
  const ProfileView({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 20, 20, 0),
        child:
            (apiTokenNotifier.value != null)
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            backgroundImage: NetworkImage(imgUrl),
                            radius: 80,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            currentUser.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          Text(
                            currentUser.email,
                            style: TextStyle(color: secondaryTextColor),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: .5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text('Logout'),
                                  content: const Text(
                                    '"Are you sure you want to log out?"',
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    FilledButton(
                                      onPressed: () async {
                                        await authCubit.logout();
                                        if (responseNotifier
                                                .value['statusCode'] ==
                                            200) {
                                          apiTokenNotifier.value = null;
                                          selectedPageNotifier.value = 0;
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) => BlocProvider(
                                                    create:
                                                        (context) => AuthCubit(
                                                          DbAuthRepo(),
                                                        ),
                                                    child: const WidgetTree(),
                                                  ),
                                            ),
                                          );
                                        }
                                        Navigator.pop(context);
                                      },
                                      style: FilledButton.styleFrom(
                                        backgroundColor: dangerColor,
                                      ),
                                      child: const Text('Logout'),
                                    ),
                                  ],
                                ),
                          );
                        },
                        title: Text(
                          'Logout',
                          style: TextStyle(color: dangerColor),
                        ),
                      ),
                    ),
                  ],
                )
                : Column(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(60),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const Text(
                      'OR',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(60),
                        side: const BorderSide(color: primaryColor, width: 1),
                      ),
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
