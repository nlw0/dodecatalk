import 'package:polymer/polymer.dart';

@CustomTag('dodecatalk-message')
class Message extends PolymerElement {
  Message.created() : super.created() {
  }

  playSong() {
    print('sing a happy song');
  }
}