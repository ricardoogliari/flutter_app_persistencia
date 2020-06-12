import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutterapppersistencia/nosql/list.dart';
import 'package:flutterapppersistencia/sqlite/list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => Home(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/sqlite': (context) => ListPersons(),
        '/nosql': (context) => ListBooks(),
      },
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text("Flutter - Persistência"),
    ),
    body: ListView(
      children: <Widget>[
        ListTile(
          title: Text("SQLite"),
          subtitle: Text("Lista de Pessoas"),
          leading: SvgPicture.asset(
            "images/sqlite-icon.svg",
            width: 48,
            height: 48,
          ),
          trailing: Icon(Icons.navigate_next),
          onTap: (){
            Navigator.pushNamed(context, "/sqlite");
          },
        ),
        Divider(
          height: 1,
          color: Colors.black54,
        ),
        ListTile(
          title: Text("Floor"),
          subtitle: Text("Lista de Livros"),
          leading: SvgPicture.asset(
            "images/db.svg",
            width: 48,
            height: 48,
          ),
          trailing: Icon(Icons.navigate_next),
          onTap: (){
            Navigator.pushNamed(context, "/nosql");
          },
        ),
      ],
    ),
  );
}
