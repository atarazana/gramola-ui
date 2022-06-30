import 'dart:developer' as developer;

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:gramola_ui/config/application.dart';
import 'package:gramola_ui/config/routes.dart';
import 'package:gramola_ui/config/theme.dart';

class AppComponent extends StatefulWidget {
  const AppComponent({Key? key}) : super(key: key);
  @override
  State createState() {
    return AppComponentState();
  }
}

class AppComponentState extends State<AppComponent> {
  final Application application = Application();

  AppComponentState() {
    developer.log("AppComponent.createState() $this.hashCode");
    final router = FluroRouter();
    Routes.configureRoutes(router);
    application.router = router;
  }

  @override
  Widget build(BuildContext context) {
    final app = MaterialApp(
      title: 'Gramola',
      debugShowCheckedModeBanner: false,
      theme: gramolaBaseTheme,
      onGenerateRoute: application.router.generator,
    );
//    print("initial route = ${app.initialRoute}");
    return app;
  }
}