import 'package:event_management_app/data/constants.dart';
import 'package:event_management_app/presentation/event/event_page.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                hintText: 'Search events',
                prefixIcon: const Icon(Icons.search, color: primaryColor),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: LiquidPullToRefresh(
                onRefresh: () async {
                  return await Future.delayed(const Duration(seconds: 1));
                },
                showChildOpacityTransition: false,
                animSpeedFactor: 3,
                color: primaryColor,
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EventPage(),
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(color: Colors.grey),
                        ),
                        elevation: 3,
                        shadowColor: Colors.blueGrey,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text.rich(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          'Event Title Event Title Event Title Event Title Event',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: Icon(
                                        Icons.chevron_right,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'Tue, 01 Apr 2025, 10:10',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: secondaryTextColor,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(imgUrl),
                                    radius: 12,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'John Doe',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
