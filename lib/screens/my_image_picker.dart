import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:tflite_image_classifier/classifier.dart';
import 'package:tflite_image_classifier/helpers/tflite_utils.dart';
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
  Classifier classifier = Classifier(
      modelName: "portrait_segmentation", labelsFileName: "labels.txt");

  @override
  void initState() {
    super.initState();
    classifier.loadModel();
    //loadModel(ModelType.portrait_segmentation);
  }

  // void loadModel(ModelType modelType) async {
  //   switch (modelType) {
  //     case ModelType.model_unquant:
  //       await Tflite.loadModel(
  //         model: "assets/model_unquant.tflite",
  //         labels: "assets/labels.txt",
  //       );
  //       print(':::::::::::::::::::::::::::model_unquant:::');
  //       break;
  //     case ModelType.portrait_segmentation:
  //       await Tflite.loadModel(model: "assets/portrait_segmentation.tflite");
  //       print(':::::::::::::::::::::::::::Portrait_segmentation:::');
  //       break;
  //     case ModelType.slimNet:
  //       await Tflite.loadModel(model: "assets/slim_reshape.tflite");
  //       print(':::::::::::::::::::::::::::Slim_reshape.tflite:::');

  //       break;
  //     default:
  //       break;
  //   }
  // }

  Future recognizeImage(File image) async {
    // int startTime = new DateTime.now().millisecondsSinceEpoch;

    // var recognitions = await Tflite.runSegmentationOnImage(path: image.path);

    // int endTime = new DateTime.now().millisecondsSinceEpoch;
    // print("Inference took ----> ${endTime - startTime}ms");

    var recognitions = await classifier.predictSegmentation(image.path);
    await showDialog(
        context: context, builder: (_) => ImageDialog(recognitions));
  }

  Future getImgFromCamera() async {
    var img = await picker.getImage(
        source: ImageSource.camera, maxHeight: 224, maxWidth: 224);

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

    // var output = await Tflite.runModelOnImage(path: path);

    // setState(() {
    //   result = output.toString();
    // });
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
              margin: EdgeInsets.fromLTRB(0, 30, 0, 20),
              child: RaisedButton(
                onPressed: () => getImgFromCamera(),
                child: Text('Get Image from Camera'),
                textColor: Colors.white,
                color: Colors.blue,
                padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: RaisedButton(
                onPressed: () => getImageFromGallery(),
                child: Text('Get Image from Gallery'),
                textColor: Colors.white,
                color: Colors.blue,
                padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 30, 0, 20),
              child: RaisedButton(
                onPressed: () => classifyImage(),
                child: Text('Run Inference'),
                textColor: Colors.white,
                color: Colors.blue,
                padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
              ),
            ),
            result == null ? Text('Result') : Text(result)
          ],
        ),
      ),
    );
  }
}
