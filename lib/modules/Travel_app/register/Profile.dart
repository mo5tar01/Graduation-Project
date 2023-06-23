
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  File? _profilePicture;

  Future<void> _pickProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profilePicture = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: _pickProfilePicture,
          child: SizedBox(
            width: 200,
            height: 200,
            child: _profilePicture != null
                ? Image.file(_profilePicture!)
                : Container(
              color: Colors.grey,
              child: Icon(Icons.camera_alt),
            ),
          ),
        ),
      ),
    );
  }
}