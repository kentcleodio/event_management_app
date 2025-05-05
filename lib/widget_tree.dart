import 'package:event_management_app/data/notifiers.dart';
import 'package:event_management_app/data/repository/db_auth_repo.dart';
import 'package:event_management_app/data/repository/db_event_repo.dart';
import 'package:event_management_app/domain/model/user.dart';
import 'package:event_management_app/presentation/auth/auth_cubit.dart';
import 'package:event_management_app/presentation/auth/login_page.dart';
import 'package:event_management_app/presentation/event/event_cubit.dart';
import 'package:event_management_app/presentation/event/event_list_cubit.dart';
import 'package:event_management_app/presentation/event/event_form.dart';
import 'package:event_management_app/presentation/home/home_view.dart';
import 'package:event_management_app/presentation/profile/profile_view.dart';
import 'package:event_management_app/presentation/widgets/navbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/constants.dart';

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: BlocBuilder<AuthCubit, User>(
        builder: (context, currentUser) {
          final List<Widget> pages = [
            HomeView(currentUser: currentUser),
            ProfileView(currentUser: currentUser),
          ];
          return ValueListenableBuilder(
            valueListenable: selectedPageNotifier,
            builder: (context, selectedPage, child) {
              return pages.elementAt(selectedPage);
            },
          );
        },
      ),
      bottomNavigationBar: const NavbarWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          (apiTokenNotifier.value != null)
              ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => BlocProvider(
                        create: (context) => AuthCubit(DbAuthRepo()),
                        child: BlocProvider(
                          create: (context) => EventListCubit(DbEventRepo()),
                          child: BlocProvider(
                            create: (context) => EventCubit(DbEventRepo(), 0),
                            child: const EventForm(isCreate: true),
                          ),
                        ),
                      ),
                ),
              )
              : Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
        },
        shape: const CircleBorder(),
        backgroundColor: primaryColor,
        foregroundColor: white,
        child: const Icon(Icons.add, size: 50),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
