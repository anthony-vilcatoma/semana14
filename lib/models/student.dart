import 'package:semana14/models/student_fields.dart';

class StudentModel {
  int? id;
  final String nombre;
  final String carrera;
  final DateTime fechaIngreso;
  final int edad;
  final DateTime? createdTime;

  StudentModel({
    this.id,
    required this.nombre,
    required this.carrera,
    required this.fechaIngreso,
    required this.edad,
    this.createdTime,
  });

  Map<String, Object?> toJson() => {
        StudentFields.id: id,
        StudentFields.nombre: nombre,
        StudentFields.carrera: carrera,
        StudentFields.fechaIngreso: fechaIngreso.toIso8601String(),
        StudentFields.edad: edad,
        StudentFields.createdTime: createdTime?.toIso8601String(),
      };

  factory StudentModel.fromJson(Map<String, Object?> json) => StudentModel(
        id: json[StudentFields.id] as int?,
        nombre: json[StudentFields.nombre] as String,
        carrera: json[StudentFields.carrera] as String,
        fechaIngreso:
            DateTime.parse(json[StudentFields.fechaIngreso] as String),
        edad: json[StudentFields.edad] as int,
        createdTime:
            DateTime.tryParse(json[StudentFields.createdTime] as String? ?? ''),
      );

  StudentModel copy({
    int? id,
    String? nombre,
    String? carrera,
    DateTime? fechaIngreso,
    int? edad,
    DateTime? createdTime,
  }) =>
      StudentModel(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        carrera: carrera ?? this.carrera,
        fechaIngreso: fechaIngreso ?? this.fechaIngreso,
        edad: edad ?? this.edad,
        createdTime: createdTime ?? this.createdTime,
      );
}
