import 'package:event_management_app/data/constants.dart';
import 'package:event_management_app/presentation/event/event_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventView extends StatelessWidget {
  const EventView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
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
              Stack(
                children: [
                  const Image(
                    image: NetworkImage(imgUrl),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 350,
                  ),
                  Positioned(
                    top: 25,
                    left: 5,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        CupertinoIcons.chevron_left_circle_fill,
                        size: 40,
                        color: Color.fromARGB(157, 100, 255, 219),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,

                padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    const Text(
                      'Event Title Event Title EventTitleEventTitle Event Title Event Title',
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
                    ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      minTileHeight: 0,
                      title: GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'Panabo City',
                          style: TextStyle(color: Colors.teal),
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
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
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
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      leading: const CircleAvatar(
                        backgroundImage: NetworkImage(imgUrl),
                      ),
                    ),
                    const SizedBox(height: 10),
                    FilledButton(
                      onPressed: () {},

                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(40),
                        backgroundColor: Colors.red,
                      ),
                      child: const Text(
                        'DELETE EVENT',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
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
