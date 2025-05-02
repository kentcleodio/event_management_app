import 'package:event_management_app/data/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class NavbarWidget extends StatelessWidget {
  const NavbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return StylishBottomBar(
          notchStyle: NotchStyle.circle,
          option: BubbleBarOptions(
            inkEffect: true,
            iconSize: 30,
            inkColor: Colors.tealAccent,
            barStyle: BubbleBarStyle.vertical,
            bubbleFillStyle: BubbleFillStyle.fill,
            opacity: 0.3,
          ),

          fabLocation: StylishBarFabLocation.center,
          hasNotch: true,
          items: [
            BottomBarItem(
              icon: const Icon(Icons.home),
              title: const Text('Home'),
              backgroundColor: Colors.teal,
              unSelectedColor: Colors.black,
            ),

            BottomBarItem(
              icon: const Icon(Icons.person),
              title: const Text('Cabin'),
              backgroundColor: Colors.teal,
              unSelectedColor: Colors.black,
            ),
          ],
          currentIndex: selectedPage,
          onTap: (index) {
            selectedPageNotifier.value = index;
          },
        );
      },
    );
  }
}
