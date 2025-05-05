import 'package:event_management_app/data/constants.dart';
import 'package:event_management_app/domain/model/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/notifiers.dart';
import '../../domain/repository/event_repo.dart';

class EventCubit extends Cubit<Event> {
  final EventRepo eventRepo;
  final int eventId;
  EventCubit(this.eventRepo, this.eventId) : super(defaultEvent) {
    loadEvent(eventId);
  }

  Future<void> loadEvent(int id) async {
    Future.microtask(() => loadingNotifier.value = true);
    try {
      final event = await eventRepo.getSingleEvent(id);
      emit(event);
      loadingNotifier.value = false;
    } catch (e) {
      loadingNotifier.value = false;
      responseNotifier.value = {'statusCode': 500, 'message': e};
      debugPrint('Load Event: ${e.toString()}');
    }
  }

  Future<void> updateEvent(Event event) async {
    loadingNotifier.value = true;
    try {
      await eventRepo.updateEvent(event);
      loadingNotifier.value = false;
    } catch (e) {
      loadingNotifier.value = false;
      responseNotifier.value = {'statusCode': 500, 'message': e};
      debugPrint('Update Event: ${e.toString()}');
    }
    loadEvent(event.id!);
  }
}
