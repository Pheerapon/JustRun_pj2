import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();
}

class SetAlarmPressed extends NotificationsEvent {
  const SetAlarmPressed({this.minutes, this.hour, this.context}) : super();
  final String hour;
  final String minutes;
  final BuildContext context;

  @override
  List<Object> get props => [hour, minutes, context];

  @override
  String toString() =>
      'SetNotificationPressed { hour: $hour, minutes: $minutes }';
}
