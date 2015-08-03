import 'package:polymer/polymer.dart';
import 'package:dodecatalk/sound_player.dart';

@CustomTag('dodecatalk-message')
class Message extends PolymerElement {

  get player => SoundPlayer.instance;

  Message.created() : super.created() {
  }

  handleMousedown(Event e, var detail, Node target) {
    final song = target.text.trim().split(' ');
    player.play_sequence(song);
  }
}
