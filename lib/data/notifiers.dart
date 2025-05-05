import 'package:flutter/widgets.dart';

ValueNotifier<int> selectedPageNotifier = ValueNotifier(0);

ValueNotifier<bool> showPasswordNotifier = ValueNotifier(false);

ValueNotifier<bool> loadingNotifier = ValueNotifier(false);

ValueNotifier<Map<String, dynamic>> responseNotifier = ValueNotifier({});

ValueNotifier<String?> apiTokenNotifier = ValueNotifier(null);
