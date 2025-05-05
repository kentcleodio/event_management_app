import 'package:event_management_app/domain/repository/event_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/notifiers.dart';
import '../../domain/model/event.dart';

class EventListCubit extends Cubit<List<Event>> {
  final EventRepo eventRepo;
  EventListCubit(this.eventRepo) : super([]) {
    loadEvents();
  }

  Future<void> loadEvents() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      loadingNotifier.value = true;
      try {
        final eventList = await eventRepo.getEvents();
        emit(eventList);
        loadingNotifier.value = false;
      } catch (e) {
        loadingNotifier.value = false;
        responseNotifier.value = {'statusCode': 500, 'message': e};
        debugPrint('Load Events: ${e.toString()}');
      }
    });
  }

  Future<void> addEvent(Event newEvent) async {
    loadingNotifier.value = true;
    try {
      await eventRepo.createEvent(newEvent);

      if (responseNotifier.value['statusCode'] != 200) {
        loadingNotifier.value = false;
      }
    } catch (e) {
      loadingNotifier.value = false;
      responseNotifier.value = {'statusCode': 500, 'message': e};
      debugPrint('Add Event: ${e.toString()}');
    }
  }

  Future<void> deleteEvent(Event event) async {
    try {
      await eventRepo.deleteEvent(event);
    } catch (e) {
      responseNotifier.value = {'statusCode': 500, 'message': e};
      debugPrint('Delete Event: ${e.toString()}');
    }
  }

  Future<void> searchEvent(String text) async {
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        loadingNotifier.value = true;
        try {
          final List<Event> eventList = await eventRepo.searchEvent(text);
          emit(eventList);
          loadingNotifier.value = false;
        } catch (e) {
          loadingNotifier.value = false;
          responseNotifier.value = {'statusCode': 500, 'message': e};
          debugPrint('Search Events: ${e.toString()}');
        }
      });
    } catch (e) {
      responseNotifier.value = {'statusCode': 500, 'message': e};
      debugPrint('Search Event: ${e.toString()}');
    }
  }
}
