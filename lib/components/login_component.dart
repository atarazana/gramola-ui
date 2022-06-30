import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'package:gramola_ui/config/application.dart';

const String BACKGROUND_PHOTO = 'images/background.jpg';

final logger = Logger('LoginComponent');


class LoginTextField extends TextFormField {
  static const Color TEXT_COLOR = Colors.white;
  static const TextStyle TEXT_STYLE = TextStyle(color: TEXT_COLOR);
  LoginTextField(
      {required IconData iconData,
      required String labelText,
      required FormFieldValidator<String> validator,
      required FormFieldSetter<String> onSaved,
      bool obscureText = false})
      : super(
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

  String? _email;
  String? _password;

  _LoginComponentState();

  @override
  void initState() {
    super.initState();
    logger.fine("widget.gatewayUrl = ${widget.gatewayUrl}");
    application.gatewayUrl = widget.gatewayUrl ?? 'https://gateway.dev';
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

  Widget _buildLoginForm(BuildContext context) {
    return Padding(
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
            RaisedButton(child: const Text('Login'), onPressed: _submit),
            const Expanded(child: SizedBox()),
          ],
        ),
      ),
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
                child: _buildLoginForm(context)),
          ),
        ],
      ),
    );
  }
}
