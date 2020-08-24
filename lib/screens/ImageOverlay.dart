import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImageOverlay extends StatefulWidget {
  final Uint8List maskFile;
  final File originalFile;

  const ImageOverlay(
      {Key key, @required this.maskFile, @required this.originalFile})
      : super(key: key);
  @override
  _ImageAppState createState() => _ImageAppState();
}

class _ImageAppState extends State<ImageOverlay> {
  final double handleWidth = 30;

  double leftStart;
  double containerWidth = 100;

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Stack(
        children: <Widget>[
          Container(
              width: screenW,
              height: screenH,
              color: Colors.white,
              child: FutureBuilder(
                  future: getFutureImage(screenW, screenH),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        height: 224,
                        width: 224,
                        child: snapshot.data,
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  })),
          Container(
              width: containerWidth,
              height: screenH,
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 0,
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Colors.grey,
                        BlendMode.saturation,
                      ),
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                            Colors.grey[100], BlendMode.exclusion),
                        child: Image.memory(
                          widget.maskFile,
                          width: screenW,
                          height: screenH,
                          gaplessPlayback: true,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onHorizontalDragStart: (details) {
                        setState(() {
                          leftStart = details.localPosition.dx;
                        });
                      },
                      onHorizontalDragUpdate: (details) {
                        var offsetWidth = details.globalPosition.dx + leftStart;

                        setState(() {
                          if (offsetWidth < handleWidth) {
                            containerWidth = handleWidth;
                          } else {
                            containerWidth = offsetWidth;
                          }
                        });
                      },
                      child: Stack(
                        children: [
                          SizedBox(
                            height: screenH,
                            width: handleWidth,
                            child: Opacity(
                              opacity: 0.01,
                              child: Container(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          Container(
                            width: handleWidth,
                            height: screenH,
                            child: Stack(children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  color: Colors.red,
                                  width: 1,
                                ),
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }

  Future<Image> getFutureImage(double w, double h) async {
    return Image.memory(
      await widget.originalFile.readAsBytes(),
      width: 150,
      height: 150,
      gaplessPlayback: true,
      fit: BoxFit.fill,
    );
  }
}
