import 'package:dodecatalk/buffer_loader.dart';
import 'dart:web_audio';

class SoundPlayer {
  final AudioContext audioCtx = new AudioContext();

  Map<String, AudioBuffer> buffers;

  final noteNames = [
    'A0', 'A1', 'A2', 'A3', 'A4', 'A5', 'As0', 'As1', 'As2', 'As3', 'As4', 'As5', 'B0', 'B1', 'B2', 'B3', 'B4', 'B5',
    'C1', 'C2', 'C3', 'C4', 'C5', 'C6', 'Cs1', 'Cs2', 'Cs3', 'Cs4', 'Cs5', 'Cs6', 'D1', 'D2', 'D3', 'D4', 'D5', 'D6',
    'Ds1', 'Ds2', 'Ds3', 'Ds4', 'Ds5', 'Ds6', 'E1', 'E2', 'E3', 'E4', 'E5', 'E6', 'F1', 'F2', 'F3', 'F4', 'F5', 'Fs1',
    'Fs2', 'Fs3', 'Fs4', 'Fs5', 'G1', 'G2', 'G3', 'G4', 'G5', 'Gs1', 'Gs2', 'Gs3', 'Gs4', 'Gs5'
  ];

  SoundPlayer._internal() {
    _loadBuffers();
  }

  static SoundPlayer get instance => _singleton;

  static final SoundPlayer _singleton = new SoundPlayer._internal();

  void _loadBuffers() {
    final paths = noteNames.map(_noteFilename).toList();
    final bufferLoader = new BufferLoader(audioCtx, paths, _buildBuffersMap);
    bufferLoader.load();
  }

  String _noteFilename(String note) {
    return 'sounds/piano-${note}.mp3';
  }

  _buildBuffersMap(List<AudioBuffer> bufferList) {
    buffers = new Map<String, AudioBuffer>.fromIterables(noteNames, bufferList);
  }

  play(String note, [num when = 0, num offset = 0]) {
    print("PLAYING [$note]");
    if (!buffers.containsKey(note)) {
      print("UNKNOWN NOTE");
      return;
    }
    final source = audioCtx.createBufferSource();
    source.buffer = buffers[note];
    source.connectNode(audioCtx.destination, 0, 0);
    source.start(when + offset);
  }

  play_sequence(List<String> song, [num when = 0, num offset = 0]) {
    print('PLAYING SONG: $song');

    var start = audioCtx.currentTime;
    num speed = 0.2;
    var when = 0;
    song.forEach((note) {
      if (isValid(note) && buffers.containsKey(note)) {
        play(note, when * speed, 1 + start);
      }
      if (isValid(note)) {
        when += 1;
      }
    });
  }

  isValid(String note) {
    return note != null && note != "";
  }
}
