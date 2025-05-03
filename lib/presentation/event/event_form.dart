import 'package:event_management_app/data/constants.dart';
import 'package:event_management_app/presentation/widgets/filled_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final _formKey = GlobalKey<FormState>();

class EventForm extends StatefulWidget {
  final bool isCreate;
  final int? id;
  const EventForm({super.key, required this.isCreate, this.id});

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final locationController = TextEditingController();

  void selectDateTime(
    BuildContext context,
    TextEditingController textController,
  ) {
    DateTime pickedDateTime = DateTime.now();

    showCupertinoModalPopup(
      context: context,
      builder:
          (context) => CupertinoActionSheet(
            actions: [
              SizedBox(
                height: 250,
                child: CupertinoDatePicker(
                  onDateTimeChanged: (DateTime value) {
                    pickedDateTime = value;
                  },
                  use24hFormat: true,
                  minimumDate: DateTime.now(),
                  maximumDate: DateTime(2100),
                  initialDateTime: DateTime.now(),
                ),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                setState(() {
                  textController.text = DateFormat(
                    'yyyy-MM-dd HH:mm',
                  ).format(pickedDateTime);
                });
                Navigator.pop(context);
              },
              child: const Text('Done'),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Exit without finishing?'),
                      content: Text(
                        "If you leave now, your event won't be ${(widget.isCreate) ? 'created' : 'updated'}.",
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: const Text('Exit'),
                        ),
                        FilledButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Continue editing'),
                        ),
                      ],
                    ),
              );
            },
            icon: const Icon(Icons.clear),
          ),
        ],
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
                    (widget.isCreate) ? 'Create Event' : 'Update Task',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 34,
                      letterSpacing: 4,
                    ),
                  ),
                  TextFormField(
                    controller: (widget.isCreate) ? titleController : null,
                    initialValue: (!widget.isCreate) ? 'Event 1' : null,
                    decoration: const InputDecoration(
                      hintText: 'Enter title',
                      label: Text('Title'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Duration',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: TextFormField(
                          onTap:
                              () =>
                                  selectDateTime(context, startDateController),
                          controller: startDateController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            hintText: 'Start',
                            label: Text('Start'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: TextFormField(
                          onTap:
                              () => selectDateTime(context, endDateController),
                          controller: endDateController,
                          decoration: const InputDecoration(
                            hintText: 'End',
                            label: Text('End'),
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
                  FilledButtonWidget(onPressed: () {}, label: 'Create'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
