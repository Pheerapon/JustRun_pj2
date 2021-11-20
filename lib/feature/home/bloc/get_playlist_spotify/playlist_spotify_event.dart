import 'package:equatable/equatable.dart';

abstract class PlaylistSpotifyEvent extends Equatable {
  const PlaylistSpotifyEvent();
}

class GetPlaylistSpotify extends PlaylistSpotifyEvent {
  const GetPlaylistSpotify({this.playlistMap});
  final List<dynamic> playlistMap;
  @override
  List<Object> get props => [playlistMap];
}
