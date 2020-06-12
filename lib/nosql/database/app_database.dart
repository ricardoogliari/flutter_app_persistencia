import 'dart:async';

import 'package:floor/floor.dart';
import 'package:flutterapppersistencia/nosql/dao/book_dao.dart';
import 'package:flutterapppersistencia/nosql/model/book.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path/path.dart';

part 'app_database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Book])
abstract class AppDatabase extends FloorDatabase {
  BookDao get bookDao;
}