import 'dart:io';

import 'package:bar_monkey/api_calls.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../api_services.dart';
import '../../../app_config/app_details.dart';
import '../../../app_config/colors.dart';
import '../../../widget/navigator.dart';
import '../../../widget/widgets.dart';

class ChangeProfilePic extends StatefulWidget {
  const ChangeProfilePic({super.key});

  @override
  State<ChangeProfilePic> createState() => _ChangeProfilePicState();
}

class _ChangeProfilePicState extends State<ChangeProfilePic> {
  final ApiServices _apiServices = ApiServices();

  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              statusBar(context),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Nav.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: primaryTextColor,
                    ),
                  ),
                  horGap(20),
                  Text('Profile Picture',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor)),
                ],
              ),
              gap(30),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: primaryColor)),
                  child: InkWell(
                    onTap: () {
                      showImagePicker();
                    },
                    child: _image == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Icon(FontAwesomeIcons.fileImage,
                                    color: primaryColor, size: 40),
                                gap(10),
                                Text('Select an Image',
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold))
                              ])
                        : Image.file(File(_image!.path), fit: BoxFit.cover),
                  ),
                ),
              ])
            ]),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _image == null
          ? gap(0)
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: fullWidthButton(
                  buttonName: 'Upload Image',
                  onTap: () {
                    _apiServices
                        .imageUpload(context, _image!, '${baseUrl}user/image')
                        .then((value) {
                      if (value) {
                        dialog(context, 'Post Uploaded Successfully.', () {
                          Nav.pop(context);
                          Nav.pop(context);
                        });
                        ApiCalls().profile(context);
                      } else {
                        dialog(context, 'Something Went Wrong', () {
                          Nav.pop(context);
                        });
                      }
                    });
                  }),
            ),
    );
  }

  showImagePicker() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    // _image = File(image!.path);

   CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: backgroundColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(title: 'Cropper'),
      ],
    );

    _image = File(croppedFile!.path);

    setState(() {});
  }
}
