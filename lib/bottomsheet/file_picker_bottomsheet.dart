import 'dart:io';

import 'package:app/helper/AppConstantHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void filePickerBottomSheet(context, AppConstantHelper helper,Function(File) onFilePicked) async {
  Future<void> requestPermission(Permission permission,bool isCamera) async {


    Map<Permission, PermissionStatus> statuses = await [permission].request();
    PermissionStatus permissionStatus = statuses[permission];
    print("pickImage>>>>>${permissionStatus}");
    if (permissionStatus == PermissionStatus.granted) {

      await helper.pickImage(isCamera: isCamera, imagePicked: (file) {

        print("pickImage>>>>>${file.path}");
        onFilePicked(file);
      });

    } else {
      helper.showAlert(true, "need permission");
    }
  }

  return await showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: new Wrap(
            children: [
              new ListTile(
                  leading: new Icon(Icons.camera_alt),
                  title: new Text('Add Photo From Camera Roll'),
                  onTap: () {
                    requestPermission(Permission.camera,true);

                    Navigator.pop(context);
                  }),
              new ListTile(
                leading: new Icon(Icons.image),
                title: new Text('Add Photo From Gallery'),
                onTap: () {
                  if (Platform.isAndroid)
                    requestPermission(Permission.storage,false);
                  else
                    requestPermission(Permission.photos,false);

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      });
}
