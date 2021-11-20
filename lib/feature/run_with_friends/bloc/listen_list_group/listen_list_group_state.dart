import 'package:equatable/equatable.dart';
import 'package:flutter_habit_run/common/model/room_model.dart';

abstract class ListenListGroupState extends Equatable {
  const ListenListGroupState();
}

class ListenListGroupInitial extends ListenListGroupState {
  @override
  List<Object> get props => [];
}

class ListenListGroupLoading extends ListenListGroupState {
  @override
  List<Object> get props => [];
}

class ListenListGroupSuccess extends ListenListGroupState {
  const ListenListGroupSuccess({this.groups});
  final List<RoomModel> groups;
  @override
  List<Object> get props => [groups];
}

class ListenListGroupFailure extends ListenListGroupState {
  const ListenListGroupFailure({this.error});
  final String error;
  @override
  List<Object> get props => [error];
}
