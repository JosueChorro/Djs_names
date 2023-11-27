import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import '../models/band.dart';
import '../services/socket_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> listBands = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('active-bands', _handlerActiveBands);
    super.initState();
  }


  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dj's names", style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: (socketService.serverStatus == ServerStatus.offline)
                ? Icon(Icons.wifi_off, color: Colors.red[400],)
                : Icon(Icons.wifi, color: Colors.blue[400],),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: listBands.length,
              itemBuilder: (BuildContext context, int index) {
                return _bandTitle(listBands[index]);
              },
            ),
          ),
          _showGraph(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        onPressed: addNewBand,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _bandTitle(Band band){
    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(band.id ?? ""),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) => socketService.emit('delete-band', {'id': band.id}),
      background: Container(
        padding: const EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Text("Delete", style: TextStyle(color: Colors.white),),
              SizedBox(width: 10,),
              Icon(Icons.delete, color: Colors.white, size: 20,)
            ],
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text((band.name ?? "Text Example").substring(0,2)),
          // child: Text((band.id ?? "Text Example")),
        ),
        title: Text((band.name ?? "Text Example")),
        trailing: Text((band.votes.toString() ?? "0"), style: const TextStyle(fontSize: 20),),
        onTap: () => socketService.socket.emit('vote-band', {'id': band.id}),
      ),
    );
  }

  addNewBand() {
    final controller = TextEditingController();

    if(Platform.isAndroid){
      return showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('New dj name'),
            content: TextField(
              controller: controller,
            ),
            actions: [
              MaterialButton(
                  elevation: 5,
                  textColor: Colors.blue,
                  onPressed: () => addBandToList(controller.text),
                  child: const Text("Add")
              )
            ],
          ),
      );
    } else if(Platform.isIOS){
      return showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: const Text('New dj name'),
          content: CupertinoTextField(
            controller: controller,
          ),
          actions: [
            CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () => addBandToList(controller.text),
                child: const Text("Add")
            ),
            CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () => Navigator.pop(context),
                child: const Text("Dismiss")
            )
          ],
        ),
      );
    }
  }

  addBandToList(String name){
    final socketService = Provider.of<SocketService>(context, listen: false);
    if(name.length > 1){
      socketService.emit('add-band', {'name': name});
    }

    Navigator.pop(context);
  }

  _handlerActiveBands(dynamic payload){
    listBands = (payload as List).map((e) => Band.fromMap(e)).toList();
    setState(() {});
  }

  Widget _showGraph() {

    Map<String, double> dataMap = {};

    for (var band in listBands) {
      dataMap.putIfAbsent(band.name ?? 'no-name', () => band.votes?.toDouble() ?? 0.0);
    }
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: PieChart(dataMap: dataMap),
    );
  }
}
