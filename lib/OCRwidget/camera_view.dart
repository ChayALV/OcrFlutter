import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

enum ScreenMode { liveFeed, gallery }

class CameraView extends StatefulWidget {
  CameraView(
      {Key? key,
      required this.customPaint,
      required this.onImage,
      })
      : super(key: key);

  final CustomPaint? customPaint;
  final Function(InputImage inputImage) onImage;

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  File? _image;
  ImagePicker? _imagePicker;

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
  }
  
  @override
  Widget build(BuildContext context) {
    return _galleryBody();
  }

  Widget _galleryBody() {
    return ListView(shrinkWrap: true, children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Captura tus datos con una foto de tu INE', style: TextStyle(fontSize: 15,fontStyle: FontStyle.italic, color: Colors.white),),
              ),
              Padding(
                padding:const EdgeInsets.only(right: 7,bottom: 7),
                child: IconButton(onPressed: () => _modalButtomSheet(), icon:const Icon(Icons.camera_alt, size: 40, color: Colors.white,)),
              )
            ],
          ),
        ),
      ),
    ]);
  }

  Future _getImage(ImageSource source) async {
    final pickedFile = await _imagePicker?.getImage(source: source);
    if (pickedFile != null) {
      _processPickedFile(pickedFile);
    } else {
      print('No has seleccionado una imagen.');
    }
    setState(() {});
  }

  Future _processPickedFile(PickedFile pickedFile) async {
    setState(() {
      _image = File(pickedFile.path);
    });
    final inputImage = InputImage.fromFilePath(pickedFile.path);
    widget.onImage(inputImage);
  }
  
  _modalButtomSheet() async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 120,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.photo),
                                     title: Text("Tomar una foto de la galeria"),
                  onTap: () {
                    Navigator.pop(context);
                    _getImage(ImageSource.gallery);
                  } 
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt),
                                     title: Text("Tomar una foto con la camara"),
                  onTap: () {
                      Navigator.pop(context);
                    _getImage(ImageSource.camera);
                    } 
                ),
              ],
            ),
          );
        });
  }
}
