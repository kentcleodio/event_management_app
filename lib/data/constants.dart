import 'package:event_management_app/domain/model/user.dart';
import 'package:flutter/material.dart';
import '../presentation/home/home_page.dart';
import '../presentation/profile/profile_page.dart';

final List<Widget> pages = [const HomePage(), const ProfilePage()];

const String imgUrl =
    'https://static.vecteezy.com/system/resources/thumbnails/040/890/255/small_2x/ai-generated-empty-wooden-table-on-the-natural-background-for-product-display-free-photo.jpg';

const String apiUrl = 'http://10.0.2.2:8000/api/';
final User defaultUser = User(id: 0, name: '', email: '', apiToken: '');

const Color white = Colors.white;
const Color primaryColor = Colors.teal;
const Color accentColor = Colors.tealAccent;
const Color primaryTextColor = Colors.black;
final Color secondaryTextColor = Colors.grey[600]!;
final Color dangerColor = Colors.red[800]!;
