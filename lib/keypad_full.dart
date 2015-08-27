import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:dodecatalk/sound_player.dart';
import 'package:dodecatalk/message.dart';

@CustomTag('dodecatalk-keypad-full')
class KeypadFull extends PolymerElement {

  final keyNotes = [
    ['Gs2', 'As2', ' ', 'Cs3', 'Ds3', ' ', 'Fs3', 'Gs3', 'As3'],
    ['G2', 'A2', 'B2', 'C3', 'D3', 'E3', 'F3', 'G3', 'A3', 'B3'],
    ['Cs4', 'Ds4', ' ', 'Fs4', 'Gs4', 'As4', ' ', 'Cs5'],
    ['C4', 'D4', 'E4', 'F4', 'G4', 'A4', 'B4', 'C5', 'D5']
  ];

  static const keyboardCommandTranslation = const {
    KeyCode.BACKSPACE: 'del',
    KeyCode.ENTER: 'play'
  };

  static const keyboardNoteTranslation = const {
    KeyCode.TWO: 'Gs2',
    KeyCode.THREE: 'As2',
    KeyCode.FIVE: 'Cs3',
    KeyCode.SIX: 'Ds3',
    KeyCode.EIGHT: 'Fs3',
    KeyCode.NINE: 'Gs3',
    KeyCode.ZERO: 'As3',

    KeyCode.Q: 'G2',
    KeyCode.W: 'A2',
    KeyCode.E: 'B2',
    KeyCode.R: 'C3',
    KeyCode.T: 'D3',
    KeyCode.Y: 'E3',
    KeyCode.U: 'F3',
    KeyCode.I: 'G3',
    KeyCode.O: 'A3',
    KeyCode.P: 'B3',

    KeyCode.S: 'Cs4',
    KeyCode.D: 'Ds4',
    KeyCode.G: 'Fs4',
    KeyCode.H: 'Gs4',
    KeyCode.J: 'As4',
    KeyCode.L: 'Cs5',

    KeyCode.Z: 'C4',
    KeyCode.X: 'D4',
    KeyCode.C: 'E4',
    KeyCode.V: 'F4',
    KeyCode.B: 'G4',
    KeyCode.N: 'A4',
    KeyCode.M: 'B4',
    KeyCode.COMMA: 'C5',
    KeyCode.PERIOD: 'D5',

    KeyCode.SPACE: 'p'
  };

  final keyLabel = const {
    'Gs2': '2',
    'As2': '3',
    'Cs3': '5',
    'Ds3': '6',
    'Fs3': '8',
    'Gs3': '9',
    'As3': '0',

    'G2': 'Q',
    'A2': 'W',
    'B2': 'E',
    'C3': 'R',
    'D3': 'T',
    'E3': 'Y',
    'F3': 'U',
    'G3': 'I',
    'A3': 'O',
    'B3': 'P',

    'Cs4': 'S',
    'Ds4': 'D',
    'Fs4': 'G',
    'Gs4': 'H',
    'As4': 'J',
    'Cs5': 'L',

    'C4': 'Z',
    'D4': 'X',
    'E4': 'C',
    'F4': 'V',
    'G4': 'B',
    'A4': 'N',
    'B4': 'M',
    'C5': ',',
    'D5': '.'
  };

  get player => SoundPlayer.instance;

  @observable String tape = "";

  @observable List<String> parsedTape = [];

  KeypadFull.created() : super.created() {
    window.onKeyDown.listen(handleKeyDown);
    window.onKeyUp.listen(handleKeyUp);
  }

  handleKeyDown(KeyboardEvent e) {
    if (keyboardNoteTranslation.containsKey(e.keyCode)) {
      final note = keyboardNoteTranslation[e.keyCode];
      play(note);
      final key = shadowRoot.querySelector("#key-$note");
      key.classes.add("pressed_key");
    } else if (keyboardCommandTranslation.containsKey(e.keyCode)) {
      final cmd = keyboardCommandTranslation[e.keyCode];
      if (cmd=="del") {
        parsedTape.removeLast();
        tape = parsedTape.join("");
      } else if (cmd=="play") {
        playTape();
      }
    }
  }

  playTape() {
    shadowRoot.querySelector('dodecatalk-message').xtag.playContent();
  }

  handleKeyUp(KeyboardEvent e) {
    if (keyboardNoteTranslation.containsKey(e.keyCode)) {
      final note = keyboardNoteTranslation[e.keyCode];
      final key = shadowRoot.querySelector("#key-$note");
      key.classes.remove("pressed_key");
    }
  }

  handleMousedown(Event e, var detail, Node target) {
    play(target.attributes['data-note']);
    target.classes.add("pressed_key");
  }

  handleMouseup(Event e, var detail, Node target) {
    target.classes.remove("pressed_key");
  }

  play(String note) {
    parsedTape.add(" $note");
    tape = parsedTape.join("");
    player.play(note);
  }

  clearTape(Event e, var detail, Node target) {
    parsedTape = [];
    tape = parsedTape.join("");
  }
}
