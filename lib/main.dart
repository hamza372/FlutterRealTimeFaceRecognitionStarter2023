import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;

import 'ML/Recognition.dart';


late List<CameraDescription> cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  dynamic controller;
  bool isBusy = false;
  late Size size;
  late CameraDescription description = cameras[1];
  CameraLensDirection camDirec = CameraLensDirection.front;
  late List<Recognition> recognitions = [];

  //TODO declare face detector

  //TODO declare face recognizer

  @override
  void initState() {
    super.initState();

    //TODO initialize face detector

    //TODO initialize face recognizer

    //TODO initialize camera footage
    initializeCamera();
  }

  //TODO code to initialize the camera feed
  initializeCamera() async {
    controller = CameraController(description, ResolutionPreset.high);
    await controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      controller.startImageStream((image) => {
            if (!isBusy) {isBusy = true, frame = image, doFaceDetectionOnFrame()}
          });
    });
  }

  //TODO close all resources
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  //TODO face detection on a frame
  dynamic _scanResults;
  CameraImage? frame;
  doFaceDetectionOnFrame() async {
    //TODO convert frame into InputImage format

    //TODO pass InputImage to face detection model and detect faces

    //TODO perform face recognition on detected faces

    setState(() {
      isBusy = false;
    });
  }

  // img.Image? image;
  // bool register = false;
  ////TODO perform Face Recognition
  // performFaceRecognition(List<Face> faces) async {
  //   recognitions.clear();
  //
  //   //TODO convert CameraImage to Image and rotate it so that our frame will be in a portrait
  //   image = convertYUV420ToImage(frame!);
  //   image =img.copyRotate(image!, camDirec == CameraLensDirection.front?270:90);
  //
  //   for (Face face in faces) {
  //     Rect faceRect = face.boundingBox;
  //     //TODO crop face
  //     image = img.copyCrop(image!, faceRect.left.toInt(),faceRect.top.toInt(),faceRect.width.toInt(),faceRect.height.toInt());
  //
  //     //TODO pass cropped face to face recognition model
  //     Recognition recognition = _recognizer.recognize(image!, faceRect);
  //     if(recognition.distance>1){
  //       recognition.name = "Unknown";
  //     }
  //     recognitions.add(recognition);
  //
  //     //TODO show face registration dialogue
  //     if(register){
  //       showFaceRegistrationDialogue(image!,recognition);
  //       register = false;
  //     }
  //
  //   }
  //
  //   setState(() {
  //     isBusy  = false;
  //     _scanResults = faces;
  //   });
  //
  // }

  ////TODO Face Registration Dialogue
  // TextEditingController textEditingController = TextEditingController();
  // showFaceRegistrationDialogue(img.Image croppedFace, Recognition recognition){
  //   showDialog(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       title: const Text("Face Registration",textAlign: TextAlign.center),alignment: Alignment.center,
  //       content: SizedBox(
  //         height: 340,
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             const SizedBox(height: 20,),
  //             Image.memory(Uint8List.fromList(img.encodeBmp(croppedFace!)),width: 200,height: 200,),
  //             SizedBox(
  //               width: 200,
  //               child: TextField(
  //                   controller: textEditingController,
  //                   decoration: const InputDecoration( fillColor: Colors.white, filled: true,hintText: "Enter Name")
  //               ),
  //             ),
  //             const SizedBox(height: 10,),
  //             ElevatedButton(
  //                 onPressed: () {
  //                   Recognizer.registered.putIfAbsent(
  //                       textEditingController.text, () => recognition);
  //                   textEditingController.text = "";
  //                   Navigator.pop(context);
  //                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //                     content: Text("Face Registered"),
  //                   ));
  //                 },style: ElevatedButton.styleFrom(primary:Colors.blue,minimumSize: const Size(200,40)),
  //                 child: const Text("Register"))
  //           ],
  //         ),
  //       ),contentPadding: EdgeInsets.zero,
  //     ),
  //   );
  // }

  ////TODO method to convert CameraImage to Image
  // img.Image convertYUV420ToImage(CameraImage cameraImage) {
  //   final width = cameraImage.width;
  //   final height = cameraImage.height;
  //
  //   final yRowStride = cameraImage.planes[0].bytesPerRow;
  //   final uvRowStride = cameraImage.planes[1].bytesPerRow;
  //   final uvPixelStride = cameraImage.planes[1].bytesPerPixel!;
  //
  //   final image = img.Image(width, height);
  //
  //   for (var w = 0; w < width; w++) {
  //     for (var h = 0; h < height; h++) {
  //       final uvIndex =
  //           uvPixelStride * (w / 2).floor() + uvRowStride * (h / 2).floor();
  //       final index = h * width + w;
  //       final yIndex = h * yRowStride + w;
  //
  //       final y = cameraImage.planes[0].bytes[yIndex];
  //       final u = cameraImage.planes[1].bytes[uvIndex];
  //       final v = cameraImage.planes[2].bytes[uvIndex];
  //
  //       image.data[index] = yuv2rgb(y, u, v);
  //     }
  //   }
  //   return image;
  // }
  // img.Image _convertYUV420(CameraImage image) {
  //   var imag = img.Image(image.width, image.height); // Create Image buffer
  //
  //   Plane plane = image.planes[0];
  //   const int shift = (0xFF << 24);
  //
  //   // Fill image buffer with plane[0] from YUV420_888
  //   for (int x = 0; x < image.width; x++) {
  //     for (int planeOffset = 0;
  //     planeOffset < image.height * image.width;
  //     planeOffset += image.width) {
  //       final pixelColor = plane.bytes[planeOffset + x];
  //       // color: 0x FF  FF  FF  FF
  //       //           A   B   G   R
  //       // Calculate pixel color
  //       var newVal = shift | (pixelColor << 16) | (pixelColor << 8) | pixelColor;
  //
  //       imag.data[planeOffset + x] = newVal;
  //     }
  //   }
  //
  //   return imag;
  // }
  // int yuv2rgb(int y, int u, int v) {
  //   // Convert yuv pixel to rgb
  //   var r = (y + v * 1436 / 1024 - 179).round();
  //   var g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
  //   var b = (y + u * 1814 / 1024 - 227).round();
  //
  //   // Clipping RGB values to be inside boundaries [ 0 , 255 ]
  //   r = r.clamp(0, 255);
  //   g = g.clamp(0, 255);
  //   b = b.clamp(0, 255);
  //
  //   return 0xff000000 |
  //       ((b << 16) & 0xff0000) |
  //       ((g << 8) & 0xff00) |
  //       (r & 0xff);
  // }
  //
  // //TODO convert CameraImage to InputImage
  // InputImage getInputImage() {
  //   final WriteBuffer allBytes = WriteBuffer();
  //   for (final Plane plane in frame!.planes) {
  //     allBytes.putUint8List(plane.bytes);
  //   }
  //   final bytes = allBytes.done().buffer.asUint8List();
  //   final Size imageSize = Size(frame!.width.toDouble(), frame!.height.toDouble());
  //   final camera = description;
  //   final imageRotation =
  //       InputImageRotationValue.fromRawValue(camera.sensorOrientation);
  //   // if (imageRotation == null) return;
  //
  //   final inputImageFormat =
  //       InputImageFormatValue.fromRawValue(frame!.format.raw);
  //   // if (inputImageFormat == null) return null;
  //
  //   final planeData = frame!.planes.map(
  //     (Plane plane) {
  //       return InputImagePlaneMetadata(
  //         bytesPerRow: plane.bytesPerRow,
  //         height: plane.height,
  //         width: plane.width,
  //       );
  //     },
  //   ).toList();
  //
  //   final inputImageData = InputImageData(
  //     size: imageSize,
  //     imageRotation: imageRotation!,
  //     inputImageFormat: inputImageFormat!,
  //     planeData: planeData,
  //   );
  //
  //   final inputImage =
  //       InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);
  //
  //   return inputImage;
  // }

  // TODO Show rectangles around detected faces
  // Widget buildResult() {
  //   if (_scanResults == null ||
  //       controller == null ||
  //       !controller.value.isInitialized) {
  //     return const Center(child: Text('Camera is not initialized'));
  //   }
  //   final Size imageSize = Size(
  //     controller.value.previewSize!.height,
  //     controller.value.previewSize!.width,
  //   );
  //   CustomPainter painter = FaceDetectorPainter(imageSize, _scanResults, camDirec);
  //   return CustomPaint(
  //     painter: painter,
  //   );
  // }

  //TODO toggle camera direction
  void _toggleCameraDirection() async {
    if (camDirec == CameraLensDirection.back) {
      camDirec = CameraLensDirection.front;
      description = cameras[1];
    } else {
      camDirec = CameraLensDirection.back;
      description = cameras[0];
    }
    await controller.stopImageStream();
    setState(() {
      controller;
    });

    initializeCamera();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stackChildren = [];
    size = MediaQuery.of(context).size;
    if (controller != null) {

      //TODO View for displaying the live camera footage
      stackChildren.add(
        Positioned(
          top: 0.0,
          left: 0.0,
          width: size.width,
          height: size.height,
          child: Container(
            child: (controller.value.isInitialized)
                ? AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: CameraPreview(controller),
                  )
                : Container(),
          ),
        ),
      );

      // //TODO View for displaying rectangles around detected aces
      // stackChildren.add(
      //   Positioned(
      //       top: 0.0,
      //       left: 0.0,
      //       width: size.width,
      //       height: size.height,
      //       child: buildResult()),
      // );
    }

    //TODO View for displaying the bar to switch camera direction or for registering faces
    stackChildren.add(Positioned(
      top: size.height - 140,
      left: 0,
      width: size.width,
      height: 80,
      child: Card(
        margin: const EdgeInsets.only(left: 20, right: 20),
        color: Colors.blue,
        child: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.cached,
                        color: Colors.white,
                      ),
                      iconSize: 40,
                      color: Colors.black,
                      onPressed: () {
                        _toggleCameraDirection();
                      },
                    ),
                    Container(
                      width: 30,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.face_retouching_natural,
                        color: Colors.white,
                      ),
                      iconSize: 40,
                      color: Colors.black,
                      onPressed: () {},
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ));

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
            margin: const EdgeInsets.only(top: 0),
            color: Colors.black,
            child: Stack(
              children: stackChildren,
            )),
      ),
    );
  }
}

