import 'dart:convert';

import 'package:event_management_app/data/constants.dart';
import 'package:event_management_app/data/notifiers.dart';
import 'package:event_management_app/domain/model/event.dart';
import 'package:event_management_app/domain/repository/event_repo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DbEventRepo implements EventRepo {
  @override
  Future<List<Event>> getEvents() async {
    try {
      var response = await http.get(
        Uri.parse('${apiUrl}events'),
        headers: {'Accept': 'application/json'},
      );

      var decodedResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        final List<Event> events =
            (decodedResponse['data'] as List)
                .map((event) => Event.fromMap(event as Map<String, dynamic>))
                .toList();

        return events;
      } else {
        return [];
      }
    } catch (e) {
      responseNotifier.value = {'statusCode': 500, 'message': e.toString()};
      debugPrint('Get Events: ${e.toString()}');
      return [];
    }
  }

  @override
  Future<Event> getSingleEvent(int id) async {
    try {
      var response = await http.get(
        Uri.parse('${apiUrl}events/$id'),
        headers: {'Accept': 'application/json'},
      );
      var decodedResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        final event = Event.fromMap(decodedResponse['data']);
        return event;
      }
      return defaultEvent;
    } catch (e) {
      responseNotifier.value = {'statusCode': 500, 'message': e.toString()};
      debugPrint('Get Single Event: ${e.toString()}');
      return defaultEvent;
    }
  }

  @override
  Future<void> createEvent(Event newEvent) async {
    var event = {
      'title': newEvent.title,
      'description': newEvent.description,
      'start_date': newEvent.startDate,
      'end_date': newEvent.endDate,
      'location': newEvent.location,
    };
    try {
      var response = await http.post(
        Uri.parse('${apiUrl}events'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${apiTokenNotifier.value}',
        },
        body: event,
      );
      var decodedResponse = json.decode(response.body);

      if (response.statusCode == 201) {
        Map<String, dynamic> data = {
          'statusCode': response.statusCode,
          'message': 'Event successfully created',
        };

        responseNotifier.value = data;
      } else {
        Map<String, dynamic> data = {
          'statusCode': response.statusCode,
          'message': decodedResponse['message'],
          'errors': decodedResponse['errors'],
        };
        responseNotifier.value = data;
      }
    } catch (e) {
      responseNotifier.value = {'statusCode': 500, 'message': e.toString()};
      debugPrint('Create Event: ${e.toString()}');
    }
  }

  @override
  Future<void> updateEvent(Event event) async {
    var updateEvent = {
      'title': event.title,
      'description': event.description,
      'start_date': event.startDate,
      'end_date': event.endDate,
      'location': event.location,
    };
    try {
      var response = await http.put(
        Uri.parse('${apiUrl}events/${event.id}'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${apiTokenNotifier.value}',
        },
        body: updateEvent,
      );
      var decodedResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = {
          'statusCode': response.statusCode,
          'message': 'Event successfully created',
        };

        responseNotifier.value = data;
      } else {
        Map<String, dynamic> data = {
          'statusCode': response.statusCode,
          'message': decodedResponse['message'],
          'errors': decodedResponse['errors'],
        };
        responseNotifier.value = data;
      }
    } catch (e) {
      responseNotifier.value = {'statusCode': 500, 'message': e.toString()};
      debugPrint('Update Event: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteEvent(Event event) async {
    try {
      var response = await http.delete(
        Uri.parse('${apiUrl}events/${event.id}'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${apiTokenNotifier.value}',
        },
      );
      var decodedResponse = json.decode(response.body);

      if (response.statusCode == 204) {
        Map<String, dynamic> data = {
          'statusCode': response.statusCode,
          'message': 'Event successfully deleted',
        };

        responseNotifier.value = data;
      } else {
        Map<String, dynamic> data = {
          'statusCode': response.statusCode,
          'message': decodedResponse['message'],
          'errors': decodedResponse['errors'],
        };
        responseNotifier.value = data;
      }
    } catch (e) {
      responseNotifier.value = {'statusCode': 500, 'message': e.toString()};
      debugPrint('Delete Event: ${e.toString()}');
    }
  }

  @override
  Future<List<Event>> searchEvent(String text) async {
    try {
      final List<Event> eventList = await getEvents();
      final List<Event> searchList =
          eventList.where((event) {
            final query = text.toLowerCase();
            return event.title.toLowerCase().contains(query);
          }).toList();
      return searchList;
    } catch (e) {
      responseNotifier.value = {'statusCode': 500, 'message': e.toString()};
      debugPrint('Search Event: ${e.toString()}');
      return [];
    }
  }
}
