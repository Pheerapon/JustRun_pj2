import 'package:equatable/equatable.dart';
import 'package:flutter_habit_run/common/model/invite_friend_model.dart';

abstract class SearchUserState extends Equatable {
  const SearchUserState();
}

class SearchUserInitial extends SearchUserState {
  @override
  List<Object> get props => [];
}

class SearchUserLoading extends SearchUserState {
  @override
  List<Object> get props => [];
}

class SearchUserSuccess extends SearchUserState {
  const SearchUserSuccess({this.results, this.listInvite});
  final List<InviteFriend> results;
  final List<InviteFriend> listInvite;
  @override
  List<Object> get props => [results, listInvite];
}

class SearchUserFailure extends SearchUserState {
  const SearchUserFailure({this.error});
  final String error;
  @override
  List<Object> get props => [error];
}
