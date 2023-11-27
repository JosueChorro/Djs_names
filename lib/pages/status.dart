import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brand_names/services/socket_service.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('ServerStatus: ${ socketService.serverStatus }'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.send),
        onPressed: (){
          socketService.emit('enviar-mensaje', {'nombre': 'test', 'pass': '123'});
        }
      ),
    );
  }
}
