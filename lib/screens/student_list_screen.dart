import 'package:flutter/material.dart';
import 'package:semana14/database/student_database.dart';
import 'package:semana14/models/Student.dart';
import 'package:semana14/screens/student_form_screen.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  StudentDatabase studentDatabase = StudentDatabase.instance;

  List<StudentModel> students = [];

  @override
  void initState() {
    refreshStudents();
    super.initState();
  }

  @override
  void dispose() {
    // Close the database when the widget is disposed
    studentDatabase.close();
    super.dispose();
  }

  /// Refreshes the student list from the database
  refreshStudents() {
    studentDatabase.readAll().then((value) {
      setState(() {
        students = value;
      });
    });
  }

  /// Navigates to the StudentFormScreen and refreshes students after navigation
  goToStudentFormScreen({StudentModel? student}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => StudentDetailsView(studentId: student?.id)),
    );
    refreshStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text('Students'),
        actions: [
          IconButton(
            onPressed: () {
              // Implement search functionality
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Center(
        child: students.isEmpty
            ? Text(
                'No Students yet',
                style: TextStyle(color: Colors.white),
              )
            : ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];
                  return GestureDetector(
                    onTap: () => goToStudentFormScreen(student: student),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Nombre: ${student.nombre}',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                'Carrera: ${student.carrera}',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Edad: ${student.edad}',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Fecha de Ingreso: ${student.fechaIngreso.toString().split(' ')[0]}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => goToStudentFormScreen(),
        tooltip: 'Agregar Estudiante',
        child: Icon(Icons.add),
      ),
    );
  }
}
