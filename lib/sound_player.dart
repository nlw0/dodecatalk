import 'package:dodecatalk/buffer_loader.dart';
import 'dart:web_audio';

class SoundPlayer {
  final AudioContext audioCtx = new AudioContext();

  Map<String, AudioBuffer> buffers;

  final noteNames = [
    'F3',
    'G3',
    'A3',
    'B3',
    'C4',
    'D4',
    'E4',
    'F4',
    'G4',
    'A4',
    'B4',
    'C5',
    'D5',
    'E5',
    'F5',
    'G5',
    'A5',
    'B5',
    'C6'
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
