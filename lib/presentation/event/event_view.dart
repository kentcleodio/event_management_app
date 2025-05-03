import 'package:event_management_app/data/constants.dart';
import 'package:event_management_app/presentation/event/event_form.dart';
import 'package:event_management_app/presentation/widgets/filled_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EventView extends StatelessWidget {
  const EventView({super.key});

  void mapSearch(String location) async {
    final encodedQuery = Uri.encodeComponent(location);
    final googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$encodedQuery';

    try {
      await launchUrl(
        Uri.parse(googleMapsUrl),
        mode: LaunchMode.externalApplication,
      );
    } on Exception catch (e) {
      debugPrint("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            CupertinoIcons.chevron_left_circle_fill,
            size: 40,
            color: primaryColor,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EventForm(isCreate: false),
            ),
          );
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        child: const Icon(Icons.edit),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    const Text(
                      'Event Title',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Divider(),
                    const ListTile(
                      contentPadding: EdgeInsets.all(0),
                      minTileHeight: 0,
                      title: Text('Tue, 01 Apr 2025, 10:10 - 31 Dec 22:00'),
                      leading: Icon(Icons.calendar_month),
                    ),
                    const ListTile(
                      contentPadding: EdgeInsets.all(0),
                      minTileHeight: 0,
                      title: Text('120 minutes'),
                      leading: Icon(Icons.watch_later),
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      minTileHeight: 0,
                      title: GestureDetector(
                        onTap: () => mapSearch('Panabo City'),
                        child: const Text(
                          'Panabo City',
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                      leading: const Icon(Icons.location_pin),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'This is the Description This is the Description This is the Description This is the Description This is the Description This is the Description This is the Description This is the Description This is the Description This is the Description This is the Description This is the Description This is the Description This is the Description This is the Description This is the Description ',
                      style: TextStyle(fontSize: 16, color: secondaryTextColor),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Hosted',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      minTileHeight: 0,
                      title: const Text(
                        'John Doe',
                        style: TextStyle(fontSize: 14),
                      ),
                      subtitle: Text(
                        'test@email.com',
                        style: TextStyle(
                          fontSize: 12,
                          color: secondaryTextColor,
                        ),
                      ),
                      leading: const CircleAvatar(
                        backgroundImage: NetworkImage(imgUrl),
                      ),
                    ),
                    const SizedBox(height: 10),
                    FilledButtonWidget(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text('Delete Event'),
                                content: const Text(
                                  'Are you sure you want to delete this event? This action cannot be undone.',
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  FilledButton(
                                    onPressed: () {
                                      Navigator.popUntil(
                                        context,
                                        (route) => route.isFirst,
                                      );
                                    },
                                    style: FilledButton.styleFrom(
                                      backgroundColor: dangerColor,
                                    ),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                        );
                      },

                      label: 'DELETE EVENT',
                      backgroundColor: dangerColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
