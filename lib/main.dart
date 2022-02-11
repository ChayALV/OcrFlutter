import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'OCRwidget/text_detector_view.dart';


List<CameraDescription> cameras = [];
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        //appBar: AppBar(title: Text('OCR'),),
        body: TextDetectorView(),
      ),
    );
  }
}