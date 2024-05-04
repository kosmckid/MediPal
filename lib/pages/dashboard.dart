import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medipal/constant/images.dart';
import 'package:medipal/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:medipal/objects/patient.dart';
import 'package:medipal/patient_list.dart';
import 'package:flutter/material.dart';
import 'package:medipal/form_patient.dart';
import 'package:medipal/objects/patient.dart';
import 'package:medipal/forms/patient_data.dart';
import 'package:flutter/material.dart';
import 'package:medipal/constant/images.dart';
import 'package:medipal/pages/appointment_date.dart';
import 'package:medipal/pages/appointment.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Appointment> _appointments = [];
  List<Patient> _patients = [];

  @override
  void initState() {
    super.initState();
    _fetchPatientData();
    _fetchAppointmentData(); // Add this line
  }

  Future<void> _fetchAppointmentData() async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref();
      DataSnapshot snapshot = await ref.child('appointments').get();
      if (snapshot.value != null) {
        Map<dynamic, dynamic>? jsonMap =
            snapshot.value as Map<dynamic, dynamic>;
        List<Appointment> al = [];
        jsonMap.forEach((key, value) {
          Appointment a = Appointment.fromMap(value.cast<String, dynamic>());
          al.add(a);
        });
        print(al); // Print the list of appointments
        setState(() {
          _appointments = al;
        });
      }
    } catch (e) {
      print("Error fetching appointment data: $e");
    }
  }

  Future<void> _fetchPatientData() async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref();
      DataSnapshot snapshot = await ref.child('patient').get();
      if (snapshot.value != null) {
        Map<dynamic, dynamic>? jsonMap =
            snapshot.value as Map<dynamic, dynamic>;
        List<Patient> pl = [];
        jsonMap.forEach((key, value) {
          Patient p = Patient.fromMap(value.cast<String, dynamic>());
          pl.add(p);
        });
        print(pl); // Print the list of patients
        setState(() {
          _patients = pl;
        });
      }
    } catch (e) {
      print("Error fetching patient data: $e");
    }
  }

  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFb6c9ee), // Light blue at the top
                Color(0xFFb6c9ee), // Light blue at the bottom
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Column(
              // Removed Expanded widget
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.black, size: 40),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Container(
                      height: 100,
                      width: 100,
                      child: Image.asset(
                        myImage,
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 25),
                    Image.asset('assets/alert.png'),
                    SizedBox(width: 7), // Adjust the width as needed
                    Padding(
                      padding: EdgeInsets.only(
                          top: 3), // Adjust the top padding as needed
                      child: Text(
                        'Alerts',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              offset: const Offset(0, 3),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Center(
                  child: Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width - 35),
                    height: 150,
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 25),
                    Image.asset('assets/checkmarkCal.png'),
                    SizedBox(width: 7), // Adjust the width as needed
                    Padding(
                      padding: EdgeInsets.only(
                          top: 1), // Adjust the top padding as needed
                      child: Text(
                        'Appointments',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              offset: const Offset(0, 3),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Center(
                  child: Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width - 35),
                    height: 150,
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView.builder(
                      itemCount: _appointments.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                              '${_appointments[index].title}'), // Replace 'name' with the correct property
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 25),
                    Image.asset('assets/patDashboard.png'),
                    SizedBox(width: 7), // Adjust the width as needed
                    Padding(
                      padding: EdgeInsets.only(
                          top: 3), // Adjust the top padding as needed
                      child: Text(
                        'My Patients',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              offset: const Offset(0, 3),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Center(
                  child: Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width - 35),
                    height: 150,
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView.builder(
                      itemCount: _patients.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          // Wrap ListTile with Card
                          color: Color(0xFFdadfec),
                          child: ListTile(
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(width: 25),
                                Image.asset('assets/patientCross.png'),
                                SizedBox(width: 7),
                                Text(
                                  '${_patients[index].firstName} ${_patients[index].middleName} ${_patients[index].lastName}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
