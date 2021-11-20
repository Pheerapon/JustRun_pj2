import 'package:bloc/bloc.dart';

import 'bloc_listen_list_group.dart';

class ListenListGroupBloc
    extends Bloc<ListenListGroupEvent, ListenListGroupState> {
  ListenListGroupBloc() : super(ListenListGroupInitial());

  @override
  Stream<ListenListGroupState> mapEventToState(
      ListenListGroupEvent event) async* {
    if (event is GetListGroupEvent) {
      try {
        yield ListenListGroupLoading();
        yield ListenListGroupSuccess(groups: event.groups);
      } catch (e) {
        yield ListenListGroupFailure(error: e.toString());
      }
    }
  }
}
