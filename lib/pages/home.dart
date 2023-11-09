import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/band.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> listBands = [
    Band(id: '1', name: 'Hardwell', votes: 3),
    Band(id: '2', name: 'Martin Garrix', votes: 3),
    Band(id: '3', name: 'Timmy Trumpet', votes: 3),
    Band(id: '4', name: 'Steve Aoki', votes: 3),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dj's names", style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: listBands.length,
        itemBuilder: (BuildContext context, int index) {
          return _bandTitle(listBands[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        onPressed: addNewBand,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _bandTitle(Band band){
    return Dismissible(
      key: Key(band.id ?? ""),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction){

      },
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
          // child: Text((band.name ?? "Text Example").substring(0,2)),
          child: Text((band.id ?? "Text Example")),
        ),
        title: Text((band.name ?? "Text Example")),
        trailing: Text((band.votes.toString() ?? "0"), style: const TextStyle(fontSize: 20),),
      ),
    );
  }

  addNewBand() {
    final controller = TextEditingController();

    if(Platform.isAndroid){
      return showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
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
            );
          }
      );
    } else if(Platform.isIOS){
      return showCupertinoDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
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
          );
        }
      );
    }
  }

  addBandToList(String name){
    if(name.length > 1){
      listBands.add(Band(
        id: (listBands.length + 1).toString(),
        name: name,
        votes: 0
      ));

      setState(() {});
    }

    Navigator.pop(context);
  }
}
