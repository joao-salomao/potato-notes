import 'package:shared_preferences/shared_preferences.dart';

import 'views/app.dart';
import 'package:get_it/get_it.dart';
import 'views/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:potato_notes/views/state/app_audio_player_state.dart';

void setup() async {
  GetIt.I.registerSingleton<AppState>(AppState());
  GetIt.I.registerSingleton<AppAudioPlayerState>(AppAudioPlayerState());
  GetIt.I.registerSingletonAsync<SharedPreferences>(() => SharedPreferences.getInstance());
}

void main() {
  setup();
  runApp(App());
}
