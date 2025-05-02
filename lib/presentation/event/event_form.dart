import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:event_management_app/data/constants.dart';
import 'package:flutter/material.dart';

final _formKey = GlobalKey<FormState>();

class EventForm extends StatelessWidget {
  final bool isCreate;
  final int? id;
  const EventForm({super.key, required this.isCreate, this.id});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final startDateController = TextEditingController();
    final startTimeController = TextEditingController();
    final endDateController = TextEditingController();
    final endTimeController = TextEditingController();
    final locationController = TextEditingController();
    final DateTime date = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.clear))],
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            width: double.infinity,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    (isCreate) ? 'Create Event' : 'Update Task',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 34,
                      letterSpacing: 4,
                    ),
                  ),
                  Stack(
                    children: [
                      DottedBorder(
                        borderType: BorderType.RRect,
                        strokeWidth: 2,
                        dashPattern: [6, 3],
                        color: Colors.teal,
                        radius: const Radius.circular(15),
                        child:
                            (isCreate)
                                ? Container(
                                  color: const Color.fromARGB(
                                    47,
                                    100,
                                    255,
                                    219,
                                  ),
                                  width: double.infinity,
                                  height: 150,
                                )
                                : const Image(
                                  image: NetworkImage(imgUrl),
                                  width: double.infinity,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                      ),
                      Positioned(
                        top: 55,
                        left: 110,
                        child: FilledButton.icon(
                          onPressed: () {},
                          label: Text(
                            (isCreate) ? 'Upload Cover' : 'Change Cover',
                          ),
                          icon: const Icon(Icons.image),
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: (isCreate) ? titleController : null,
                    initialValue: (!isCreate) ? 'Event 1' : null,
                    decoration: const InputDecoration(
                      hintText: 'Enter title',
                      label: Text('Title'),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: startDateController,
                          decoration: const InputDecoration(
                            hintText: 'Choose date',
                            label: Text('Start date'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: TextFormField(
                          controller: startTimeController,
                          decoration: const InputDecoration(
                            hintText: 'Choose time',
                            label: Text('Start time'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: endDateController,
                          decoration: const InputDecoration(
                            hintText: 'Choose date',
                            label: Text('End date'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: TextFormField(
                          controller: endTimeController,
                          decoration: const InputDecoration(
                            hintText: 'Choose time',
                            label: Text('End time'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: locationController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Location',
                      label: Text('Location'),
                    ),
                  ),
                  TextFormField(
                    controller: descController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Description',
                      label: Text('Description'),
                    ),
                    maxLines: 5,
                  ),
                  const SizedBox(height: 40),
                  FilledButton(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text(
                      'Create',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
