import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'package:gramola_ui/config/route_handlers.dart';

final logger = Logger('Routes');

class Routes {
  static String root = "/";
  static String events = "/events";
  static String config = "/config";
  static String deeplink = "/deeplink";

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      logger.info("ROUTE WAS NOT FOUND !!!");
      return;
    });
    
    router.define(root, handler: rootHandler);
    
    router.define(events, handler: eventsRouteHandler);
    router.define(config, handler: configHandler);
    
    router.define(deeplink, handler: configHandler);
  }
}