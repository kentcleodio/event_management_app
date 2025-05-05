import 'package:event_management_app/data/constants.dart';
import 'package:event_management_app/data/notifiers.dart';
import 'package:event_management_app/domain/model/event.dart';
import 'package:event_management_app/presentation/event/event_cubit.dart';
import 'package:event_management_app/presentation/event/event_list_cubit.dart';
import 'package:event_management_app/presentation/widgets/filled_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

final _formKey = GlobalKey<FormState>();

class EventForm extends StatefulWidget {
  final bool isCreate;
  final Event? event;
  const EventForm({super.key, required this.isCreate, this.event});

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  late TextEditingController titleController = TextEditingController();
  late TextEditingController descController = TextEditingController();
  late TextEditingController startDateController = TextEditingController();
  late TextEditingController endDateController = TextEditingController();
  late TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (!widget.isCreate) {
      titleController = TextEditingController(text: widget.event!.title);
      descController = TextEditingController(text: widget.event!.description);
      startDateController = TextEditingController(
        text: widget.event!.startDate,
      );
      endDateController = TextEditingController(text: widget.event!.endDate);
      locationController = TextEditingController(text: widget.event!.location);
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    locationController.dispose();
    super.dispose();
  }

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
                textController.text = DateFormat(
                  'yyyy-MM-dd HH:mm',
                ).format(pickedDateTime);

                Navigator.pop(context);
              },
              child: const Text('Done'),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final eventListCubit = context.read<EventListCubit>();
    final eventCubit = context.read<EventCubit>();

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
      body: ValueListenableBuilder(
        valueListenable: responseNotifier,
        builder: (context, response, child) {
          return SafeArea(
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
                        controller: titleController,
                        decoration: const InputDecoration(
                          hintText: 'Enter title',
                          label: Text('Title'),
                          prefixIcon: Icon(Icons.title),
                        ),
                        validator: (value) => validate(response, 'title'),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Duration',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: TextFormField(
                              onTap:
                                  () => selectDateTime(
                                    context,
                                    startDateController,
                                  ),
                              controller: startDateController,
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: 'Start',
                                label: const Text('Start'),
                                prefixIcon: const Icon(Icons.calendar_month),
                                prefixIconConstraints: BoxConstraints.tight(
                                  const Size.fromRadius(20),
                                ),
                              ),
                              validator:
                                  (value) => validate(response, 'start_date'),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: TextFormField(
                              onTap:
                                  () => selectDateTime(
                                    context,
                                    endDateController,
                                  ),
                              controller: endDateController,
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: 'End',
                                label: const Text('End'),
                                prefixIcon: const Icon(Icons.calendar_month),
                                prefixIconConstraints: BoxConstraints.tight(
                                  const Size.fromRadius(20),
                                ),
                              ),
                              validator:
                                  (value) => validate(response, 'end_date'),
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: locationController,
                        decoration: const InputDecoration(
                          hintText: 'Enter Location',
                          label: Text('Location'),
                          prefixIcon: Icon(Icons.location_pin),
                        ),
                        validator: (value) => validate(response, 'location'),
                      ),
                      TextFormField(
                        controller: descController,
                        decoration: const InputDecoration(
                          hintText: 'Enter Description',
                          label: Text('Description'),
                          prefixIcon: Icon(Icons.description),
                        ),
                        maxLines: 5,
                        validator: (value) => validate(response, 'description'),
                      ),
                      if (response['statusCode'] == 401)
                        Text(
                          response['message'],
                          style: TextStyle(color: dangerColor),
                        ),
                      const SizedBox(height: 40),
                      ValueListenableBuilder(
                        valueListenable: loadingNotifier,
                        builder: (context, isLoading, child) {
                          return (isLoading)
                              ? const CircularProgressIndicator()
                              : FilledButtonWidget(
                                onPressed: () async {
                                  if (widget.isCreate) {
                                    final Event newEvent = Event(
                                      title: titleController.text,
                                      description: descController.text,
                                      startDate: startDateController.text,
                                      endDate: endDateController.text,
                                      location: locationController.text,
                                    );

                                    await eventListCubit.addEvent(newEvent);
                                    await Future.delayed(
                                      const Duration(milliseconds: 100),
                                    );
                                    debugPrint(response.toString());
                                    _formKey.currentState!.validate();

                                    if (response['statusCode'] == 201 ||
                                        response['statusCode'] == 200) {
                                      Navigator.pop(context);
                                    }
                                  } else {
                                    final Event updateEvent = Event(
                                      id: widget.event!.id,
                                      title: titleController.text,
                                      description: descController.text,
                                      startDate: startDateController.text,
                                      endDate: endDateController.text,
                                      location: locationController.text,
                                    );

                                    await eventCubit.updateEvent(updateEvent);

                                    await Future.delayed(
                                      const Duration(milliseconds: 100),
                                    );

                                    if (_formKey.currentState!.validate()) {
                                      if (response['statusCode'] == 201 ||
                                          response['statusCode'] == 200) {
                                        Navigator.pop(context);
                                      }
                                    }

                                    debugPrint(response.toString());
                                  }
                                },
                                label: (widget.isCreate) ? 'Create' : 'Update',
                              );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String? validate(Map<String, dynamic> response, String inputType) {
    try {
      if (inputType == 'title') {
        if (response['statusCode'] == 422 &&
            response['errors'].containsKey('title')) {
          return response['errors']['title'].toString();
        }
        return null;
      } else if (inputType == 'description') {
        if (response['statusCode'] == 422 &&
            response['errors'].containsKey('description')) {
          return response['errors']['description'].toString();
        }
        return null;
      } else if (inputType == 'start_date') {
        if (response['statusCode'] == 422 &&
            response['errors'].containsKey('start_date')) {
          return response['errors']['start_date'].toString();
        }
        return null;
      } else if (inputType == 'end_date') {
        if (response['statusCode'] == 422 &&
            response['errors'].containsKey('end_date')) {
          return response['errors']['end_date'].toString();
        }
        return null;
      } else if (inputType == 'location') {
        if (response['statusCode'] == 422 &&
            response['errors'].containsKey('location')) {
          return response['errors']['location'].toString();
        }
        return null;
      } else {
        return null;
      }
    } catch (e) {
      responseNotifier.value = {'statusCode': 500, 'message': e};
      return null;
    }
  }
}
