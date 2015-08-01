// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'dart:web_audio';

import 'package:polymer/polymer.dart';
import 'dart:collection';

typedef void OnLoadCallback(List<AudioBuffer> bufferList);

class BufferLoader {
  AudioContext audioCtx;
  List<String> urlList;
  OnLoadCallback callback;
  int _loadCount = 0;
  List<AudioBuffer> _bufferList;

  BufferLoader(this.audioCtx, this.urlList, this.callback) {
    _bufferList = new List<AudioBuffer>(urlList.length);
  }

  void load() {
    for (var i = 0; i < urlList.length; i++) {
      _loadBuffer(urlList[i], i);
    }
  }

  void _loadBuffer(String url, int index) {
    // Load the buffer asynchronously.
    var request = new HttpRequest();
    request.open("GET", url, async: true);
    request.responseType = "arraybuffer";
    request.onLoad.listen((e) => _onLoad(request, url, index));

    // Don't use alert in real life ;)
    request.onError.listen((e) => window.alert("BufferLoader: XHR error"));

    request.send();
  }

  void _onLoad(HttpRequest request, String url, int index) {
    // Asynchronously decode the audio file data in request.response.
    audioCtx.decodeAudioData(request.response).then((AudioBuffer buffer) {
      if (buffer == null) {

        // Don't use alert in real life ;)
        window.alert("Error decoding file data: $url");

        return;
      }
      _bufferList[index] = buffer;
      if (++_loadCount == urlList.length) callback(_bufferList);
    });
  }
}


/// A Polymer `<main-app>` element.
@CustomTag('main-app')
class MainApp extends PolymerElement {
  @observable String reversed = 'aaa';

  Map<String, AudioBuffer> buffers;
  AudioContext audioCtx;

  static const buffersToLoad = const {
    "C4": "sounds/mandolin_C4_very-long_piano_normal.mp3",
    "D4": "sounds/mandolin_D4_very-long_piano_normal.mp3",
    "E4": "sounds/mandolin_E4_very-long_piano_normal.mp3",
    "F4": "sounds/mandolin_F4_very-long_piano_normal.mp3",
    "G4": "sounds/mandolin_G4_very-long_piano_normal.mp3",
    "A4": "sounds/mandolin_A4_very-long_piano_normal.mp3",
    "B4": "sounds/mandolin_B4_very-long_piano_normal.mp3",
    "C5": "sounds/mandolin_C5_very-long_piano_normal.mp3"
  };

  static const keyboardTranslation = const {
    KeyCode.A : "C4",
    KeyCode.S : "D4",
    KeyCode.D : "E4",
    KeyCode.F : "F4",
    KeyCode.G : "G4",
    KeyCode.H : "A4",
    KeyCode.J : "B4",
    KeyCode.K : "C5"
  };


  MainApp.created() : super.created() {
    buffers = new Map<String, AudioBuffer>();
    audioCtx = new AudioContext();
    _loadBuffers();

    window.onKeyDown.listen((KeyboardEvent e) {
      if (keyboardTranslation.containsKey(e.keyCode))
        _play(keyboardTranslation[e.keyCode]);
    });
  }

  void _loadBuffers() {
    List<String> names = buffersToLoad.keys.toList();
    List<String> paths = buffersToLoad.values.toList();
    var bufferLoader = new BufferLoader(audioCtx, paths, (List<AudioBuffer> bufferList) {
      for (var i = 0; i < bufferList.length; i++) {
        AudioBuffer buffer = bufferList[i];
        String name = names[i];
        buffers[name] = buffer;
      }
    });
    bufferLoader.load();
  }

  playFromClick(Event e, var detail, Node target) {
    _play(target.attributes['data-note']);
  }

  _play(note) {
    var _source = audioCtx.createBufferSource();
    _source.buffer = buffers[note];
    _source.connectNode(audioCtx.destination, 0, 0);
    _source.start(0);
  }

  wakka() {
    Console.log("wakkwakkawakka");
  }
}
