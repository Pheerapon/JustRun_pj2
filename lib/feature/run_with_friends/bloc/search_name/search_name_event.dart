import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class SearchUserEvent extends Equatable {
  const SearchUserEvent();
}

class SearchEmailEvent extends SearchUserEvent {
  const SearchEmailEvent({this.input, this.context});
  final String input;
  final BuildContext context;
  @override
  List<Object> get props => [input, context];
}

class ResetInviteEvent extends SearchUserEvent {
  @override
  List<Object> get props => [];
}
