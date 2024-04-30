import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:medipal/forms/file_display.dart';
import 'package:medipal/objects/patient.dart'; // Import Firebase Storage
import 'package:path_provider/path_provider.dart';

class FilesListPage extends StatefulWidget {
  final String patientId;

  FilesListPage({required this.patientId});

  @override
  _FilesListPageState createState() => _FilesListPageState();
}

class _FilesListPageState extends State<FilesListPage> {
  List<FileData> files = [];

  @override
  void initState() {
    super.initState();
    fetchFilesForPatient();
  }

  Future<void> fetchFilesForPatient() async {
    Reference patientRef =
        FirebaseStorage.instance.ref().child('patients/${widget.patientId}');
    try {
      ListResult result = await patientRef.listAll();
      for (Reference ref in result.items) {
        String fileName = ref.name;
        String downloadUrl = await ref.getDownloadURL();
        FileData fileData = FileData(
          name: fileName,
          url: downloadUrl,
        );
        setState(() {
          files.add(fileData);
        });
      }
    } catch (e) {
      print('Error fetching files: $e');
    }
  }

  Future<void> openFile(File file) async {
    print('Opening file: ${file.path}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Files List'),
      ),
      body: ListView.builder(
        itemCount: files.length,
        itemBuilder: (context, index) {
          FileData file = files[index];
          return ListTile(
            //leading: Icon(Icons.file),
            title: Text(file.name ?? 'File ${index + 1}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ImageDisplayPage(imageUrl: file.url ?? ''),
                ),
              );
            },
          );
        },
      ),
    );
  }
}