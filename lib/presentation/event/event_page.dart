import 'package:event_management_app/presentation/event/event_cubit.dart';
import 'package:event_management_app/presentation/event/event_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventPage extends StatelessWidget {
  const EventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventCubit(0),
      child: const EventView(),
    );
  }
}
