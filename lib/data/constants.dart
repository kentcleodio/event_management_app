import 'package:event_management_app/domain/model/event.dart';
import 'package:event_management_app/domain/model/user.dart';
import 'package:flutter/material.dart';

const String imgUrl =
    'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541';

const String apiUrl = 'http://10.0.2.2:8000/api/';
final User defaultUser = User(id: 0, name: '', email: '');
final Event defaultEvent = Event(
  title: '',
  description: '',
  startDate: '',
  endDate: '',
  location: '',
);

const Color white = Colors.white;
const Color primaryColor = Colors.teal;
const Color accentColor = Colors.tealAccent;
const Color primaryTextColor = Colors.black;
final Color secondaryTextColor = Colors.grey[600]!;
final Color dangerColor = Colors.red[800]!;
