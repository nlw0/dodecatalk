import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:dodecatalk/sound_player.dart';

@CustomTag('dodecatalk-keypad')
class Keypad extends PolymerElement {

  final keyNotes = [
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

  get player => SoundPlayer.instance;

  Keypad.created() : super.created() {
    window.onKeyDown.listen(handleKeyDown);
    window.onKeyUp.listen(handleKeyUp);
  }

  handleKeyDown(KeyboardEvent e) {
    if (keyboardTranslation.containsKey(e.keyCode)) {
      final note = keyboardTranslation[e.keyCode];
      player.play(note);
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

  handleMousedown(Event e, var detail, Node target) {
    player.play(target.attributes['data-note']);
    target.classes.add("pressed_key");
  }

  handleMouseup(Event e, var detail, Node target) {
    target.classes.remove("pressed_key");
  }
}
