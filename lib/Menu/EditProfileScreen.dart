import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class YourProfileObject {
  final String fullName;
  final String age;
  final String dob;
  final String? imagePath;

  YourProfileObject({
    required this.fullName,
    required this.age,
    required this.dob,
    this.imagePath,
  });
}

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _dobController = TextEditingController();

  String? _imagePath;

  YourProfileObject _getUpdatedProfile() {
    return YourProfileObject(
      fullName: _fullNameController.text,
      age: _ageController.text,
      dob: _dobController.text,
      imagePath: _imagePath,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: _showImageOptions,
                child: CircleAvatar(
                  radius: 50.0,
                  backgroundImage: _imagePath != null
                      ? AssetImage(_imagePath!)
                      : AssetImage('assets/default_profile_picture.jpg'),
                  child: Icon(
                    Icons.camera_alt,
                    size: 30.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            _buildTextField('Full Name', _fullNameController),
            _buildTextField('Age', _ageController),
            _buildTextField('Date of Birth', _dobController),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _getUpdatedProfile());
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose Image Source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('Take a Photo'),
                  onTap: () async {
                    Navigator.pop(context);
                    await _getImageFromCamera();
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text('Choose from Gallery'),
                  onTap: () async {
                    Navigator.pop(context);
                    await _getImageFromGallery();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _getImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  Future<void> _getImageFromCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
      ),
    );
  }
}
