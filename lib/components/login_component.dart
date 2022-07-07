import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:gramola_ui/model/check.dart';
import 'package:gramola_ui/model/status.dart';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

import 'package:gramola_ui/model/config.dart';
import 'package:gramola_ui/config/application.dart';

const String parsingErrorMessage = "Error parsing config";
const String networkingErrorMessage = "Networking error";
const String failedLoadingErrorMessage = "Failed loading config";

const String BACKGROUND_PHOTO = 'images/background.jpg';

final logger = Logger('LoginComponent');


class LoginTextField extends TextFormField {
  static const Color TEXT_COLOR = Colors.white;
  static const TextStyle TEXT_STYLE = TextStyle(color: TEXT_COLOR);
  LoginTextField(
      {Key? key, required IconData iconData,
      required String labelText,
      required FormFieldValidator<String> validator,
      required FormFieldSetter<String> onSaved,
      bool obscureText = false})
      : super(key: key, 
            decoration: InputDecoration(
              icon: Icon(iconData),
              labelText: labelText,
            ),
            validator: validator,
            onSaved: onSaved,
            obscureText: obscureText);
}

class LoginComponent extends StatefulWidget {
  final String? gatewayUrl;

  const LoginComponent({Key? key, this.gatewayUrl}) : super(key: key);
  
  @override
  State createState() => _LoginComponentState();
}

class _LoginComponentState extends State<LoginComponent> {
  final Application application = Application();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  late Future<Config> config;
  bool isError = false;

  String? _email;
  String? _password;

  _LoginComponentState();

  @override
  void initState() {
    super.initState();
    logger.fine("widget.gatewayUrl = ${widget.gatewayUrl}");
    application.gatewayUrl = widget.gatewayUrl ?? 'https://gateway.dev';

    //config = fetchConfig();
  }

  Future<Config> fetchConfig() async {
    logger.info("about to call ${application.gatewayUrl}/api/config}");

    late final http.Response response;

    try {
      response = await http.get(Uri.parse('${application.gatewayUrl}/api/config'));
    } on SocketException catch (e) {
      isError = true;
      _showSnackbar("$networkingErrorMessage: ${e.message}");
      return const Config(name: "NULL", status: Status(status: "NETWORK_ERROR", checks: <Check>[]));
    }
    
    logger.info("response ${response.statusCode}");

    // If the server did return a 200 OK response,
    // then parse the JSON.
    if (response.statusCode == 200) {
      try {
        Config config = Config.fromJson(json.decode(response.body));
        return config;
      } catch (err, stacktrace) {
        isError = true;
        logger.fine("$parsingErrorMessage $err\n$stacktrace");
        _showSnackbar(parsingErrorMessage);
        // throw Exception(parsingErrorMessage);  
        return const Config(name: "NULL", status: Status(status: "DOWN", checks: <Check>[]));
      }
    } else {
      isError = true;
      _showSnackbar("$failedLoadingErrorMessage statusCode: ${response.statusCode}");
      // throw Exception(failedLoadingErrorMessage);
      return const Config(name: "NULL", status: Status(status: "DOWN", checks: <Check>[]));
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // form is valid, let's login
      _performLogin();
    }
  }

  void _performLogin() async {
    try {
      // authenticateRequestAction(_email);
      // dynamic result = await FhSdk.auth('flutter', _email, _password);
      // authenticateSuccessAction(result);
      Navigator.pushNamed(_scaffoldKey.currentState!.context,
          '/events?country=FRANCE&city=PARIS');
    } on PlatformException catch (e) {
      // authenticateFailureAction(e.message);
      _showSnackbar('Authentication failed!');
    }
  }

  void _showSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

   Color decodeColor(String status) {
    late final Color decoded;
    switch (status.toLowerCase()) {
      case "operational":
        decoded = const ui.Color.fromARGB(255, 30, 233, 61);
        break;
      case "degraded":
        decoded = const ui.Color.fromARGB(255, 233, 118, 30);
        break;
      default:
        decoded = const ui.Color.fromARGB(255, 255, 0, 0);
    }
    return decoded;
  }

  Widget _buildFutureLoginForm() {
    return FutureBuilder<Config>(
            future: fetchConfig(),
            initialData: const Config(name: "no-name", status: Status(status: "DOWN", checks: <Check>[])),
            builder: (BuildContext ctx, AsyncSnapshot<Config> snapshot) =>
                snapshot.hasData ? 
                    Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const Expanded(child: SizedBox()),
                              LoginTextField(
                                iconData: Icons.person,
                                labelText: 'User Name',
                                validator: (val) => val == null || val.length < 3
                                    ? 'Not a valid User Name'
                                    : null,
                                onSaved: (val) => _email = val,
                              ),
                              LoginTextField(
                                iconData: Icons.vpn_key,
                                labelText: 'Password',
                                validator: (val) =>
                                    val == null || val.length < 3 ? 'Password too short.' : null,
                                onSaved: (val) => _password = val,
                                obscureText: true,
                              ),
                              const SizedBox(height: 32.0),
                              ElevatedButton(
                                onPressed: snapshot.data != null && snapshot.data!.status.status == 'OPERATIONAL' ? _submit : null,
                                child: const Text('Login')),
                              const Expanded(child: SizedBox()),
                              // Text("checks size: ${snapshot.data!.status.checks.length}"),
                              Wrap(
                                children: [
                                  Chip(
                                    avatar: const Icon(
                                      Icons.shield,
                                      color: Colors.white,
                                      size: 18.0,
                                      semanticLabel: 'Gateway',
                                    ),
                                    label: Text(snapshot.data!.name),
                                  ),
                                  Chip(
                                    avatar: Icon(
                                      Icons.cell_tower,
                                      color: decodeColor(snapshot.data!.status.status),
                                      size: 18.0,
                                      semanticLabel: 'Status',
                                    ),
                                    label: Text(snapshot.data!.status.status.toLowerCase()),
                                  )
                                ]
                              ),
                              Wrap(
                                children: 
                                  List.generate(snapshot.data!.status.checks.length, (index) => 
                                    Chip(
                                        avatar: const Icon(
                                          Icons.album,
                                          color: Colors.white,
                                          size: 18.0,
                                          semanticLabel: 'Backend',
                                        ),
                                        label: Text(snapshot.data!.status.checks[index].name),
                                      )
                                  )
                                ,
                              )
                              
                            ],
                          ),
                        ),
                      )
                    : const Center(
                        child: Text('In order to access this application you should use the link provided'),
                      )
                      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(BACKGROUND_PHOTO, fit: BoxFit.cover),
          BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
            child: Container(
                color: Colors.black.withOpacity(0.5),
                child: _buildFutureLoginForm()),
          ),
        ],
      ),
    );
  }
}
