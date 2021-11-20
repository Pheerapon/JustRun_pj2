import 'package:equatable/equatable.dart';

abstract class CreateGroupState extends Equatable {
  const CreateGroupState();
}

class CreateGroupInitial extends CreateGroupState {
  @override
  List<Object> get props => [];
}

class CreateGroupLoading extends CreateGroupState {
  @override
  List<Object> get props => [];
}

class CreateGroupSuccess extends CreateGroupState {
  @override
  List<Object> get props => [];
}

class CreateGroupFailure extends CreateGroupState {
  const CreateGroupFailure({this.errorNameGroup});
  final String errorNameGroup;

  @override
  List<Object> get props => [errorNameGroup];
}
