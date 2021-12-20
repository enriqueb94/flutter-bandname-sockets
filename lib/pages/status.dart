import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/services/socket_service.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Text('ServerStatus: ${socketService.serverStatus}')],
      )),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.message),
        onPressed: () {
          socketService.emit('nuevo-mensaje',
              {'nombre': 'Flutter', 'mensaje': 'hola desde flutter'});
        },
      ),
    );
  }
}
