import 'package:event_management_app/domain/model/event.dart';

abstract class EventRepo {
  Future<void> createEvent(Event newEvent);

  Future<List<Event>> getEvents();

  Future<void> updateEvent(Event event);

  Future<void> deleteEvent(Event event);

  Future<void> searchEvent(String text);
}
