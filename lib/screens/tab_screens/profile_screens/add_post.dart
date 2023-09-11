import 'dart:io';

import '/api_services.dart';
import '/app_config/app_details.dart';
import '/widget/navigator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../app_config/colors.dart';
import '../../../providers/profile_provider.dart';
import '../../../widget/sahared_prefs.dart';
import '../../../widget/widgets.dart';

class AddPostScreen extends StatefulWidget {
  final String imageId;
  const AddPostScreen({super.key, this.imageId = ''});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final ApiServices _apiServices = ApiServices();

  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                Text('Add Post',
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
          ])),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _image == null
          ? gap(0)
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: fullWidthButton(
                  buttonName: 'Upload Post',
                  onTap: () {
                    final provider =
                        Provider.of<ProfileProvider>(context, listen: false);

                    _apiServices
                        .imageUpload(
                            context,
                            _image!,
                            '${baseUrl}user/post' +
                                (widget.imageId == ''
                                    ? ''
                                    : '/${widget.imageId}'),
                            update: widget.imageId == '' ? false : true)
                        .then((value) {
                      if (value) {
                        dialog(context, 'Post Uploaded Successfully.', () {
                          Nav.pop(context);
                          Nav.pop(context);

                          Prefs.getToken().then((token) {
                            Prefs.getPrefs('userId').then((userId) {
                              _apiServices
                                  .get(
                                      context: context,
                                      endpoint: 'user/profile/$userId',
                                      progressBar: false)
                                  .then((value) {
                                if (value['flag'] == true) {
                                  provider.chnageProfile(value);
                                  provider.chnagePosts(value['data']['posts']);
                                }
                              });
                            });
                          });
                        });
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
    _image = File(image!.path);
    setState(() {});
  }
}
