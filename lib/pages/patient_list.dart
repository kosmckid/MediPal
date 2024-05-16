import 'package:flutter/material.dart';
import 'package:medipal/pages/patient_data.dart';
import 'package:medipal/pages/patient_form.dart';
import 'package:medipal/objects/patient.dart';

class PatientList extends StatefulWidget {
  const PatientList({super.key});

  @override
  PatientListState createState() => PatientListState();
}

class PatientListState extends State<PatientList> {
  late List<Patient> _patients = [];
  bool _isDeleteMode = false;
  bool _isEditMode = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchPatients();
  }

  void _fetchPatients() async {
    List<Patient>? patients = await Patient.getAllPatients();
    patients!.sort((a, b) {
      return a.firstName!.toLowerCase().compareTo(b.firstName!.toLowerCase());
    });
    setState(() {
      _patients = patients;
    });
  }

  List<Patient> _filterPatients(List<Patient> patients) {
    if (_searchQuery.isEmpty) {
      return patients;
    } else {
      return patients
          .where((patient) =>
              patient.firstName!.toLowerCase().contains(_searchQuery) ||
              patient.middleName!.toLowerCase().contains(_searchQuery) ||
              patient.lastName!.toLowerCase().contains(_searchQuery))
          .toList();
    }
  }

  Widget _buildPatientInfo(Patient patient) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 0.5,
          ),
        ),
      ),
      child: ListTile(
        leading: const Icon(Icons.person),
        trailing: _isDeleteMode
            ? IconButton(
                onPressed: () async {
                  await Patient.deletePatient(patient.id!);
                  setState(() {
                    _patients.remove(patient);
                  });
                },
                icon: const Icon(Icons.delete),
              )
            : _isEditMode
                ? const Icon(Icons.edit)
                : null,
        title: Text(
            '${patient.firstName} ${patient.middleName} ${patient.lastName}'),
        subtitle: Text(
            'DOB: ${patient.dob!.year}/${patient.dob!.month}/${patient.dob!.day}'),
        onTap: () => Navigator.push(
          context,
          _isEditMode
              ? MaterialPageRoute(
                  builder: (context) => PatientForm(
                    patient: patient,
                  ),
                )
              : MaterialPageRoute(
                  builder: (context) => DisplayPatient(
                    patientId: patient.id!,
                  ),
                ),
        ),
        tileColor: const Color(0xFFDADFEC),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'All Patients List',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.5),
                offset: const Offset(0, 3),
                blurRadius: 5,
              ),
            ],
          ),
        ),
        flexibleSpace: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color.fromARGB(255, 73, 118, 207),
                Color.fromARGB(255, 191, 200, 255),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isDeleteMode = !_isDeleteMode;
              });
            },
            icon: Icon(_isDeleteMode ? Icons.cancel : Icons.delete),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _isEditMode = !_isEditMode;
              });
            },
            icon: Icon(_isEditMode ? Icons.cancel : Icons.edit),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(15, 20, 10, 0),
                      hintText: 'Search by name...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(143, 255, 255, 255),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              )),
        ),
      ),
      body: _patients.isNotEmpty
          ? ListView.builder(
              itemCount: _filterPatients(_patients).length,
              itemBuilder: (context, index) {
                return _buildPatientInfo(_filterPatients(_patients)[index]);
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
