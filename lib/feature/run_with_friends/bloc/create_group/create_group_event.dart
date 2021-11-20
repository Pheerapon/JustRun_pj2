import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class CreateGroupEvent extends Equatable {
  const CreateGroupEvent();
}

class CreatePressed extends CreateGroupEvent {
  const CreatePressed({this.nameGroup, this.context}) : super();
  final String nameGroup;
  final BuildContext context;

  @override
  List<Object> get props => [nameGroup, context];

  @override
  String toString() => 'CreateGroupPressed { nameGroup: $nameGroup }';
}
