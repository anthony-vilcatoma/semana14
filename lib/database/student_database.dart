import 'package:semana14/models/Student.dart';
import 'package:semana14/models/student_fields.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common/sqlite_api.dart'; // If using sqflite_common_ffi or sqflite

class StudentDatabase {
  static final StudentDatabase instance = StudentDatabase._internal();

  static Database? _database;

  StudentDatabase._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'student.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, _) async {
    // Define the SQL statement without trailing commas
    String sqlStatement = '''
    CREATE TABLE ${StudentFields.tableName} (
      ${StudentFields.id} ${StudentFields.idType},
      ${StudentFields.nombre} ${StudentFields.textType},
      ${StudentFields.carrera} ${StudentFields.textType},
      ${StudentFields.fechaIngreso} ${StudentFields.dateType},
      ${StudentFields.edad} ${StudentFields.intType},
      ${StudentFields.createdTime} ${StudentFields.dateType}
    )
  ''';

    // Execute the SQL statement
    await db.execute(sqlStatement);
  }

  Future<StudentModel> create(StudentModel student) async {
    final db = await instance.database;
    final id = await db.insert(StudentFields.tableName, student.toJson());
    return student.copy(id: id);
  }

  Future<StudentModel> read(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      StudentFields.tableName,
      columns: StudentFields.values,
      where: '${StudentFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return StudentModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<StudentModel>> readAll() async {
    final db = await instance.database;
    const orderBy = '${StudentFields.createdTime} DESC';
    final result = await db.query(StudentFields.tableName, orderBy: orderBy);
    return result.map((json) => StudentModel.fromJson(json)).toList();
  }

  Future<int> update(StudentModel note) async {
    final db = await instance.database;
    return db.update(
      StudentFields.tableName,
      note.toJson(),
      where: '${StudentFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      StudentFields.tableName,
      where: '${StudentFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