// class FaceDetectorPainter extends CustomPainter {
//   FaceDetectorPainter(this.absoluteImageSize, this.faces, this.camDire2);
//
//   final Size absoluteImageSize;
//   final List<Face> faces;
//   CameraLensDirection camDire2;
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final double scaleX = size.width / absoluteImageSize.width;
//     final double scaleY = size.height / absoluteImageSize.height;
//
//     final Paint paint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.0
//       ..color = Colors.indigoAccent;
//
//     for (Face face in faces) {
//       canvas.drawRect(
//         Rect.fromLTRB(
//           camDire2 == CameraLensDirection.front
//               ? (absoluteImageSize.width - face.boundingBox.right) * scaleX
//               : face.boundingBox.left * scaleX,
//           face.boundingBox.top * scaleY,
//           camDire2 == CameraLensDirection.front
//               ? (absoluteImageSize.width - face.boundingBox.left) * scaleX
//               : face.boundingBox.right * scaleX,
//           face.boundingBox.bottom * scaleY,
//         ),
//         paint,
//       );
//
//       // TextSpan span = TextSpan(
//       //     style: const TextStyle(color: Colors.white, fontSize: 20),
//       //     text: "${face.name}  ${face.distance.toStringAsFixed(2)}");
//       // TextPainter tp = TextPainter(
//       //     text: span,
//       //     textAlign: TextAlign.left,
//       //     textDirection: TextDirection.ltr);
//       // tp.layout();
//       // tp.paint(canvas, Offset(face.location.left*scaleX, face.location.top*scaleY));
//     }
//
//   }
//
//   @override
//   bool shouldRepaint(FaceDetectorPainter oldDelegate) {
//     return true;
//   }
// }
