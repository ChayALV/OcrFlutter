import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:iqinverocr005/routes.dart';
import 'camera_view.dart';

class TextDetectorView extends StatefulWidget {
  @override
  _TextDetectorViewState createState() => _TextDetectorViewState();
}

class _TextDetectorViewState extends State<TextDetectorView> {
  TextDetector textDetector = GoogleMlKit.vision.textDetector();
  Map? textoProcesado;
  bool isBusy = false;
  CustomPaint? customPaint;
  TextEditingController controladorNombre = TextEditingController();
  TextEditingController controladorDireccion = TextEditingController();
  TextEditingController controladorCurp = TextEditingController();
  TextEditingController controladorFechaNaciemiento = TextEditingController();
  TextEditingController controladorSexo = TextEditingController();
  TextEditingController controladorCalve = TextEditingController();

  @override
  void dispose() async {
    super.dispose();
    await textDetector.close();
  }

  Future<void> showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Upss algo fallo'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Lo siento los datos no han sido detectados correctamente'),
                Text('Inteta tomar una foto nuevamente o selecciona una foto de tu INE de tu galeria'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showMyDialogDanger() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Introduce los datos requeridos'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Asegurate de llenar el formulario requerido'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Aceptar'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }

  Map procesadorDeTexto(String text){
    text = text.replaceAll('\n', ' ');
    Map datos = <String,String>{};
    String parametroNombre = 'NOMBRE';
    String parametroDomicilio = 'DOMICILIO';
    String parametroCurp = 'CURP';
    String paramaetroClave = 'CLAVE DE ELECTOR';
    String parametroFechaNac = 'FECHA DE NACIMIENTO';
    String parametroSexo = 'SEXO';
    if(!text.contains(parametroNombre) || !text.contains(parametroDomicilio) || !text.contains(parametroCurp) ||  !text.contains(paramaetroClave) || !text.contains(parametroSexo) || !text.contains(parametroFechaNac)){
      showMyDialog();
    }else{
      var nombre = text.substring(text.indexOf(parametroNombre),text.indexOf(parametroDomicilio)).replaceAll('$parametroNombre ',''); 
      datos[parametroNombre] = nombre;
      var domicilio = text.substring(text.indexOf(parametroDomicilio),text.indexOf('.')).replaceAll('$parametroDomicilio ', '');
      datos[parametroDomicilio] = domicilio;
      var curp = text.substring(text.indexOf(parametroCurp), text.indexOf(parametroCurp)+23).replaceAll('$parametroCurp ','');
      datos[parametroCurp] = curp;
        var clave = text.substring(text.indexOf(paramaetroClave), text.indexOf(paramaetroClave)+35).replaceAll('$paramaetroClave ', '');
      datos[paramaetroClave] = clave;
      var fechaNac = text.substring(text.indexOf(parametroFechaNac),text.indexOf(parametroFechaNac)+30).replaceAll('$parametroFechaNac ', '');
      datos[parametroFechaNac] = fechaNac;
      var sexo = text.substring(text.indexOf(parametroSexo),text.indexOf(parametroSexo)+6).replaceAll('$parametroSexo ', '');
      datos[parametroSexo] = sexo;
    }
    return datos;
  }
  
  Future<void> processImage(InputImage inputImage) async {
      final recognisedText = await textDetector.processImage(inputImage);
      textoProcesado = procesadorDeTexto(recognisedText.text);
      setState(() {
        controladorNombre = TextEditingController.fromValue(TextEditingValue(text: textoProcesado!['NOMBRE']));
        controladorDireccion = TextEditingController.fromValue(TextEditingValue(text: textoProcesado!['DOMICILIO']));
        controladorCurp = TextEditingController.fromValue(TextEditingValue(text: textoProcesado!['CURP']));
        controladorCalve = TextEditingController.fromValue(TextEditingValue(text: textoProcesado!['CLAVE DE ELECTOR']));
        controladorSexo = TextEditingController.fromValue(TextEditingValue(text: textoProcesado!['SEXO']));
        controladorFechaNaciemiento = TextEditingController.fromValue(TextEditingValue(text: textoProcesado!['FECHA DE NACIMIENTO']));
      });
    }
  
  Map datosDeFormulario(){
    Map <String,String> datosFormulario = {};
    if (controladorSexo.text.isEmpty || controladorNombre.text.isEmpty || controladorDireccion.text.isEmpty || controladorCalve.text.isEmpty || controladorFechaNaciemiento.text.isEmpty || controladorCurp.text.isEmpty) {
      return datosFormulario ={};
    } else {
      datosFormulario['NOMBRE'] = controladorNombre.text;
      datosFormulario['DOMICILIO'] = controladorDireccion.text;
      datosFormulario['CURP'] = controladorCurp.text;
      datosFormulario['CLAVE'] = controladorCalve.text;
      datosFormulario['FECHA DE NACIMIENTO'] = controladorFechaNaciemiento.text;
      datosFormulario['SEXO'] = controladorSexo.text;
      return datosFormulario;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
        CameraView(
        customPaint: customPaint,
        onImage: (inputImage) {
          processImage(inputImage);
        },
      ),
      const Center(child: Text('Introduce tu informacion',style: TextStyle(fontStyle: FontStyle.italic,fontSize: 30),)),
      Padding(
        padding:const EdgeInsets.only(top: 0,left: 10,right: 10, bottom: 10),
        child:Column(
          children: [
            Input(controladorSexo: controladorNombre, icono: const Icon(Icons.person, color: Colors.blue,), label: 'Nombre completo', radio: 50),
            Input(controladorSexo: controladorDireccion, icono: const Icon(Icons.location_city, color: Colors.blue,), label: 'Domicilio', radio: 50),
            Input(controladorSexo: controladorCurp, icono: const Icon(Icons.person_search_sharp, color: Colors.blue,), label: 'Curp', radio: 50),
            Input(controladorSexo: controladorCalve, icono: const Icon(Icons.person_search_sharp, color: Colors.blue,), label: 'Clave de elector', radio: 50),
            Input(controladorSexo: controladorFechaNaciemiento, icono: const Icon(Icons.date_range, color: Colors.blue,), label: 'Fecha de nacimiento eje. 01/01/1999', radio: 50),
            Input(controladorSexo: controladorSexo, icono: const Icon(Icons.emoji_emotions_outlined, color: Colors.blue,), label: 'Sexo', radio: 50,),
          ],
        )
      ),
      InkWell(
        onTap: (){
          if (datosDeFormulario().isEmpty) {
            showMyDialogDanger();
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (context) => DatosConfirmados(datosDeFormulario(),datosVerificados: datosDeFormulario(),)));
          }
        },
        child:const BotonContinuar(),
      )
    ],
  );
  }
}

class BotonContinuar extends StatelessWidget {
  const BotonContinuar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.only(top: 20,left: 30,right: 30, bottom: 10),
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(30)
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children:const [
                  Text('Continuar',style: TextStyle(color: Colors.white, fontSize: 20, fontStyle: FontStyle.italic),),
                  Icon(Icons.arrow_forward_outlined, color: Colors.white,size: 30,),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Input extends StatelessWidget {
  const Input({
    Key? key,
    required this.controladorSexo, required this.icono, required this.label,  required this.radio,
  }) : super(key: key);

  final TextEditingController controladorSexo;
  final Icon icono;
  final String label;
  final double radio;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: TextField(
        decoration: InputDecoration(prefixIcon: icono,labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(radio))),
        controller: controladorSexo,
      ),
    );
  }
}
