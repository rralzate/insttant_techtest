import 'package:flutter/material.dart';

import 'core/injection/injection_container.dart';
import 'maincommon.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());

  await injectDependencies();

  //final secureStorage = getIt<LocalStorageRepository>();
}
