import 'package:flutter/material.dart';
import 'package:semana14/models/Student.dart';
import 'student_form_screen.dart';
import '../database/student_database.dart';

class StudentListScreen extends StatefulWidget {
  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  late Future<List<Student>> students;

  @override
  void initState() {
    super.initState();
    refreshStudentList();
  }

  Future<void> refreshStudentList() async {
    setState(() {
      students = StudentDatabase.instance.readAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Estudiantes'),
      ),
      body: FutureBuilder(
        future: students,
        builder: (context, AsyncSnapshot<List<Student>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data![index].nombre),
                subtitle: Text(snapshot.data![index].carrera),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                    builder: (context) =>
                        StudentFormScreen(student: snapshot.data![index]),
                  ))
                      .then((_) {
                    refreshStudentList();
                  });
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
            builder: (context) => StudentFormScreen(student: null),
          ))
              .then((_) {
            refreshStudentList();
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
