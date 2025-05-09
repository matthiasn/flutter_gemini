import 'dart:typed_data';
import 'package:example/widgets/chat_input_box.dart';
import 'package:example/widgets/item_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:image_picker/image_picker.dart';

class SectionTextStreamInput extends StatefulWidget {
  const SectionTextStreamInput({super.key});

  @override
  State<SectionTextStreamInput> createState() => _SectionTextInputStreamState();
}

class _SectionTextInputStreamState extends State<SectionTextStreamInput> {
  final ImagePicker picker = ImagePicker();
  final controller = TextEditingController();
  final gemini = Gemini.instance;
  String? searchedText,
      // result,
      _finishReason;

  List<Uint8List>? images;
  String result = '';

  String? get finishReason => _finishReason;

  set finishReason(String? set) {
    if (set != _finishReason) {
      setState(() => _finishReason = set);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (searchedText != null)
          MaterialButton(
              color: Colors.blue.shade700,
              onPressed: () {
                setState(() {
                  searchedText = null;
                  finishReason = null;
                  // result = null;
                });
              },
              child: Text('search: $searchedText')),
        Expanded(child: Markdown(data: result)),

        /// if the returned finishReason isn't STOP
        if (finishReason != null) Text(finishReason!),

        if (images != null)
          Container(
            height: 120,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            alignment: Alignment.centerLeft,
            child: Card(
              child: ListView.builder(
                itemBuilder: (context, index) => ItemImageView(
                  bytes: images!.elementAt(index),
                ),
                itemCount: images!.length,
                scrollDirection: Axis.horizontal,
              ),
            ),
          ),

        /// imported from local widgets
        ChatInputBox(
          controller: controller,
          onClickCamera: () {
            picker.pickMultiImage().then((value) async {
              final imagesBytes = <Uint8List>[];
              for (final file in value) {
                imagesBytes.add(await file.readAsBytes());
              }

              if (imagesBytes.isNotEmpty) {
                setState(() {
                  images = imagesBytes;
                });
              }
            });
          },
          onSend: () {
            if (controller.text.isNotEmpty) {
              print('request');

              searchedText = controller.text;
              controller.clear();
              gemini
                  .streamGenerateContent(searchedText!,
                      images: images,
                      modelName: 'models/gemini-2.0-flash-latest')
                  .handleError((e) {
                if (e is GeminiException) {
                  print(e);
                }
              }).listen((value) {
                setState(() {
                  images = null;
                });
                result = (result) + (value.output ?? '');

                if (value.finishReason != 'STOP') {
                  finishReason = 'Finish reason is `${value.finishReason}`';
                }
              });
            }
          },
        )
      ],
    );
  }
}
