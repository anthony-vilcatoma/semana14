class StudentFields {
  static const List<String> values = [
    id,
    nombre,
    carrera,
    fechaIngreso,
    edad,
    createdTime,
  ];

  static const String tableName = 'students';
  static const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const String textType = 'TEXT NOT NULL';
  static const String intType = 'INTEGER NOT NULL';
  static const String dateType = 'TEXT NOT NULL';
  static const String createdTime = 'created_time';

  static const String id = '_id';
  static const String nombre = 'nombre';
  static const String carrera = 'carrera';
  static const String fechaIngreso = 'fechaIngreso';
  static const String edad = 'edad';
}
