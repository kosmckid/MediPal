import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medipal/objects/practitioner.dart';
import 'package:firebase_database/firebase_database.dart';

class AccountInfoPage extends StatefulWidget {
  final String? userUid;
  AccountInfoPage({
    super.key,
    required this.userUid,
  });

  @override
  _AccountInfoPageState createState() => _AccountInfoPageState();
}

class _AccountInfoPageState extends State<AccountInfoPage> {
  late Practitioner _practitioner;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  //late TextEditingController _photoController;
  bool _isEditing = false;

  void _fetchPractitioner() async {
    Practitioner? practitioner = await Practitioner.getPractitioner(widget.userUid!);
  practitioner!.id = widget.userUid;
    practitioner.appointments.sort((a, b) {
      return a.patient!.toLowerCase().compareTo(b.patient!.toLowerCase());
    });
    setState(() {
      _practitioner = practitioner;
    });
  }


  @override
  void initState(){
    super.initState();
    _fetchPractitioner();
    _nameController = TextEditingController(text: Practitioner.currentPractitioner?.name);
    _emailController = TextEditingController(text: FirebaseAuth.instance.currentUser?.email);
    _passwordController = TextEditingController(text: FirebaseAuth.instance.currentUser?.displayName);
    //_photoController = TextEditingController(text: FirebaseAuth.instance.currentUser?.photoURL);  
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Information',
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
        actions: _buildAppBarActions(),
      ),
      body: Padding(
        padding: EdgeInsets.all(50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: '${_practitioner.name}',
              ),
              controller: _nameController,
              enabled: _isEditing,
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Email:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            TextField(
              decoration: InputDecoration(
                hintText: '${_practitioner.email}',
              ),
              controller: _emailController,
              enabled: _isEditing,
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Password:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            TextField(
              decoration: InputDecoration(
                hintText: '${FirebaseAuth.instance.currentUser?.displayName}',
              ),
              controller: _emailController,
              enabled: _isEditing,
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Photo:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            /*TextField(
              decoration: InputDecoration(
                hintText: 'test',
              ),
              controller: _photoController,
              enabled: _isEditing,
              style: TextStyle(fontSize: 16.0),
            ),*/
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAppBarActions(){
    if (_isEditing){
      return [
        IconButton(
          icon: Icon(Icons.save),
          onPressed: (){
            _saveChanges();
          }
        ),
      ];
    }else{
      return [
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            setState(() {
              _isEditing = true;
            });
          }
        ),
      ];
    }
  }

  void _saveChanges() {
    if (_practitioner != null) {
      FirebaseAuth.instance.currentUser?.updateEmail(_emailController.text)
        .then((_) {
          if (_passwordController.text.isNotEmpty) {
            FirebaseAuth.instance.currentUser?.updatePassword(_passwordController.text)
              .then((_) {
                _updatePractitionerInfo();
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update password: $error')));
              });
          } else {
            _updatePractitionerInfo();
          }
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update email: $error')));
        });
    }
  }

  void _updatePractitionerInfo() {
    //Update the practitioner's info in the database
    _practitioner.name = _nameController.text;
    _practitioner.email = _emailController.text;
    DatabaseReference ref = FirebaseDatabase.instance.ref('users/${_practitioner.id}');
    ref.set(_practitioner.toJson()).then((_) {
      setState(() {
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Changes saved')));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save changes to database: $error')));
    });
  }


  @override
  void dispose(){
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}