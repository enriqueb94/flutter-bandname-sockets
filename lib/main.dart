import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/home.dart';
import 'package:flutter_application_1/pages/services/socket_service.dart';
import 'package:flutter_application_1/pages/status.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SocketService())],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Material App',
          initialRoute: 'home',
          routes: {'home': (_) => HomePage(), 'status': (_) => StatusPage()}),
    );
  }
}
