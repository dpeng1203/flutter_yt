import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_yt/common/flutter_easyloading/src/easy_loading.dart';
import 'package:flutter_app_yt/dao/my_dao.dart';
import 'package:image_picker/image_picker.dart';

import '../translations.dart';

class ImagePickerWidget extends StatefulWidget {
  final double width;
  final double height;
  final String title;
  final String imagePath;
  final callback;

  ImagePickerWidget(
      {Key key,
      this.width = 320,
      this.height = 110,
      this.title = '',
      this.callback,
      this.imagePath})
      : super(key: key);

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final ImagePicker _picker = ImagePicker();
  String _retrieveDataError;
  PickedFile _imageFile;

  Future<void> retrieveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      _retrieveDataError = response.exception.code;
    }
  }

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Widget _previewImage() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if(widget.imagePath != null) {
      return GestureDetector(
            onTap: () {
              _onImageButtonPressed(ImageSource.gallery, context: context);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Container(
                  width: widget.width,
                  height: widget.height,
                  child: Image.network(
                    widget.imagePath,
                    fit: BoxFit.cover,
                  )),
            ));
    }
    if (_imageFile != null) {
      if (kIsWeb) {
        // Why network?
        // See https://pub.flutter-io.cn/packages/image_picker#getting-ready-for-the-web-platform
       return Image.network(_imageFile.path);
      } else {
        return GestureDetector(
            onTap: () {
              _onImageButtonPressed(ImageSource.gallery, context: context);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Container(
                  width: widget.width,
                  height: widget.height,
                  child: Image.file(
                    File(_imageFile.path),
                    fit: BoxFit.cover,
                  )),
            ));
      }
    } else {
      return GestureDetector(
        onTap: () {
          _onImageButtonPressed(ImageSource.gallery, context: context);
        },
        child: Container(
            decoration: BoxDecoration(
                color: Color(0xff313644),
                borderRadius: BorderRadius.all(Radius.circular(8))),
            width: widget.width,
            height: widget.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.title == ''
                  ? [Icon(Icons.photo_camera)]
                  : [Icon(Icons.photo_camera), Text(widget.title)],
            )),
      );
    }
  }

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(
        source: source,
      );
      print(pickedFile);
      var model = await MyDao.upLoadImage(pickedFile);
      if (model['code'] == '2000') {
        EasyLoading.showSuccess(Translations.of(context).text('my_upload_success'));
        widget.callback(model['data']);
        setState(() {
          _imageFile = pickedFile;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
              ? FutureBuilder<void>(
                  future: retrieveLostData(),
                  builder:
                      (BuildContext context, AsyncSnapshot<void> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
//                        return const Text(
//                          '',
//                          textAlign: TextAlign.center,
//                        );
                      case ConnectionState.done:
                        return _previewImage();
                      default:
                        return const Text(
                          'You have not yet picked an image.',
                          textAlign: TextAlign.center,
                        );
                    }
                  },
                )
              : _previewImage(),
        ),
      ],
    );
  }
}
