import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:flutterapppersistencia/nosql/add.dart';
import 'package:flutterapppersistencia/nosql/dao/book_dao.dart';
import 'package:flutterapppersistencia/nosql/database/app_database.dart';
import 'package:flutterapppersistencia/nosql/model/book.dart';

class ListBooks extends StatefulWidget {
  @override
  _ListBooksState createState() => _ListBooksState();
}

class _ListBooksState extends State<ListBooks> {

  BookDao bookDAO;
  List<Book> listBooks = List();

  @override
  void initState() {
    super.initState();
    openDatabase();
  }

  openDatabase() async{
    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    bookDAO = database.bookDao;
    bookDAO.findAll().then((value) => listBooks = value);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Livros"),
        actions: <Widget>[
          if (bookDAO != null) IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              Future<Book> future = Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddBook(),
                  ));
              future.then((book){
                if (book != null) {
                  bookDAO.insertBook(book).then((value) {
                    if (value > 0) {
                      setState(() {
                        book.id = value;
                        listBooks.add(book);
                      });
                    }
                  });
                }
              });
            },
          )
        ],
      ),
      body: ListView.separated(
        itemCount: listBooks.length,
        itemBuilder: (context, index) => buildListItem(listBooks[index]),
        separatorBuilder: (context, index) => Divider(
          height: 1,
        ),
      ),
    );
  }

  Widget buildListItem(Book book){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          leading: Text("${book.id}"),
          title: Text(book.name),
          subtitle: Text(book.author),
          onLongPress: (){
            deleteBook(book);
          },
        ),
      ),
    );
  }

  deleteBook(Book book) {
    bookDAO.deleteBook(book).then((value){
      if (value == 1){
        setState(() {
          listBooks.remove(book);
        });
      }
    });
  }
}
