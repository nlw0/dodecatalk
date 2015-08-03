import 'dart:html';
import 'dart:web_audio';

import 'package:polymer/polymer.dart';
import 'package:dodecatalk/buffer_loader.dart';

@CustomTag('dodecatalk-keypad')
class Keypad extends PolymerElement {
  final noteNames = [
    'C4',
    'D4',
    'E4',
    'F4',
    'G4',
    'A4',
    'B4',
    'C5'
  ];

  static const keyboardTranslation = const {
    KeyCode.A: 'C4',
    KeyCode.S: 'D4',
    KeyCode.D: 'E4',
    KeyCode.F: 'F4',
    KeyCode.G: 'G4',
    KeyCode.H: 'A4',
    KeyCode.J: 'B4',
    KeyCode.K: 'C5'
  };

  final keyLabel = const {
    'C4': 'A',
    'D4': 'S',
    'E4': 'D',
    'F4': 'F',
    'G4': 'G',
    'A4': 'H',
    'B4': 'J',
    'C5': 'K'
  };


  final AudioContext audioCtx = new AudioContext();

  Map<String, AudioBuffer> buffers;

  Keypad.created() : super.created() {
    _loadBuffers();

    window.onKeyDown.listen(handleKeyDown);
    window.onKeyUp.listen(handleKeyUp);
  }

  handleKeyDown(KeyboardEvent e) {
    if (keyboardTranslation.containsKey(e.keyCode)) {
      final note = keyboardTranslation[e.keyCode];
      play(note);
      final key = shadowRoot.querySelector("#key-$note");
      key.classes.add("pressed_key");
    }
  }

  handleKeyUp(KeyboardEvent e) {
    if (keyboardTranslation.containsKey(e.keyCode)) {
      final note = keyboardTranslation[e.keyCode];
      final key = shadowRoot.querySelector("#key-$note");
      key.classes.remove("pressed_key");
    }
  }

  void _loadBuffers() {
    final paths = noteNames.map(_noteFilename).toList();
    final bufferLoader = new BufferLoader(audioCtx, paths, _buildBuffersMap);
    bufferLoader.load();
  }

  String _noteFilename(String note) {
    return 'sounds/piano-${note}.mp3';
    //return 'sounds/guitar_${note}_very-long_forte_normal.mp3';
    //return 'sounds/mandolin_${note}_very-long_piano_normal.mp3';
  }

  _buildBuffersMap(List<AudioBuffer> bufferList) {
    buffers = new Map<String, AudioBuffer>.fromIterables(noteNames, bufferList);
  }

  handleMousedown(Event e, var detail, Node target) {
    play(target.attributes['data-note']);
    target.classes.add("pressed_key");
  }

  handleMouseup(Event e, var detail, Node target) {
    target.classes.remove("pressed_key");
  }

  play(note) {
    final source = audioCtx.createBufferSource();
    source.buffer = buffers[note];
    source.connectNode(audioCtx.destination, 0, 0);
    source.start(0);
  }
}
