import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExtensionController extends GetxController {
  final Rxn<html.File> image = Rxn<html.File>();
  final RxBool preventClose = false.obs;
  final RxBool keepOpen = false.obs;
  final RxBool s = false.obs;
  final RxBool s1 = false.obs;
  final customSizeController = TextEditingController();

  void preventPopupClose(bool shouldPrevent) {
    preventClose.value = shouldPrevent;
  }

  Future<void> selectImage() async {
    final html.FileUploadInputElement input = html.FileUploadInputElement()
      ..accept = 'image/*';
    input.click();

    await input.onChange.first;
    if (input.files!.isNotEmpty) {
      image.value = input.files!.first;
      keepOpen.value = false;
    }
  }

  void switchDevice(String device) {
    if (device == 'Android') {
      s.value = !s.value;
    } else if (device == 'Chrome') {
      s1.value = !s1.value;
    }
  }

  Future<void> downloadImage(html.File image, String filename) async {
    final html.Blob blob = image;
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..target = 'webdownload'
      ..download = filename
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  Future<void> downloadImages() async {
    if (s.value) {
      downloadImage(image.value!, 'android_image.png');
    }

    if (s1.value) {
      downloadImage(image.value!, 'chrome_image.png');
    }
  }

  Future<void> downloadFile(html.File file, String filename) async {
    final reader = html.FileReader();
    reader.readAsArrayBuffer(file);
    await reader.onLoad.first;

    final blob = html.Blob([reader.result]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..target = 'webdownload'
      ..download = filename
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  Future<Uint8List> readFileAsUint8List(html.Blob blob) async {
    final completer = Completer<Uint8List>();
    final reader = html.FileReader();
    reader.onLoad.listen((event) {
      final uint8List = Uint8List.fromList(reader.result as List<int>);
      completer.complete(uint8List);
    });
    reader.readAsArrayBuffer(blob);
    return completer.future;
  }
}
