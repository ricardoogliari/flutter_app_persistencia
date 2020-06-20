import 'package:flutter/material.dart';
import 'package:flutterapppersistencia/sqlite/add.dart';
import 'package:flutterapppersistencia/sqlite/model/person.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ListPersons extends StatefulWidget {
  @override
  _ListPersonsState createState() => _ListPersonsState();
}

class _ListPersonsState extends State<ListPersons> {

  Database _database;
  List<Person> personsList = List<Person>();

  @override
  void initState() {
    super.initState();
    getDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pessoas"),
        actions: <Widget>[
          if (_database != null) IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              Future<Person> future = Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPerson(),
              ));
              future.then((person) {
                if (person != null) insertPerson(person);
              });
            },
          )
        ],
      ),
      body: ListView.separated(
        itemCount: personsList.length,
        itemBuilder: (context, index) => buildListItem(index),
        separatorBuilder: (context, index) => Divider(
          height: 1,
        ),
      ),
    );
  }

  Widget buildListItem(int index){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          leading: Text("${personsList[index].id}"),
          title: Text(personsList[index].firstName),
          subtitle: Text(personsList[index].lastName),
          onLongPress: (){
            deletePerson(index);
          },
        ),
      ),
    );
  }

  getDatabase() async {
    openDatabase(
        join(await getDatabasesPath(), 'person_database.db'),
        onCreate: (db, version)
        {
          return db.execute(
            "CREATE TABLE person(id INTEGER PRIMARY KEY, firstName TEXT, lastName TEXT)",
          );
        },
        version: 1
    ).then((db) {
      setState(() {
        _database = db;
      });

      readAll();
    });
  }

  readAll() async {
    final List<Map<String, dynamic>> maps = await _database.query('person');

    personsList = List.generate(maps.length, (i) {
      return Person(
        id: maps[i]['id'],
        firstName: maps[i]['firstName'],
        lastName: maps[i]['lastName'],
      );
    });

    setState(() {});
  }

  insertPerson(Person person) async {
    await _database.insert(
      'person',
      person.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    ).then((value) {
      person.id = value;
      setState(() {
        personsList.add(person);
      });
    });
  }

  deletePerson(int index) async {
    await _database.delete(
      'person',
      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [personsList[index].id],
    ).then((value) {
      setState(() {
        personsList.removeAt(index);
      });
    });
  }
}
