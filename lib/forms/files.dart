import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medipal/templates/input_template.dart';
import 'package:medipal/objects/patient.dart';

class FileForm extends StatefulWidget {
  final Patient patient;
  final GlobalKey<FormState> formKey;
  final bool edit;

  const FileForm({
    super.key,
    required this.patient,
    required this.formKey,
    required this.edit,
  });

  @override
  FileFormState createState() => FileFormState();
}

class FileFormState extends State<FileForm> {
  // variables
  List<FileData>? _files = [];

  @override
  void initState() {
    super.initState();
    _fetchAllFiles();
  }

  void _fetchAllFiles() async {
    _files = await widget.patient.getAllFiles();
    setState(() {});
  }

  Future<void> _selectFile(FileData f) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        f.file = File(image.path);
      });
    }
  }

  void _deleteFile(FileData file) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('patients/${widget.patient.id}/${file.name}');
    await storageRef.delete().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('File deleted successfully'),
        ),
      );
      setState(() {
        _files!.remove(file);
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting file: $error'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _files!.length,
              itemBuilder: (context, index) {
                FileData file = _files![index];
                return ListTile(
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
                  trailing: widget.edit
                      ? IconButton(
                          icon: widget.edit
                              ? const Icon(Icons.delete)
                              : Container(),
                          onPressed: () => _deleteFile(file),
                        )
                      : null,
                );
              },
            ),
          ),
          if (widget.edit)
            Form(
              key: widget.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Add Files'),
                  ...List.generate(
                    widget.patient.files.length,
                    (index) {
                      FileData file = widget.patient.files[index];
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: buildTextFormField(
                                  labelText: 'File name ${index + 1}',
                                  value: file.name,
                                  onChanged: (value) {
                                    file.name = value!;
                                  },
                                  onSuffixIconTap: () => setState(() =>
                                      widget.patient.files.removeAt(index)),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF003CD6),
                                ),
                                onPressed: () => _selectFile(file),
                                child: const Text('Select Image',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (file.file != null)
                            Text('File Path: ${file.file!.path}')
                        ],
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          widget.patient.files.add(FileData());
                        });
                      },
                      child: const Text("Add More"),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class ImageDisplayPage extends StatelessWidget {
  final String imageUrl;

  const ImageDisplayPage({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Display'),
      ),
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Stack(
          children: [
            InteractiveViewer(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Center(
              child: FutureBuilder(
                future: precacheImage(NetworkImage(imageUrl), context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
