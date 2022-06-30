import 'package:fluro/fluro.dart';

class Application {
  static final Application _instance = Application._internal();

  // passes the instantiation to the _instance object
  factory Application() => _instance;

  // initialize variables in here
  Application._internal() {
    _counter = 0;
  }

  late final FluroRouter router;
  late String gatewayUrl;

  late int _counter;

  // short getter for my variable
  int get counter => _counter;

  // short setter for my variable
  set counter(int value) => counter = value;

  void incrementCounter() => _counter++;
}

