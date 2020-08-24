import 'dart:typed_data';
import 'package:tflite/tflite.dart';
import 'package:image/image.dart' as imgLib;

class Classifier {
  String modelName;
  String labelsFileName;

  Classifier({this.modelName, this.labelsFileName}) {
    loadModel();
  }

  Future<void> loadModel() async {
    labelsFileName ??= "";

    var res = await Tflite.loadModel(
      model: "assets/$modelName.tflite",
      labels: labelsFileName.isEmpty ? "" : "assets/$labelsFileName",
    );
    print("::::::::::::::::::: $res");
  }

  Future<Uint8List> predictSegmentation(String imagePath) async {
    int startTime = new DateTime.now().millisecondsSinceEpoch;
    var recognitions = await Tflite.runSegmentationOnImage(
        path: imagePath, imageMean: 0, imageStd: 255);

    int endTime = new DateTime.now().millisecondsSinceEpoch;
    print("Inference took ----> ${endTime - startTime}ms");

    return recognitions;
  }

  Future<Uint8List> predictModelImage(Uint8List imagePath) async {
    int startTime = new DateTime.now().millisecondsSinceEpoch;
    // var recognitions = await Tflite.runModelOnImage(
    //   path: imagePath,
    //   numResults: 6,
    //   threshold: 0.05,
    //   imageMean: 127.5,
    //   imageStd: 127.5,
    // );

    var recognitions = await Tflite.runModelOnBinary(
      binary: imagePath,
      numResults: 2,
      threshold: 0.1,
    );

    int endTime = new DateTime.now().millisecondsSinceEpoch;
    print("Inference took ----> ${endTime - startTime}ms");

    return recognitions;
  }
}
