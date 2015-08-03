import 'dart:html';
import 'dart:web_audio';

import 'package:polymer/polymer.dart';
import 'package:dodecatalk/buffer_loader.dart';

@CustomTag('main-app')
class MainApp extends PolymerElement {
  MainApp.created() : super.created() {
    print('oi');
  }
}