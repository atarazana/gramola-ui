import 'package:logging/logging.dart';

import 'package:flutter/material.dart';
import 'package:gramola_ui/components/app_component.dart';

void main() {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  runApp(const AppComponent());
}
