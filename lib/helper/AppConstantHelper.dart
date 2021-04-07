import 'dart:io';
import 'package:app/ui/trips/commmon_widgets.dart';
import 'package:app/utils/app_constants.dart';
import 'package:app/utils/image_resource.dart';
import 'package:app/utils/string_resource.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AppConstantHelper {
  BuildContext context;

  AppConstantHelper._internal();

  static final AppConstantHelper _singleton = AppConstantHelper._internal();

  factory AppConstantHelper() {
    return _singleton;
  }

  setContext(BuildContext context) {
    this.context = context;
  }

  Future<bool> requestPermissionForStorageandCamera(bool isCamera) async {
    if (!isCamera) {
      print("Pickerrd1");
      Map<Permission, PermissionStatus> storageStatuses = await [
        Permission.storage,
      ].request().then((value) {
        if (value == PermissionStatus.granted) {
          print("Pickerrd");
        }
      });

      if (storageStatuses == PermissionStatus.denied ||
          storageStatuses == PermissionStatus.denied ||
          storageStatuses == PermissionStatus.restricted) {
        showAlert(true, "Nedd permissions");
      }
    } else {
      Map<Permission, PermissionStatus> cameraStatus = await [
        Permission.camera,
      ].request();

      if (cameraStatus == PermissionStatus.granted) {
        return true;
      }
      if (cameraStatus == PermissionStatus.denied ||
          cameraStatus == PermissionStatus.denied ||
          cameraStatus == PermissionStatus.restricted) {
        showAlert(true, "Nedd permissions");
      }
    }
  }

  File imageFile;

  Future<Null> pickImage({bool isCamera, Function(File) imagePicked}) async {
    imageFile = isCamera
        ? await ImagePicker.pickImage(
            source: ImageSource.camera,
          )
        : await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      print("imageFile>>${imageFile.path}");
      cropRectangleImage(false, imageFile).then((imgFile) async {
        if (imgFile != null) {
          if (imageFile == imgFile) {
          } else {
            //set & upload the image to server
            imagePicked(imageFile);
          }
        }
      });
    } else {
      showAlert(true, "Need Camera & Gellery Permission");
    }
  }

  Future<File> cropRectangleImage(
    bool isCircular,
    File imageFile,
  ) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      cropStyle: CropStyle.circle,
      aspectRatio: CropAspectRatio(
        ratioX: 1,
        ratioY: 1,
      ),
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          hideBottomControls: true,
          showCropGrid: false,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
    );
    iosUiSettings:
    IOSUiSettings(
      rotateButtonsHidden: true,
      minimumAspectRatio: 1.0,
    );

    if (croppedFile != null) {
      imageFile = croppedFile;
    }
    return imageFile;
  }

  void showAlert(bool val, String text) {
    print(context);
    var alert = AlertDialog(
      title: Text("Error"),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
        Radius.circular(10.0),
      )),
      content: Stack(
        children: <Widget>[
          Container(
            child: Text(
              text,
              style: TextStyle(fontSize: 16),
            ),
          ),
//          Positioned(
//              top: 0,
//              child: Image.asset(
//                Images.ICON_APP_NIGERIA,
//                height: 50,
//                width: 50,
//              ))
        ],
      ),
      actions: [
        new FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "OK",
              style: TextStyle(color: Colors.blue),
            ))
      ],
    );

    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  placeHolderImage({String imagePath, double height, double width}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(98)),
        child: Image.asset(
          'assets/images/profile.png',
          height: height,
          width: width,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  loadNetworkImage({String imageUrl, double height, double width}) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(height)),
      child: CachedNetworkImage(
              imageUrl: imageUrl,
              height: height,
              width: width,
              fit: BoxFit.cover,
              errorWidget: (a, b, c) {
                return placeHolderImage(
                    imagePath: ImageResource.profile, height: height, width: width);
              },
              placeholder: (BuildContext context, String url) {
                return placeHolderImage(
                    imagePath: ImageResource.placeHolderImage,
                    height: height,
                    width: width);
              },
            ),
    );
  }
  loadNetworkImageProfile({String imageUrl, double height, double width,String filePath}) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(height)),
      child: CachedNetworkImage(
              imageUrl: imageUrl,
              height: height,
              width: width,
              fit: BoxFit.cover,
              errorWidget: (a, b, c) {
                return Center(
                  child: Container(
                    height: 121,
                    width: 121,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.8)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(98)),
                      child: Stack(
                        children: <Widget>[
                          filePath == ''
                              ? Positioned(
                            top: 20,
                            right: 30,
                            left: 30,
                            bottom: 20,
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset(
                                  ImageResource.camera,
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  StringResource.upload_image,
                                  style: TextStyle(
                                    fontFamily:
                                    AppConstants.Poppins_Font,
                                    fontSize: 8,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          )
                              : Image.file(File(filePath)),
                        ],
                      ),
                    ),
                  ),
                );
              },
              placeholder: (BuildContext context, String url) {
                return placeHolderImage(
                    imagePath: ImageResource.placeHolderImage,
                    height: height,
                    width: width);
              },
            ),
    );
  }
}
