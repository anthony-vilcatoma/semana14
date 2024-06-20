import 'package:flutter/material.dart';
import 'package:semana14/database/student_database.dart';
import 'package:semana14/models/Student.dart';

class StudentDetailsView extends StatefulWidget {
  const StudentDetailsView({Key? key, this.studentId}) : super(key: key);

  final int? studentId;

  @override
  State<StudentDetailsView> createState() => _StudentDetailsViewState();
}

class _StudentDetailsViewState extends State<StudentDetailsView> {
  StudentDatabase studentDatabase = StudentDatabase.instance;

  TextEditingController nombreController = TextEditingController();
  TextEditingController carreraController = TextEditingController();
  TextEditingController fechaIngresoController = TextEditingController();
  TextEditingController edadController = TextEditingController();

  late StudentModel student;
  bool isLoading = false;
  bool isNewStudent = false;

  @override
  void initState() {
    refreshStudent();
    super.initState();
  }

  /// Gets the student from the database and updates the state.
  /// If studentId is null, sets isNewStudent to true.
  refreshStudent() {
    if (widget.studentId == null) {
      setState(() {
        isNewStudent = true;
      });
      return;
    }
    studentDatabase.read(widget.studentId!).then((value) {
      setState(() {
        student = value;
        nombreController.text = student.nombre;
        carreraController.text = student.carrera;
        fechaIngresoController.text = student.fechaIngreso.toString();
        edadController.text = student.edad.toString();
      });
    });
  }

  /// Creates a new student if isNewStudent is true, else updates the existing student.
  createOrUpdateStudent() {
    setState(() {
      isLoading = true;
    });
    final model = StudentModel(
      nombre: nombreController.text,
      carrera: carreraController.text,
      fechaIngreso: DateTime.parse(fechaIngresoController.text),
      edad: int.parse(edadController.text),
      createdTime: DateTime.now(),
    );
    if (isNewStudent) {
      studentDatabase.create(model).then((createdStudent) {
        setState(() {
          student = createdStudent;
          isNewStudent = false; // Now editing existing student
        });
      });
    } else {
      model.id = student.id;
      studentDatabase.update(model).then((_) {
        setState(() {
          student = model;
        });
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  /// Deletes the student from the database and navigates back to the previous screen.
  deleteStudent() {
    studentDatabase.delete(student.id!);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        actions: [
          Visibility(
            visible: !isNewStudent,
            child: IconButton(
              onPressed: deleteStudent,
              icon: const Icon(Icons.delete),
            ),
          ),
          IconButton(
            onPressed: createOrUpdateStudent,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nombreController,
                      cursorColor: Colors.white,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Nombre',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextField(
                      controller: carreraController,
                      cursorColor: Colors.white,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Carrera',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    TextField(
                      controller: fechaIngresoController,
                      cursorColor: Colors.white,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Fecha de Ingreso (YYYY-MM-DD)',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    TextField(
                      controller: edadController,
                      cursorColor: Colors.white,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Edad',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
