import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


enum ServerStatus {
  online,
  offline,
  connecting
}

class SocketService with ChangeNotifier{
  ServerStatus _serverStatus = ServerStatus.connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;
  Function get emit => _socket.emit;

  SocketService(){
    _initConfig();
  }

  void _initConfig(){
    // Dart client
    // IO.Socket socket = IO.io('http://192.168.31.195:3000', IO.OptionBuilder().setTransports(['websocket']).disableAutoConnect() );
    _socket = IO.io('http://192.168.31.195:3000', {'transports': ['websocket'], 'autoConnect': true});
    _socket.onConnect((_) {
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });

    // socket.on('nuevo-mensaje', (payload) {
    //   print('Nuevo-mensaje: $payload');
    //   // payload.containsKey('mensaje2') ? payload['mensaje2'] : 'No hay'
    // });

    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });
  }
}