import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterapppersistencia/firebase/add.dart';
import 'package:flutterapppersistencia/firebase/model/car.dart';

class ListCars extends StatefulWidget {
  @override
  _ListCarsState createState() => _ListCarsState();
}

class _ListCarsState extends State<ListCars> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carros"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              Future<Car> future = Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddCar(),
                  ));
              future.then((car) {
                if (car != null) insertCar(car);
              });
            },
          )
        ],
      ),
      body: _buildBody(context),
    );
  }
  
  insertCar(Car car){
    Firestore.instance.collection('car').add(car.toJson());
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('car').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Car.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.name),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(record.name),
          trailing: Text(record.brand),
          onLongPress: (){
            data.reference.delete();
          },
        ),
      ),
    );
  }
}