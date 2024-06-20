import 'package:semana14/models/student_fields.dart';

class Student {
  int? id;
  final String nombre;
  final String carrera;
  final DateTime fechaIngreso;
  final int edad;

  Student({
    this.id,
    required this.nombre,
    required this.carrera,
    required this.fechaIngreso,
    required this.edad,
  });

  Map<String, Object?> toJson() => {
        StudentFields.id: id,
        StudentFields.nombre: nombre,
        StudentFields.carrera: carrera,
        StudentFields.fechaIngreso: fechaIngreso.toIso8601String(),
        StudentFields.edad: edad,
      };

  factory Student.fromJson(Map<String, Object?> json) => Student(
        id: json[StudentFields.id] as int?,
        nombre: json[StudentFields.nombre] as String,
        carrera: json[StudentFields.carrera] as String,
        fechaIngreso:
            DateTime.parse(json[StudentFields.fechaIngreso] as String),
        edad: json[StudentFields.edad] as int,
      );

  Student copy({
    int? id,
    String? nombre,
    String? carrera,
    DateTime? fechaIngreso,
    int? edad,
  }) =>
      Student(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        carrera: carrera ?? this.carrera,
        fechaIngreso: fechaIngreso ?? this.fechaIngreso,
        edad: edad ?? this.edad,
      );
}
