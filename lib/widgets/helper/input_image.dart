import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class InputImage extends StatefulWidget {
  const InputImage({super.key, required this.onPickedImage});

  final void Function(File pickedImage) onPickedImage;

  @override
  State<InputImage> createState() => _InputImageState();
}

class _InputImageState extends State<InputImage> {
  File? _pickedImageFile;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await _picker.pickImage(
      source: source,
      maxWidth: 300,
    );

    if (pickedImage == null) return;

    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });
    widget.onPickedImage(_pickedImageFile!);
    Navigator.of(context).pop();
  }

  void _showPickOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blue),
              title: const Text('Take Photo'),
              onTap: () => _pickImage(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo, color: Colors.green),
              title: const Text('Choose from Gallery'),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _showPickOptions,
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[300],
            backgroundImage:
                _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
            child: _pickedImageFile == null
                ? const Icon(Icons.add_a_photo, size: 30, color: Colors.black54)
                : null,
          ),
        ),
        const SizedBox(height: 10),
        const Text("Tap to add profile picture"),
      ],
    );
  }
}
