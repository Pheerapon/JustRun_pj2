import 'package:equatable/equatable.dart';
import 'package:flutter_habit_run/common/model/room_model.dart';

abstract class ListenListGroupEvent extends Equatable {
  const ListenListGroupEvent();
}

class GetListGroupEvent extends ListenListGroupEvent {
  const GetListGroupEvent({this.groups});
  final List<RoomModel> groups;
  @override
  List<Object> get props => [groups];
}