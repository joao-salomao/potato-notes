import 'package:mobx/mobx.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:jubjub/utils/formatters.dart';
part 'app_audio_player_controller.g.dart';

class AppAudioPlayerController = _AppAudioPlayerControllerBase with _$AppAudioPlayerController;

abstract class _AppAudioPlayerControllerBase with Store {
  var audioPlayer = AudioPlayer();

  _AppAudioPlayerControllerBase() {
    audioPlayer.onDurationChanged.listen((value) {
      _setTotaldDuration(value);
    });

    audioPlayer.onAudioPositionChanged.listen((value) {
      _setCurrentDuration(value);
    });

    audioPlayer.onPlayerCompletion.listen((_) {
      _setIsPlaying(false);
    });
  }

  @observable
  var isPlaying = false;

  @observable
  String filePath;

  @observable
  Duration totaldDuration = Duration(seconds: 0);

  @observable
  Duration currentDuration = Duration(seconds: 0);

  @computed
  String get formatedTotaldDuration => formatDuration(totaldDuration);

  @computed
  String get formatedCurrentDuration => formatDuration(currentDuration);

  @computed
  bool get showPlayer => filePath == null ? false : true;

  @action
  _setIsPlaying(bool value) => isPlaying = value;

  @action
  _setFilePath(String value) => filePath = value;

  @action
  _setTotaldDuration(Duration value) => totaldDuration = value;

  @action
  _setCurrentDuration(Duration value) => currentDuration = value;

  @action
  playAudio(String path) {
    _setFilePath(path);
    play();
  }

  @action
  play() {
    if (filePath != null) {
      audioPlayer.play(filePath).then((_) {
        _setIsPlaying(true);
      });
    }
  }

  @action
  pause() {
    audioPlayer.pause().then((_) => _setIsPlaying(false));
  }

  @action
  stop() {
    audioPlayer.stop().then((_) {
      _setFilePath(null);
      _setTotaldDuration(Duration(seconds: 0));
      _setCurrentDuration(Duration(seconds: 0));
      _setIsPlaying(false);
    });
  }

  @action
  setAudioDuration(double value) async {
    final duration = Duration(seconds: value.toInt());
    audioPlayer.seek(duration).then((_) => play());
  }
}
