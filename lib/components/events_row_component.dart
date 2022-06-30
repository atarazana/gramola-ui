import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:gramola_ui/config/theme.dart';

import 'package:gramola_ui/model/event.dart';

class EventRow extends StatelessWidget {
  final String _imagesBaseUrl;
  final Event _event;
  final String _userId;

  const EventRow(Key? key, this._imagesBaseUrl, this._event, this._userId) : super(key: key);

  Widget _buildCardContent(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Expanded(child: SizedBox()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Text(_event.name, style: TextStyles.eventTitle)]
          ),
          const Expanded(child: SizedBox()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Text(_event.artist, style: TextStyles.eventArtist)]
          ),
          const Expanded(child: SizedBox()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: <Widget>[
              const Expanded(child: SizedBox()),
              Column(children: <Widget>[Text("${_event.startDate} ${_event.startTime}", style: TextStyles.eventDate)]),
              const Expanded(child: SizedBox()),
              Column(children: <Widget>[Text(_event.location, style: TextStyles.eventLocation)]),
              const Expanded(child: SizedBox())
            ]
          ),
          const Expanded(child: SizedBox())
        ]
      );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToTimeline(context, _event.id, _userId), 
      child: Card(
        child: SizedBox(
          height: 180.0,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image.network('$_imagesBaseUrl/api/files/${_event.image}', fit: BoxFit.cover),
              // BackdropFilter(
              //   filter: ui.ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
              //   child: Container(
              //     color: GramolaColors.eventCard.withOpacity(0.5),
              //   ),
              // ),
              _buildCardContent(context),
            ]
          )
        )
      )
    );
  }

  _navigateToTimeline(context, int eventId, String userId) {
    print ("About to navigate to /timeline?eventId=$eventId&userId=$userId");
    Navigator.pushNamed(context, '/timeline?eventId=$eventId&userId=$userId');
  }
}