import 'package:flutter/material.dart';

class DatosConfirmados extends StatelessWidget {
  const DatosConfirmados(Map datos, {Key? key, this.datosVerificados}) : super(key: key);
  final Map? datosVerificados;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Confirma tus datos'),),
      body: Center(child: Text('Segunda pantalla y estos son los datos $datosVerificados'),),
    );
  }
}