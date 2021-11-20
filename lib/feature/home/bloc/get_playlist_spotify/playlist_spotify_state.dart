import 'package:equatable/equatable.dart';
import 'package:flutter_habit_run/common/model/playlist_model.dart';

abstract class PlaylistSpotifyState extends Equatable {
  const PlaylistSpotifyState();
}

class PlaylistSpotifyInitial extends PlaylistSpotifyState {
  @override
  List<Object> get props => [];
}

class PlaylistSpotifyLoading extends PlaylistSpotifyState {
  @override
  List<Object> get props => [];
}

class PlaylistSpotifySuccess extends PlaylistSpotifyState {
  const PlaylistSpotifySuccess({this.playlists});
  final List<PlaylistModel> playlists;
  @override
  List<Object> get props => [playlists];
}

class PlaylistSpotifyFailure extends PlaylistSpotifyState {
  const PlaylistSpotifyFailure({this.error});
  final String error;
  @override
  List<Object> get props => [error];
}
