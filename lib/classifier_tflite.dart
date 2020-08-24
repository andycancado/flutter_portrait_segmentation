import 'package:flutter/services.dart';

// Import tflite_flutter
import 'package:tflite_flutter/tflite_flutter.dart';

class ClassifierTflite {
  // name of the model file
  final _modelFileName = 'test.tflite';

  // Maximum length of sentence
  final int _sentenceLen = 256;

  final String start = '<START>';
  final String pad = '<PAD>';
  final String unk = '<UNKNOWN>';

  Map<String, int> _dict;

  // TensorFlow Lite Interpreter object
  Interpreter _interpreter;

  ClassifierTflite() {
    // Load model when the classifier is initialized.
    _loadModel();
  }

  void _loadModel() async {
    // Creating the interpreter using Interpreter.fromAsset
    final modelFile = await rootBundle.load('assets/$_modelFileName');

    _interpreter = Interpreter.fromBuffer(modelFile.buffer.asUint8List());
    print(
        '::::::::::::: Interpreter loaded successfully::::: ${_interpreter.getInputIndex('input_2')}');
  }

  List<double> classify(String rawText) {
    // tokenizeInputText returns List<List<double>>
    // of shape [1, 256].
    List<List<double>> input = tokenizeInputText(rawText);

    // output of shape [1,2].
    var output = List<double>(2).reshape([1, 2]);

    // The run method will run inference and
    // store the resulting values in output.
    _interpreter.run(input, output);

    return [output[0][0], output[0][1]];
  }

  List<List<double>> tokenizeInputText(String text) {
    // Whitespace tokenization
    final toks = text.split(' ');

    // Create a list of length==_sentenceLen filled with the value <pad>
    var vec = List<double>.filled(_sentenceLen, _dict[pad].toDouble());

    var index = 0;
    if (_dict.containsKey(start)) {
      vec[index++] = _dict[start].toDouble();
    }

    // For each word in sentence find corresponding index in dict
    for (var tok in toks) {
      if (index > _sentenceLen) {
        break;
      }
      vec[index++] = _dict.containsKey(tok)
          ? _dict[tok].toDouble()
          : _dict[unk].toDouble();
    }

    // returning List<List<double>> as our interpreter input tensor expects the shape, [1,256]
    return [vec];
  }
}
