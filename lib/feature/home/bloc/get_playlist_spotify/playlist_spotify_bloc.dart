import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/common/model/playlist_model.dart';

import 'bloc_playlist_spotify.dart';

class PlaylistSpotifyBloc
    extends Bloc<PlaylistSpotifyEvent, PlaylistSpotifyState> {
  PlaylistSpotifyBloc() : super(PlaylistSpotifyInitial());

  @override
  Stream<PlaylistSpotifyState> mapEventToState(
      PlaylistSpotifyEvent event) async* {
    if (event is GetPlaylistSpotify) {
      final List<PlaylistModel> playlists = [];
      try {
        yield PlaylistSpotifyLoading();
        for (var playlist in event.playlistMap) {
          playlists.add(PlaylistModel.fromJson(playlist));
        }
        yield PlaylistSpotifySuccess(playlists: playlists);
      } catch (e) {
        yield PlaylistSpotifyFailure(error: e.toString());
      }
    }
  }
}
