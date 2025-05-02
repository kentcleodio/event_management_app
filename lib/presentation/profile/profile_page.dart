import 'package:event_management_app/presentation/profile/profile_cubit.dart';
import 'package:event_management_app/presentation/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(0),
      child: const ProfileView(),
    );
  }
}
