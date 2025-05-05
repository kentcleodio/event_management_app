import 'package:event_management_app/data/constants.dart';
import 'package:event_management_app/data/notifiers.dart';
import 'package:event_management_app/data/repository/db_event_repo.dart';
import 'package:event_management_app/domain/model/event.dart';
import 'package:event_management_app/domain/model/user.dart';
import 'package:event_management_app/presentation/event/event_list_cubit.dart';
import 'package:event_management_app/presentation/event/event_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class HomeView extends StatelessWidget {
  final User currentUser;
  const HomeView({super.key, required this.currentUser});

  String formatDate(String date) {
    String formatted = DateFormat(
      'EEE, dd MMM, yyyy, HH:mm',
    ).format(DateTime.parse(date));

    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    final eventListCubit = context.read<EventListCubit>();
    final searchController = TextEditingController();
    return BlocBuilder<EventListCubit, List<Event>>(
      builder: (context, events) {
        return ValueListenableBuilder(
          valueListenable: loadingNotifier,
          builder: (context, isLoading, child) {
            return SafeArea(
              child:
                  (events != [])
                      ? Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: TextField(
                              controller: searchController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                hintText: 'Search events',
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: primaryColor,
                                ),
                                suffix: FilledButton(
                                  onPressed: () async {
                                    if (searchController.text.isNotEmpty) {
                                      await eventListCubit.searchEvent(
                                        searchController.text,
                                      );
                                    } else {
                                      await eventListCubit.loadEvents();
                                    }
                                  },
                                  style: FilledButton.styleFrom(
                                    backgroundColor: primaryColor,
                                  ),
                                  child: const Text('Search'),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: LiquidPullToRefresh(
                                onRefresh: () async {
                                  await eventListCubit.loadEvents();
                                },
                                showChildOpacityTransition: false,
                                animSpeedFactor: 3,
                                color: primaryColor,
                                child:
                                    (events.isEmpty)
                                        ? const Center(
                                          child: Text('No event found.'),
                                        )
                                        : (isLoading)
                                        ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                        : ListView.builder(
                                          itemCount: events.length,
                                          itemBuilder: (context, index) {
                                            final event = events[index];

                                            return InkWell(
                                              onTap: () async {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => BlocProvider(
                                                          create:
                                                              (
                                                                context,
                                                              ) => EventListCubit(
                                                                DbEventRepo(),
                                                              ),
                                                          child: EventPage(
                                                            currentUser:
                                                                currentUser,
                                                            id: event.id!,
                                                          ),
                                                        ),
                                                  ),
                                                );
                                              },
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  side: const BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                elevation: 3,
                                                shadowColor: Colors.blueGrey,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    20,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text.rich(
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                        maxLines: 2,
                                                        TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: event.title,
                                                              style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                            const WidgetSpan(
                                                              child: Icon(
                                                                Icons
                                                                    .chevron_right,
                                                                size: 20,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Text(
                                                        formatDate(
                                                          event.dateCreated!,
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              secondaryTextColor,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          const CircleAvatar(
                                                            backgroundImage:
                                                                NetworkImage(
                                                                  imgUrl,
                                                                ),
                                                            radius: 12,
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            event.userName!,
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 12,
                                                                ),
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
                      )
                      : const Center(child: Text('No events yet')),
            );
          },
        );
      },
    );
  }
}
