import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:animated_background/animated_background.dart';

import '../../main.dart';
import 'brushing_clear.dart';

enum ScreenMode { liveFeed, gallery }

class CameraView extends StatefulWidget {
  const CameraView({
    Key? key,
    required this.title,
    required this.customPaint,
    this.text,
    required this.onImage,
    this.onScreenModeChanged,
    this.initialDirection = CameraLensDirection.front,
    required this.goodLevel,
    required this.badLevel,
    required this.status,
    required this.goodCount2,
  }) : super(key: key);

  final String title;
  final CustomPaint? customPaint;
  final String? text;
  final Function(InputImage inputImage) onImage;
  final Function(ScreenMode mode)? onScreenModeChanged;
  final CameraLensDirection initialDirection;
  final int goodCount2;
  final int goodLevel;
  final int badLevel;
  final String status;

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> with TickerProviderStateMixin {
  ScreenMode _mode = ScreenMode.liveFeed;
  CameraController? _controller;
  File? _image;
  String? _path;
  ImagePicker? _imagePicker;
  int _cameraIndex = -1;
  double zoomLevel = 0.0, minZoomLevel = 0.0, maxZoomLevel = 0.0;
  final bool _allowPicker = true;
  bool _changingCameraLens = false;
  bool nextButtonVisible = false;

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();

    if (cameras.any(
      (element) =>
          element.lensDirection == widget.initialDirection &&
          element.sensorOrientation == 90,
    )) {
      _cameraIndex = cameras.indexOf(
        cameras.firstWhere((element) =>
            element.lensDirection == widget.initialDirection &&
            element.sensorOrientation == 90),
      );
    } else {
      for (var i = 0; i < cameras.length; i++) {
        if (cameras[i].lensDirection == widget.initialDirection) {
          _cameraIndex = i;
          break;
        }
      }
    }

    if (_cameraIndex != -1) {
      _startLiveFeed();
    } else {
      _mode = ScreenMode.gallery;
    }
  }

