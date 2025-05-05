import 'package:event_management_app/data/repository/db_auth_repo.dart';
import 'package:event_management_app/data/repository/db_event_repo.dart';
import 'package:event_management_app/presentation/auth/auth_cubit.dart';
import 'package:event_management_app/presentation/event/event_list_cubit.dart';
import 'package:event_management_app/widget_tree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: BlocProvider(
        create: (context) => AuthCubit(DbAuthRepo()),
        child: BlocProvider(
          create: (context) => EventListCubit(DbEventRepo()),
          child: const WidgetTree(),
        ),
      ),
    );
  }
}
