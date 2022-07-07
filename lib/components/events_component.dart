import 'dart:convert';
import 'package:gramola_ui/config/application.dart';
import 'package:logging/logging.dart';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:gramola_ui/components/events_row_component.dart';
import 'package:gramola_ui/model/event.dart';

const String parsingErrorMessage = "Error parsing events";
const String failedLoadingErrorMessage = "Failed loading events";

final logger = Logger('EventsComponent');

class EventsComponent extends StatefulWidget {

  final String country;
  final String city;

  const EventsComponent({Key? key, required this.country, required this.city}) : super(key: key);

  @override
  State createState() => _EventsComponentState();
}

class _EventsComponentState extends State<EventsComponent> {
  final Application application = Application();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late Future<List<Event>> events;
  bool isError = false;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    
    events = fetchEvents();
    _getImagesUrl();
  }

  Future<List<Event>> fetchEvents() async {
    logger.info("about to call ${application.gatewayUrl}/api/events/${widget.country}/${widget.city}");

    final response = await http.get(Uri.parse('${application.gatewayUrl}/api/events/${widget.country}/${widget.city}'));

    logger.info("response ${response.statusCode}");

    // If the server did return a 200 OK response,
    // then parse the JSON.
    if (response.statusCode == 200) {
      try {
        Iterable l = json.decode(response.body);
        return List<Event>.from(l.map((model)=> Event.fromJson(model)));
      } catch (err, stacktrace) {
        isError = true;
        logger.fine("$parsingErrorMessage $err\n$stacktrace");
        _showSnackbar("$parsingErrorMessage");
        // throw Exception(parsingErrorMessage);  
        return <Event>[];
      }
    } else {
      isError = true;
      _showSnackbar("$failedLoadingErrorMessage statusCode: ${response.statusCode}");
      // throw Exception(failedLoadingErrorMessage);
      return <Event>[];
    }
  }

  void _getImagesUrl() async {
    try {
      // fetchCloudUrlRequestAction('');
      // String result = await FhSdk.getCloudUrl();
      // fetchCloudUrlSuccessAction(result);
    } on PlatformException catch (e) {
      // fetchCloudUrlFailureAction(e.message);
      _showSnackbar('getCloudUrl failed!');
    }
  }

  void _showSnackbar (String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('List of events'),
        leading: IconButton(
            tooltip: 'Previous choice',
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(_scaffoldKey.currentContext!);
          },
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: buildFutureListView2(),
          )
        ]
      )
    );
  }

  Widget buildFutureListView() {
    return FutureBuilder(
            future: fetchEvents(),
            builder: (BuildContext ctx, AsyncSnapshot<List> snapshot) =>
                snapshot.hasData
                    ? ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (_, index) => EventRow(ObjectKey(snapshot.data![index]), '', snapshot.data![index], 'loginStore.username'),
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ));
  }

  Widget buildFutureListView2() {
    return FutureBuilder(
            future: events,
            builder: (BuildContext ctx, AsyncSnapshot<List> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Center(
                  child: snapshot.data == null
                      ? const CircularProgressIndicator()
                      : ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (_, index) => EventRow(ObjectKey(snapshot.data![index]), application.gatewayUrl, snapshot.data![index], 'loginStore.username'),
                      ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } 
            });
  }
}