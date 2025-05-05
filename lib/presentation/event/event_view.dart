import 'package:event_management_app/data/constants.dart';
import 'package:event_management_app/data/notifiers.dart';
import 'package:event_management_app/data/repository/db_event_repo.dart';
import 'package:event_management_app/domain/model/event.dart';
import 'package:event_management_app/domain/model/user.dart';
import 'package:event_management_app/presentation/event/event_cubit.dart';
import 'package:event_management_app/presentation/event/event_form.dart';
import 'package:event_management_app/presentation/event/event_list_cubit.dart';
import 'package:event_management_app/presentation/widgets/filled_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class EventView extends StatelessWidget {
  final User currentUser;
  final int id;
  const EventView({super.key, required this.id, required this.currentUser});

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

  String formatDate(String date) {
    if (date.isNotEmpty) {
      DateTime parsedDate = DateTime.parse(date);
      String formatted = DateFormat('dd MMM, yyyy HH:mm').format(parsedDate);

      return formatted;
    }
    return '';
  }

  String computeDate(String startDate, String endDate) {
    DateTime start = DateFormat('yyyy-MM-dd HH:mm').parse(startDate);
    DateTime end = DateFormat('yyyy-MM-dd HH:mm').parse(endDate);

    Duration diff = end.difference(start);

    if (diff.inHours < 1) {
      return '${diff.inMinutes.toString()} minutes';
    } else if (diff.inHours == 1) {
      return '${diff.inHours.toString()} hour';
    }
    return '${diff.inHours.toString()} hours';
  }

  @override
  Widget build(BuildContext context) {
    final eventListCubit = context.read<EventListCubit>();
    return BlocBuilder<EventCubit, Event>(
      builder: (context, event) {
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
          floatingActionButton:
              (apiTokenNotifier.value != null && currentUser.id == event.userId)
                  ? FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => BlocProvider(
                                create:
                                    (context) => EventListCubit(DbEventRepo()),
                                child: BlocProvider(
                                  create:
                                      (context) =>
                                          EventCubit(DbEventRepo(), id),
                                  child: EventForm(
                                    isCreate: false,
                                    event: event,
                                  ),
                                ),
                              ),
                        ),
                      );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(Icons.edit),
                  )
                  : null,
          body: ValueListenableBuilder(
            valueListenable: loadingNotifier,
            builder: (context, isLoading, child) {
              return (isLoading || event.id == null)
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
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
                                Text(
                                  event.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Divider(),
                                ListTile(
                                  contentPadding: const EdgeInsets.all(0),
                                  minTileHeight: 0,
                                  title: Text(
                                    '${formatDate(event.startDate)} - ${formatDate(event.endDate)}',
                                  ),
                                  leading: const Icon(Icons.calendar_month),
                                ),
                                ListTile(
                                  contentPadding: const EdgeInsets.all(0),
                                  minTileHeight: 0,
                                  title: Text(
                                    computeDate(event.startDate, event.endDate),
                                  ),
                                  leading: const Icon(Icons.watch_later),
                                ),
                                ListTile(
                                  contentPadding: const EdgeInsets.all(0),
                                  minTileHeight: 0,
                                  title: GestureDetector(
                                    onTap: () => mapSearch(event.location),
                                    child: Text(
                                      event.location,
                                      style: const TextStyle(
                                        color: primaryColor,
                                      ),
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
                                  event.description,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: secondaryTextColor,
                                  ),
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
                                  title: Text(
                                    event.userName!,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  subtitle: Text(
                                    event.userEmail!,
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
                                if (apiTokenNotifier.value != null &&
                                    currentUser.id == event.userId)
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
                                                  onPressed: () async {
                                                    await eventListCubit
                                                        .deleteEvent(event);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  },
                                                  style: FilledButton.styleFrom(
                                                    backgroundColor:
                                                        dangerColor,
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
                  );
            },
          ),
        );
      },
    );
  }
}
