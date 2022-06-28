import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pckedImage) imagePickFn;

  const UserImagePicker(this.imagePickFn);

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage = File('');

  void _pickImage() async {
    final ImagePicker _picker = ImagePicker();

    // Capture a photo
    final XFile? pickedImageFile =
        await _picker.pickImage(source: ImageSource.camera,imageQuality: 50,maxWidth:150 );

    setState(() {
      _pickedImage =
          File(pickedImageFile?.path != null ? pickedImageFile!.path : '');
      widget.imagePickFn(_pickedImage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage) : null,
        ),
        FlatButton.icon(
          onPressed: _pickImage,
          textColor: Theme.of(context).primaryColor,
          label: Text('Add Image'),
          icon: Icon(Icons.image),
        ),
      ],
    );
  }
}
