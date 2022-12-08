import 'dart:io' as io;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'camera_view.dart';
import '../painters/label_detector_painter.dart';

class ImageLabelView extends StatefulWidget {
  const ImageLabelView({super.key});

  @override
  State<ImageLabelView> createState() => _ImageLabelViewState();
}

class _ImageLabelViewState extends State<ImageLabelView> {
  late ImageLabeler _imageLabeler;
  bool _canProcess = false;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  int _goodCount = 0;
  int _badCount = 0;
  int _goodLevel = 0;
  int _badLevel = 0;
  int _goodCount2 = 0;
  String _status = 'none';

  @override
  void initState() {
    super.initState();

    _initializeLabeler();
  }

  @override
  void dispose() {
    _canProcess = false;
    _imageLabeler.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CameraView(
      title: '같이 양치질 해요!',
      customPaint: _customPaint,
      text: _text,
      onImage: processImage,
      goodCount2: _goodCount2,
      goodLevel: _goodLevel,
      badLevel: _badLevel,
      status: _status,
    );
  }

  void _initializeLabeler() async {
    const path = 'assets/ml/model_brushing.tflite';
    final modelPath = await _getModel(path);
    final options = LocalLabelerOptions(modelPath: modelPath);
    _imageLabeler = ImageLabeler(options: options);

    _canProcess = true;
  }

  void _incrementCounts(List labels) {
    for (final label in labels) {
      if (label.label == 'good') {
        _goodCount += 1;
        _goodLevel = _goodCount ~/ 10;
        _goodCount2 += 1;
        if (_goodCount2 == 11) _goodCount2 = 0;
        _badCount = 0;
        _status = 'good';
        //print('good: $_goodLevel');
      } else if (label.label == 'bad') {
        _badCount += 1;
        _badLevel = _badCount ~/ 10;
        _status = 'bad';
        //print('bad: $_badLevel');
      }
    }
  }

  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final labels = await _imageLabeler.processImage(inputImage);

    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = LabelDetectorPainter(labels);
      _customPaint = CustomPaint(painter: painter);
    } else {
      String text = 'Labels found: ${labels.length}\n\n';
      for (final label in labels) {
        text += 'Label: ${label.label}, '
            'Confidence: ${label.confidence.toStringAsFixed(2)}\n\n';
      }
      _text = text;
      _customPaint = null;
    }

    _incrementCounts(labels);

    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<String> _getModel(String assetPath) async {
    if (io.Platform.isAndroid) {
      return 'flutter_assets/$assetPath';
    }
    final path = '${(await getApplicationSupportDirectory()).path}/$assetPath';
    await io.Directory(dirname(path)).create(recursive: true);
    final file = io.File(path);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(assetPath);
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }
}
