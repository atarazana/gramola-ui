import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'package:gramola_ui/components/events_component.dart';
import 'package:gramola_ui/components/login_component.dart';

final logger = Logger('RoutesHandlers');

var rootHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  logger.fine("rootHandler");
  return LoginComponent();
});

var configHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  String? url = params["url"]?.first;
  logger.fine("configHandler url: $url");
  return LoginComponent(gatewayUrl: url);
});

var eventsRouteHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  logger.fine("eventsRouteHandler");
  String? country = params["country"]?.first;
  String? city = params["city"]?.first;
  return EventsComponent(country: country ?? 'SPAIN', city: city ?? 'MADRID');
});

