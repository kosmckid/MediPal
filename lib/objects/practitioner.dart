import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:medipal/objects/appointment.dart';

class Practitioner {
  // VARIABLES
  String? id;
  String? email;
  String? name;
  List<String> patients = [];
  List<Appointment> appointments = [];

  static Practitioner? currentPractitioner;

  // CONSTRUCTOR
  Practitioner();

  // convert to json
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'patients': patients,
      'name': name,
      'appointments':
          appointments.map((appointment) => appointment.toJson()).toList(),
    };
  }

  // get practitioner from snapshot
  factory Practitioner.fromSnapshot(DataSnapshot snapshot) {
    if (snapshot.exists) {
      Map<dynamic, dynamic>? value = snapshot.value as Map<dynamic, dynamic>;
      return Practitioner.fromMap(value.cast<String, dynamic>());
    }
    throw const FormatException('snapshot does not exist');
  }

  // get practitioner from json map
  factory Practitioner.fromMap(Map<String, dynamic> jsonMap) {
    Practitioner u = Practitioner();
    u.email = jsonMap['email'];
    u.name = jsonMap['name'];
    List<dynamic>? patients = jsonMap['patients'];
    if (patients is List<dynamic>) {
      u.patients = List<String>.from(patients);
    }
    List<dynamic>? appointments = jsonMap['appointments'];
    if (appointments is List<dynamic>) {
      u.appointments = appointments.map((appointment) {
        if (appointment['time'] != null) {
          return Appointment(
            topic: appointment['topic'] as String?,
            patient: appointment['patient'] as String?,
            time: DateTimeRange(
              start: DateTime.parse(appointment['time']['start'] as String),
              end: DateTime.parse(appointment['time']['end'] as String),
            ),
          );
        } else {
          return Appointment.fromMap(appointment);
        }
      }).toList();
    }
    return u;
  }

  // get practitioner from database
  static Future<Practitioner?> getPractitioner(String uid) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('users');
    DataSnapshot snapshot = await ref.child(uid).get();
    if (!snapshot.exists) return null;
    Map<dynamic, dynamic>? value = snapshot.value as Map<dynamic, dynamic>;
    return Practitioner.fromMap(value.cast<String, dynamic>());
  }

  // get list of all practitioners
  static Future<List<Practitioner>> getAllPractitioners() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    DataSnapshot snapshot = await ref.child('users').get();
    if (snapshot.exists) {
      Map<dynamic, dynamic>? jsonMap = snapshot.value as Map<dynamic, dynamic>;
      List<Practitioner> practitioners = [];
      jsonMap.forEach((key, value) {
        Practitioner p = Practitioner.fromMap(value.cast<String, dynamic>());
        p.id = key;
        practitioners.add(p);
      });
      return practitioners;
    }
    return [];
  }
}
