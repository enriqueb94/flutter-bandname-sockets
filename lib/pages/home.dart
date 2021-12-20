import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/models/band.dart';
import 'package:flutter_application_1/pages/services/socket_service.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    // Band(id: '1', name: 'Metallica', votes: 5),
    // Band(id: '2', name: 'Bon jovi', votes: 10),
    // Band(id: '1', name: 'AC/DC', votes: 15),
    // Band(id: '1', name: 'Guns and roses', votes: 25)
  ];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('active-bands', _handleActiveBands);

    super.initState();
  }

  _handleActiveBands(dynamic payload) {
    bands = payload.map<Band>((banda) => Band.fromMap(banda)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    setState(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Band Names', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: socketService.serverStatus == ServerStatus.Online
                ? Icon(Icons.check_circle, color: Colors.blue[300])
                : Icon(Icons.offline_bolt, color: Colors.red[300]),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          _showGraph(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (context, i) => bandTile(bands[i]),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: addnewBand, child: const Icon(Icons.add), elevation: 1),
    );
  }

  Widget bandTile(Band band) {
    final socketService = Provider.of<SocketService>(context);
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) => socketService.emit('delete-band', {'id': band.id}),
      background: Container(
        color: Colors.red,
        padding: const EdgeInsets.only(left: 8.0),
        child: const Text('Delete Band', style: TextStyle(color: Colors.white)),
        alignment: Alignment.centerLeft,
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.name),
        trailing: Text('${band.votes}', style: const TextStyle(fontSize: 20)),
        onTap: () => socketService.socket.emit('vote-band', {'id': band.id}),
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
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.emit('add-band', {'name': name});
    }

    Navigator.pop(context);
  }

  Widget _showGraph() {
    Map<String, double> dataMap = new Map();

    bands.forEach((band) =>
        {dataMap.putIfAbsent(band.name, () => band.votes.toDouble())});

    final List<Color> colorList = [
      Colors.blue[50] as Color,
      Colors.blue[200] as Color,
      Colors.pink[50] as Color,
      Colors.pink[200] as Color,
      Colors.yellow[200] as Color,
      Colors.yellow[200] as Color
    ];

    return SizedBox(
      width: double.infinity,
      height: 200,
      child: PieChart(
        dataMap: dataMap,
        animationDuration: const Duration(milliseconds: 800),
        chartLegendSpacing: 32,
        chartRadius: MediaQuery.of(context).size.width / 3.2,
        colorList: colorList,
        initialAngleInDegree: 0,
        chartType: ChartType.ring,
        ringStrokeWidth: 22,
        centerText: "Bands",
        legendOptions: const LegendOptions(
          showLegendsInRow: false,
          legendPosition: LegendPosition.right,
          showLegends: true,
          legendShape: BoxShape.circle,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        chartValuesOptions: const ChartValuesOptions(
          showChartValueBackground: true,
          showChartValues: true,
          showChartValuesInPercentage: false,
          showChartValuesOutside: false,
          decimalPlaces: 1,
        ),
        // gradientList: ---To add gradient colors---
        // emptyColorGradient: ---Empty Color gradient---
      ),
    );
  }
}
