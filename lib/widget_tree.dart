import 'package:event_management_app/data/notifiers.dart';
import 'package:event_management_app/presentation/auth/login_page.dart';
import 'package:event_management_app/presentation/event/event_form.dart';
import 'package:event_management_app/presentation/widgets/navbar_widget.dart';
import 'package:flutter/material.dart';

import 'data/constants.dart';
import 'domain/model/user.dart';

class WidgetTree extends StatelessWidget {
  final User currentUser;
  const WidgetTree({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (context, selectedPage, child) {
          return pages.elementAt(selectedPage);
        },
      ),
      bottomNavigationBar: const NavbarWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          (false)
              ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EventForm(isCreate: true),
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