  @override
  void dispose() {
    _stopLiveFeed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (_allowPicker)
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: //카메라전환
                  GestureDetector(
                onTap: _switchLiveCamera,
                child: Icon(
                  Platform.isIOS
                      ? Icons.flip_camera_ios_outlined
                      : Icons.flip_camera_android_outlined,
                  size: 30,
                ),
              ),
            ),
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    Widget body;
    if (_mode == ScreenMode.liveFeed) {
      body = _liveFeedBody();
    } else {
      body = _galleryBody();
    }
    return body;
  }

  Widget _liveFeedBody() {
    String status = widget.status;
    int goodLevel = widget.goodLevel;

    // _goodLevel이 120이 되면 3초 뒤에 ClearBrushing() 화면으로 넘어감
    if (goodLevel / 120 == 1) {
      nextButtonVisible = true;
    }

    if (_controller?.value.isInitialized == false) {
      return Container();
    }

    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * _controller!.value.aspectRatio;
    // to prevent scaling down, invert the value
    if (scale < 1) scale = 1 / scale;

    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Transform.scale(
            scale: scale,
            child: Center(
              child: _changingCameraLens
                  ? const Center(
                      child: Text('Changing camera lens'),
                    )
                  : CameraPreview(_controller!),
            ),
          ),
          if (widget.customPaint != null)
            widget.customPaint!, //Label, Confidence표시
          if (status == 'good' && goodLevel <= 20)
            _goodBackground20(), //good일때 배경
          if (status == 'good' && goodLevel > 20 && goodLevel <= 50)
            _goodBackground50(),
          if (status == 'good' && goodLevel > 50) _goodBackground100(),
          Align(
            //유튜브플레이어
            alignment: Alignment.bottomCenter + const Alignment(0, -0.1),
            child: _youtubePlayer(),
          ),
          Align(
            //goodLevel표시 프로세스바
            alignment: Alignment.topCenter + const Alignment(0, 0.1),
            child: _processGood(),
          ),
          Align(
            //goodLevel표시 프로세스바2
            alignment: Alignment.topCenter + const Alignment(0, 0.2),
            child: _processGood_2(),
          ),
          Visibility(
              visible: nextButtonVisible,
              child: Align(
                alignment: Alignment.topCenter + const Alignment(0, 0.5),
                child: const Text(
                  '양치질이 끝났습니다.\n잘했어요!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              )),
          Visibility(
              //goodLevel표시 프로세스바3
              visible: nextButtonVisible,
              child: Align(
                  alignment: Alignment.topCenter + const Alignment(0, 0.3),
                  child: ElevatedButton(
                    //핑크색
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 197, 24, 82),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ClearBrushing()),
                      );
                    },
                    child: const Text('양치질 완료',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  )))
        ],
      ),
    );
  }

  Widget _goodBackground20() {
    //goodLevel이 20이하일때 배경
    return AnimatedBackground(
      behaviour: RandomParticleBehaviour(
        options: const ParticleOptions(
          baseColor: Colors.white,
          spawnOpacity: 0.0,
          opacityChangeRate: 0.25,
          minOpacity: 0.1,
          maxOpacity: 0.25,
          spawnMinSpeed: 50.0,
          spawnMaxSpeed: 100.0,
          spawnMinRadius: 7.0,
          spawnMaxRadius: 15.0,
          particleCount: 50,
        ),
        paint: Paint()..style = PaintingStyle.fill,
      ),
      vsync: this,
      child: const SizedBox(),
    );
  }

  Widget _goodBackground50() {
    //goodLevel이 50이하일때 배경
    return AnimatedBackground(
      behaviour: BubblesBehaviour(),
      vsync: this,
      child: const SizedBox(),
    );
  }

  Widget _goodBackground100() {
    //goodLevel이 50이상일때 배경, 하트이미지
    return AnimatedBackground(
      behaviour: RandomParticleBehaviour(
        options: const ParticleOptions(
          image: Image(
            image: AssetImage('assets/images/heart.png'),
          ),
        ),
      ),
      vsync: this,
      child: const SizedBox(),
    );
  }

  Widget _processGood() {
    //goodLevel진행을 나타내는 ProgressIndicator, 120초
    int goodLevel = widget.goodLevel;
    return Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: LinearProgressIndicator(
          minHeight: 25,
          value: goodLevel / 120,
          backgroundColor: Colors.white54,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.yellow),
        ));
  }

  Widget _processGood_2() {
    //goodLevel진행을 나타내는 ProgressIndicator, 짧은버전. 10초
    int goodCount2 = widget.goodCount2;
    return Container(
        padding: const EdgeInsets.only(left: 35, right: 35),
        child: LinearProgressIndicator(
          minHeight: 8,
          value: goodCount2 / 10,
          backgroundColor: Colors.white54,
          valueColor: const AlwaysStoppedAnimation<Color>(
              Color.fromARGB(255, 255, 136, 0)),
        ));
  }

  Widget _youtubePlayer() {
    //유튜브플레이어
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: YoutubePlayer(
        controller: YoutubePlayerController(
          initialVideoId: 'Bw_Wj7sDEv8', // 유튜브 영상 ID
          flags: const YoutubePlayerFlags(
            autoPlay: false, // 자동 재생
            mute: false, // 소리 켜기
          ),
        ),
      ),
    );
  }

  Widget _galleryBody() {
    return ListView(shrinkWrap: true, children: [
      _image != null
          ? SizedBox(
              height: 400,
              width: 400,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image.file(_image!),
                  if (widget.customPaint != null) widget.customPaint!,
                ],
              ),
            )
          : const Icon(
              Icons.image,
              size: 200,
            ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ElevatedButton(
          child: const Text('From Gallery'),
          onPressed: () => _getImage(ImageSource.gallery),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ElevatedButton(
          child: const Text('Take a picture'),
          onPressed: () => _getImage(ImageSource.camera),
        ),
      ),
      if (_image != null)
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
              '${_path == null ? '' : 'Image path: $_path'}\n\n${widget.text ?? ''}'),
        ),
    ]);
  }

  Future _getImage(ImageSource source) async {
    setState(() {
      _image = null;
      _path = null;
    });
    final pickedFile = await _imagePicker?.pickImage(source: source);
    if (pickedFile != null) {
      _processPickedFile(pickedFile);
    }
    setState(() {});
  }

  Future _startLiveFeed() async {
    final camera = cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _controller?.getMinZoomLevel().then((value) {
        zoomLevel = value;
        minZoomLevel = value;
      });
      _controller?.getMaxZoomLevel().then((value) {
        maxZoomLevel = value;
      });
      _controller?.startImageStream(_processCameraImage);
      setState(() {});
    });
  }

  Future _stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }

  Future _switchLiveCamera() async {
    setState(() => _changingCameraLens = true);
    _cameraIndex = (_cameraIndex + 1) % cameras.length;

    await _stopLiveFeed();
    await _startLiveFeed();
    setState(() => _changingCameraLens = false);
  }

  Future _processPickedFile(XFile? pickedFile) async {
    final path = pickedFile?.path;
    if (path == null) {
      return;
    }
    setState(() {
      _image = File(path);
    });
    _path = path;
    final inputImage = InputImage.fromFilePath(path);
    widget.onImage(inputImage);
  }

  Future _processCameraImage(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());

    final camera = cameras[_cameraIndex];
    final imageRotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    if (imageRotation == null) return;

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(image.format.raw);
    if (inputImageFormat == null) return;

    final planeData = image.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final inputImage =
        InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

    widget.onImage(inputImage);
  }
}
