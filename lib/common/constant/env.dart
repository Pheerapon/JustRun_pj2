import 'dart:io';

import 'package:flutter/material.dart';

import 'colors.dart';

mixin EnvValue {
  static const String version = ' ';
  static const String policy = 'https://runner-habit.timistudio.dev/policy';
  static const String terms = 'https://runner-habit.timistudio.dev/terms';
  static const String uploadImage = 'https://api.storage.timistudio.dev/upload';
  // static const String adUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String databaseUrl =
      'https://just-run-pj2-default-rtdb.firebaseio.com';
  static const String hasuraClaim = 'https://hasura.io/jwt/claims';
  static const String policyLocation =
      'This app collects location data to enable "Run feature", even when the app is not in used (background mode). This app will not collects data when the app is closed.';
  // static const String linkGooglePlay =
  //     'https://play.google.com/store/apps/details?id=dev.timistudio.habitrun';

  // spotify
  static const String clientId = 'b452fdf42c3f4e3cbadce8f2b709c564';
  static const String redirectUrl = 'https://dev.timistudio.habitrun/callback/';
  static const String scope = 'app-remote-control, '
      'user-modify-playback-state, '
      'playlist-read-private, '
      'playlist-modify-public,user-read-currently-playing';
  static const String getPlaylists = 'https://api.spotify.com/v1/me/playlists';

  static const String requestAR =
      'You need go to Settings and enable activity recognition permission to use app';
  static const String requestLocation =
      'You need go to Settings and enable location permission to use app';
  static const String requestCamera =
      'You need go to Settings and enable Camera permission to use app';
}

class AdHelper {
  String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    }
    throw UnsupportedError('Unsupported platform');
  }

  String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/2247696110';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/3986624511';
    }
    throw UnsupportedError('Unsupported platform');
  }

  String get rewardAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/1712485313';
    }
    throw UnsupportedError('Unsupported platform');
  }

  List<Color> colorAvt = [
    magnolia,
    redSalsa,
    sandyBrown,
    azure,
    maizeCrayola,
    primary,
    colorGenderSelected
  ];
  final List<Map<String, dynamic>> money = [
    <String, dynamic>{'label': 'x10,000', 'money': '\$0.99'},
    <String, dynamic>{'label': 'x25,000', 'money': '\$1.99'},
    <String, dynamic>{'label': 'x50,000', 'money': '\$3.99'},
    <String, dynamic>{'label': 'x70,000', 'money': '\$4.99'},
    <String, dynamic>{'label': 'x100,000', 'money': '\$5.99'},
    <String, dynamic>{'label': 'x200,000', 'money': '\$9.99'}
  ];
}
