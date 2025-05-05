import 'package:event_management_app/data/repository/db_auth_repo.dart';
import 'package:event_management_app/data/repository/db_event_repo.dart';
import 'package:event_management_app/presentation/auth/auth_cubit.dart';
import 'package:event_management_app/presentation/event/event_cubit.dart';
import 'package:event_management_app/presentation/event/event_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/model/user.dart';

class EventPage extends StatelessWidget {
  final User currentUser;
  final int id;
  const EventPage({super.key, required this.id, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(DbAuthRepo()),
      child: BlocProvider(
        create: (context) => EventCubit(DbEventRepo(), id),
        child: EventView(id: id, currentUser: currentUser),
      ),
    );
  }
}
