import 'package:semana14/models/Student.dart';
import 'package:semana14/models/student_fields.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class StudentDatabase {
  static final StudentDatabase instance = StudentDatabase._internal();
  static Database? _database;
  StudentDatabase._internal();

  Future<Database> get database async {
    if (database != null) {
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
    return await db.execute('''
        CREATE TABLE ${StudentFields.tableName} (
          ${StudentFields.id} ${StudentFields.idType},
          ${StudentFields.nombre} ${StudentFields.textType},
          ${StudentFields.carrera} ${StudentFields.textType},
          ${StudentFields.fechaIngreso} ${StudentFields.dateType},
          ${StudentFields.edad} ${StudentFields.intType},
        )
      ''');
  }

  Future<Student> create(Student student) async {
    final db = await instance.database;
    final id = await db.insert(StudentFields.tableName, student.toJson());
    return student.copy(id: id);
  }

  Future<Student> read(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      StudentFields.tableName,
      columns: StudentFields.values,
      where: '${StudentFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Student.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Student>> readAll() async {
    final db = await instance.database;
    final result = await db.query(StudentFields.tableName);
    return result.map((json) => Student.fromJson(json)).toList();
  }

  Future<int> update(Student student) async {
    final db = await instance.database;
    return db.update(
      StudentFields.tableName,
      student.toJson(),
      where: '${StudentFields.id} = ?',
      whereArgs: [student.id],
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
