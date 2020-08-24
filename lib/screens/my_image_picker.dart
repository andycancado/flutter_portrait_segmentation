import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_image_classifier/classifier.dart';
import 'package:tflite_image_classifier/screens/ImageOverlay.dart';

import 'package:tflite_image_classifier/widgets/ImageDialog.dart';

class MyImagePicker extends StatefulWidget {
  MyImagePicker({Key key}) : super(key: key);

  @override
  _MyImagePickerState createState() => _MyImagePickerState();
}

class _MyImagePickerState extends State<MyImagePicker> {
  File imageURI;
  String result;
  String path;
  final picker = ImagePicker();
  Classifier classifier =
      Classifier(modelName: "portrait_segmentation", labelsFileName: "");

  //ClassifierTflite classifierTflite = ClassifierTflite();

  // ClassifierTflitePlugin classifierTflitePlugin = ClassifierTflitePlugin();
//deeplabv3_257_mv_gpu.tflite
  @override
  void initState() {
    super.initState();
    //classifier.loadModel();
  }

  Future recognizeImage(File image) async {
    //classifierTflitePlugin.textClassify();

    //   var imageBytes = image.readAsBytesSync();
    // var oriImage = imgs.decodeJpg(imageBytes);
    // var resizedImage = imgs.copyResize(oriImage, height: 256, width: 256);

    //   var recognitions = await classifier.predictModelImage(imageBytes);
    //   await showDialog(
    //       context: context, builder: (_) => ImageDialog(recognitions));
    // }

    //classifierTflitePlugin.textClassify();
    var recognitions = await classifier.predictSegmentation(image.path);
    await showDialog(
        context: context, builder: (_) => ImageDialog(recognitions));
  }

  void runInference2(BuildContext context) async {
    var recognitions = await classifier.predictSegmentation(imageURI.path);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ImageOverlay(
                  maskFile: recognitions,
                  originalFile: imageURI,
                )));
  }

  Future getImgFromCamera() async {
    var img = await picker.getImage(
        source: ImageSource.camera, maxHeight: 256, maxWidth: 256);

    setState(() {
      imageURI = File(img.path);
      path = img.path;
    });
  }

  Future getImageFromGallery() async {
    var image = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      imageURI = File(image.path);
      path = image.path;
    });
  }

  Future classifyImage() async {
    if (imageURI == null) {
      Fluttertoast.showToast(msg: 'Image Not Selected');
      return;
    }
    recognizeImage(imageURI);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            imageURI == null
                ? Text('No Image Selected')
                : Image.file(imageURI,
                    width: 224, height: 224, fit: BoxFit.cover),
            Container(
              margin: EdgeInsets.fromLTRB(20, 30, 20, 20),
              child: SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  onPressed: () => getImgFromCamera(),
                  child: Text('Get Image from Camera'),
                  textColor: Colors.white,
                  color: Colors.blue,
                  padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  onPressed: () => getImageFromGallery(),
                  child: Text('Get Image from Gallery'),
                  textColor: Colors.white,
                  color: Colors.blue,
                  padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                ),
              ),
            ),
            // Container(
            //   margin: EdgeInsets.fromLTRB(0, 30, 0, 20),
            //   child: RaisedButton(
            //     onPressed: () => Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => ImageApp())),
            //     //onPressed: () => classifyImage(),
            //     child: Text('Run Inference'),
            //     textColor: Colors.white,
            //     color: Colors.blue,
            //     padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
            //   ),
            // ),
            Container(
                margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    onPressed: () => runInference2(context),
                    child: Text('Run Inference 2'),
                    textColor: Colors.white,
                    color: Colors.blue,
                    padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                  ),
                )),
            // result == null ? Text('Result') : Text(result)
          ],
        ),
      ),
    );
  }
}
