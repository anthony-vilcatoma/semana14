import 'package:flutter/material.dart';
import 'package:semana14/models/Student.dart';
import '../database/student_database.dart';

class StudentFormScreen extends StatefulWidget {
  final Student? student;

  StudentFormScreen({Key? key, this.student}) : super(key: key);

  @override
  _StudentFormScreenState createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  late TextEditingController _nombreController;
  late TextEditingController _carreraController;
  late TextEditingController _fechaIngresoController;
  late TextEditingController _edadController;

  @override
  void initState() {
    super.initState();

    _nombreController =
        TextEditingController(text: widget.student?.nombre ?? '');
    _carreraController =
        TextEditingController(text: widget.student?.carrera ?? '');
    _fechaIngresoController = TextEditingController(
        text: widget.student?.fechaIngreso.toIso8601String() ?? '');
    _edadController =
        TextEditingController(text: widget.student?.edad.toString() ?? '');
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _carreraController.dispose();
    _fechaIngresoController.dispose();
    _edadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student == null
            ? 'Agregar Estudiante'
            : 'Editar Estudiante'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _carreraController,
              decoration: InputDecoration(labelText: 'Carrera'),
            ),
            TextField(
              controller: _fechaIngresoController,
              decoration:
                  InputDecoration(labelText: 'Fecha de Ingreso (yyyy-mm-dd)'),
            ),
            TextField(
              controller: _edadController,
              decoration: InputDecoration(labelText: 'Edad'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final newStudent = Student(
                  nombre: _nombreController.text,
                  carrera: _carreraController.text,
                  fechaIngreso: DateTime.parse(_fechaIngresoController.text),
                  edad: int.parse(_edadController.text),
                );

                if (widget.student == null) {
                  await StudentDatabase.instance.create(newStudent);
                } else {
                  final updatedStudent =
                      newStudent.copy(id: widget.student!.id);
                  await StudentDatabase.instance.update(updatedStudent);
                }

                Navigator.of(context).pop();
              },
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
