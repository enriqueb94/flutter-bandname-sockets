import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart' as _io;

enum ServerStatus {
  Online,
  Offline,
  Connecting,
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late _io.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  _io.Socket get socket => _socket;
  Function get emit => _socket.emit;

  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    _socket = _io.io(
        'http://192.168.1.181:3000',
        _io.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .build());

    _socket.onConnect((_) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
      //_socket.emit('mensaje', 'conectado desde app Flutter');
      print('connect');
    });

    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    _socket.on('nuevo-mensaje', (data) => print(data));
  }
}
