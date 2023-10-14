import 'dart:io';

import 'package:extention/Chrome_Extention/extention_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Extension extends StatelessWidget {
  Extension({Key? key}) : super(key: key);

  final ExtensionController controller = Get.put(ExtensionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  width: 300,
                  height: 200,
                  child: GestureDetector(
                    onTap: () {
                      controller.keepOpen.value = true;
                      controller.selectImage();
                    },
                    child: MouseRegion(
                      onEnter: (_) {
                        controller.preventPopupClose(true);
                      },
                      onExit: (_) {
                        controller.preventPopupClose(false);
                      },
                      child: Obx(
                        () {
                          if (controller.image.value != null) {
                            final file = controller.image.value!;
                            return kIsWeb
                                ? FutureBuilder<Uint8List>(
                                    future:
                                        controller.readFileAsUint8List(file),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        final uint8List = snapshot.data;
                                        return Image.memory(uint8List!,
                                            fit: BoxFit.cover);
                                      } else {
                                        return CircularProgressIndicator();
                                      }
                                    },
                                  )
                                : Image.file(
                                    file as File,
                                    fit: BoxFit.cover,
                                  );
                          } else {
                            return Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                border:
                                    Border.all(width: 1, color: Colors.black),
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image,
                                    size: 100,
                                  ),
                                  Text("Upload Image"),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Column(
                children: [
                  Obx(
                    () {
                      return SizedBox(
                        width: 230,
                        child: SwitchListTile(
                          value: controller.s.value,
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (bool value) {
                            controller.switchDevice('Android');
                          },
                          title: const Text('Android Image'),
                        ),
                      );
                    },
                  ),
                  Obx(
                    () {
                      return SizedBox(
                        width: 230,
                        child: SwitchListTile(
                          value: controller.s1.value,
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (bool value) {
                            controller.switchDevice('Chrome');
                          },
                          title: const Text('Chrome Image'),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Custom Image Sizes',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: controller.customSizeController,
                    decoration: const InputDecoration(
                      labelText: "Enter custom size (e.g., 64x64)",
                      hintText: "e.g., 64x64",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  controller.downloadImages(); // Download selected images
                },
                child: const Text('Download Image'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
