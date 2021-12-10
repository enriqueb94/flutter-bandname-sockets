import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/models/band.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 5),
    Band(id: '2', name: 'Bon jovi', votes: 10),
    Band(id: '1', name: 'AC/DC', votes: 15),
    Band(id: '1', name: 'Guns and roses', votes: 25)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Band Names', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, i) => bandTile(bands[i]),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: addnewBand, child: const Icon(Icons.add), elevation: 1),
    );
  }

  Widget bandTile(Band band) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) => print('borraste una banda'),
      background: Container(
        color: Colors.red,
        padding: const EdgeInsets.only(left: 8.0),
        child:
            const Text('Deleted Band', style: TextStyle(color: Colors.white)),
        alignment: Alignment.centerLeft,
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.name),
        trailing: Text('${band.votes}', style: const TextStyle(fontSize: 20)),
        onTap: () {
          //
        },
      ),
    );
  }

  addnewBand() {
    final textController = TextEditingController();
    if (Platform.isAndroid) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('New Band Name'),
                content: TextField(
                  controller: textController,
                ),
                actions: <Widget>[
                  MaterialButton(
                      child: const Text('Add'),
                      textColor: Colors.blue,
                      elevation: 5,
                      onPressed: () => addBandToList(textController.text))
                ],
              ));
    }

    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (_) {
            return CupertinoAlertDialog(
                title: const Text('New Band Name'),
                content: CupertinoTextField(controller: textController),
                actions: <Widget>[
                  CupertinoDialogAction(
                      child: const Text('Add'),
                      isDefaultAction: true,
                      onPressed: () => addBandToList(textController.text)),
                  CupertinoDialogAction(
                      child: const Text('Add'),
                      isDestructiveAction: true,
                      onPressed: () => addBandToList(textController.text))
                ]);
          });
    }
  }

  void addBandToList(String name) {
    if (name.length > 1) {
      bands.add(Band(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
    }

    Navigator.pop(context);
  }
}
