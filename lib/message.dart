import 'package:polymer/polymer.dart';
import 'package:dodecatalk/sound_player.dart';
import 'dart:html';

@CustomTag('dodecatalk-message')
class Message extends PolymerElement {

  get player => SoundPlayer.instance;

  Message.created() : super.created() {
  }

  handleMousedown(Event e, var detail, Node target) {
    playContent();
  }

  playContent() {
    var nodes = (shadowRoot.querySelector('content') as ContentElement).getDistributedNodes();
    var song = nodes[0].text.split(' ');
    player.play_sequence(song);
  }
}
