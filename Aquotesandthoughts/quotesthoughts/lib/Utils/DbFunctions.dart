import 'dart:developer';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

import '../UI/QuoteScreen/QuoteModel.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      p.join(path, 'like.db'),
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE like(quote VARCHAR, category VARCHAR, quoteId VARCHAR PRIMARY KEY, categoryId VARCHAR)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertQuote(QuoteModel quote) async {
    final db = await initializeDB();
    await db.insert(
      'like',
      quote.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

    quotes() async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.query('like');
    List<QuoteModel> quoteList = queryResult.map((e) => QuoteModel.fromMap(e)).toList();
    return quoteList;
  }

  Future<void> deleteQuote(String quoteId) async {
    final db = await initializeDB();
    await db.delete(
      'like',
      where: 'quoteId = ?',
      whereArgs: [quoteId],
    );
  }
}