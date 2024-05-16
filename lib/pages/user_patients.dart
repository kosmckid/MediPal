import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medipal/objects/patient.dart';
import 'package:medipal/objects/practitioner.dart';
import 'package:medipal/pages/patient_data.dart';
import 'package:medipal/pages/patient_list.dart';

class PractitionerPatients extends StatefulWidget {
  final String? userUid;

  const PractitionerPatients({
    super.key,
    required this.userUid,
  });

  @override
  PractitionerPatientsState createState() {
    return PractitionerPatientsState();
  }
}

class PractitionerPatientsState extends State<PractitionerPatients> {
  late Practitioner _practitioner;
  late List<Patient> _allPatients = [];
  late final List<Patient> _myPatients = [];
  bool _isDeleteMode = false;
  bool _isAddMode = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchPractitioner();
    _fetchPatients();
  }

  void _fetchPractitioner() async {
    Practitioner? practitioner =
        await Practitioner.getPractitioner(widget.userUid!);
    if (practitioner != null) {
      setState(() {
        _practitioner = practitioner;
      });
    }
  }

  void _fetchPatients() async {
    List<Patient>? patients = await Patient.getAllPatients();
    setState(() {
      _allPatients = patients!;
    });
    _separateMyPatients();
    _sortLists();
  }

  void _separateMyPatients() {
    List<Patient> patientsCopy = List.of(_allPatients);
    for (String s in _practitioner.patients) {
      for (Patient p in patientsCopy) {
        if (p.id == s) {
          setState(() {
            _myPatients.add(p);
            _allPatients.remove(p);
          });
        }
      }
    }
  }

  void _sortLists() {
    _allPatients.sort((a, b) {
      return a.firstName!.toLowerCase().compareTo(b.firstName!.toLowerCase());
    });
    _myPatients.sort((a, b) {
      return a.firstName!.toLowerCase().compareTo(b.firstName!.toLowerCase());
    });
    setState(() {});
  }

  void _addToPatients(Patient patient) {
    setState(() {
      _practitioner.patients.add(patient.id!);
      _myPatients.add(patient);
      _allPatients.remove(patient);
    });
    _sortLists();
  }

  void _removeFromPatients(Patient patient) {
    setState(() {
      _practitioner.patients.remove(patient.id);
      _myPatients.remove(patient);
      _allPatients.add(patient);
    });
    _sortLists();
  }

  Future<void> _updatePatients() async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref('users/${widget.userUid!}');
    ref.update(_practitioner.toJson()).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Patient list updated'),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating patient list: $error'),
        ),
      );
    });
  }

  Widget _buildPatientInfo(Patient patient, bool isPatient) {
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
        title: Text(
            '${patient.firstName} ${patient.middleName} ${patient.lastName}'),
        subtitle: Text('DOB: ${patient.dob!.year}/${patient.dob!.month}/${patient.dob!.day}'),
        trailing: ElevatedButton(
          onPressed: (_isDeleteMode || _isAddMode)
              ? () {
                  if (isPatient) {
                    _removeFromPatients(patient);
                  } else {
                    _addToPatients(patient);
                  }
                }
              : null,
          child: Icon(isPatient ? Icons.delete : Icons.add),
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DisplayPatient(
              patientId: patient.id!,
            ),
          ),
        ),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          _isAddMode ? 'Remaining Patients' : 'My Patient List',
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
          // delete toggle button
          if (!_isAddMode)
            IconButton(
              onPressed: () {
                setState(() {
                  _isDeleteMode = !_isDeleteMode;
                });
              },
              icon: Icon(_isDeleteMode ? Icons.cancel : Icons.delete),
            ),
          // add toggle button
          IconButton(
            onPressed: () {
              setState(() {
                _isAddMode = !_isAddMode;
              });
            },
            icon: Icon(_isAddMode ? Icons.cancel : Icons.add),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size(50, 57),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Column(
                      children: [
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value.toLowerCase();
                            });
                          },
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.fromLTRB(15, 20, 10, 0),
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
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.transparent,
                  ),
                ),
                onPressed: _updatePatients,
                child: const Text(
                  'Update',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
          children: [
            if (!_isAddMode)
              Column(
                children: [
                  // display the patient list
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _filterPatients(_myPatients).length,
                    itemBuilder: (context, index) {
                      Patient familyPatient =
                          _filterPatients(_myPatients)[index];
                      return _buildPatientInfo(familyPatient, true);
                    },
                  ),
                ],
              ),
            if (_isAddMode)
              Column(
                children: [
                  // display all patients
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _filterPatients(_allPatients).length,
                    itemBuilder: (context, index) {
                      Patient patient = _filterPatients(_allPatients)[index];
                      return _buildPatientInfo(patient, false);
                    },
                  ),
                ],
              ),
          ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PatientList(),
              ),
            );
          },
          backgroundColor: const Color(0xFF003CD6),
          child: const Icon(
            Icons.list,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
