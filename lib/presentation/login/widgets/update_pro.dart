import 'dart:io';

// import 'package:echonest/data/utils/image_picker.dart';
import 'package:echonest/presentation/colors/contantColors.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class UploadProfilePictureWidget extends StatefulWidget {
  final Function(File?) onchanged;
  const UploadProfilePictureWidget({super.key, required this.onchanged});

  @override
  State<UploadProfilePictureWidget> createState() =>
      _UploadProfilePictureWidgetState();
}

class _UploadProfilePictureWidgetState
    extends State<UploadProfilePictureWidget> {
  final ImagePicker _picker = ImagePicker();
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: 150,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text('Choose Profile Photo',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(
                      width: 60,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.close,
                        color: loginPagetextcolor,
                        size: 24,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      takePhoto(ImageSource.camera);
                    },
                    icon: const Icon(
                      CupertinoIcons.camera,
                      color: loginPagetextcolor,
                    ),
                    label: const Text(
                      'Camera',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  TextButton.icon(
                      onPressed: () async {
                        takePhoto(ImageSource.gallery);
                      },
                      icon: const Icon(
                        CupertinoIcons.photo,
                        color: loginPagetextcolor,
                      ),
                      label: const Text(
                        'Gallery',
                        style: TextStyle(fontSize: 16),
                      )),
                ],
              )
            ],
          ),
        ));
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      print("No image selected ");
    }
    widget.onchanged(_image);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }
}
