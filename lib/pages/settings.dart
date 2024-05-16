import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medipal/constant/images.dart';
import 'package:medipal/objects/practitioner.dart';
import 'package:medipal/pages/account_details.dart';
//import 'package:medipal/objects/appointment_patient.dart';
import 'package:medipal/pages/appointment_page.dart';
import 'package:medipal/pages/dashboard.dart';
import 'package:medipal/pages/patient_list.dart';
import 'package:medipal/pages/patient_form.dart';
import '../objects/patient.dart';
import 'package:medipal/pages/languageRegionSelect.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medipal/pages/language_constants.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  //Signs out the user and sends them back to the login page.
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, '/Login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Settings',
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
      ),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 5, right: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 50, // Fixed width for back arrow
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: Colors.black, size: 40),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Container(
                        height: 100.0,
                        width: 100.0,
                        child: Image.asset(
                          myImage,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        SizedBox(width: 25),
                        Padding(
                          padding: EdgeInsets.only(top: 13),
                          child: Image.asset(
                            'assets/bettercog.png',
                            fit: BoxFit.contain,
                            width: 50,
                            height: 50,
                          ),
                        ),
                        SizedBox(
                          width: 7,
                        ), // Add some space between the image and the text
                        Text(
                          translation(context).settings,
                          style: TextStyle(
                            fontSize: 45,
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
                      ],
                    ),
                  ),*/
                  SingleChildScrollView(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: 0,
                          ),
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              FractionallySizedBox(
                                widthFactor: 1.0,
                                child: Container(
                                  margin: EdgeInsets.all(10.0),
                                  padding: EdgeInsets.all(10.0),
                                  child: Container(
                                    height: 539.0,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 25.0),
                                          height: 420.0,
                                          decoration: BoxDecoration(
                                            color: Color(0xFF6589e3),
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left:
                                                          20.0), // Add 20 pixels of padding to the left side
                                                  child: Text(
                                                    translation(context)
                                                        .preferences,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 40.0),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.all(5.0),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFF7f97ed),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          35.0),
                                                ),
                                                child: ListTile(
                                                  trailing: Image.asset(
                                                      'assets/arrow.png'),
                                                  title: Text(
                                                    translation(context)
                                                        .languageAndRegion,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 25.0,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    '',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    // Navigate to Account settings page
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            LanguageRegionSelect(),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              // Add other ListTile widgets for settings
                                              Container(
                                                margin: EdgeInsets.all(5.0),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFF7f97ed),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          35.0),
                                                ),
                                                child: ListTile(
                                                  trailing: Image.asset(
                                                      'assets/arrow.png'),
                                                  title: Text(
                                                    translation(context)
                                                        .account,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 25.0,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    translation(context)
                                                        .emailPasswordChange,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  onTap: () async {
                                                    // Navigate to Account settings page
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            AccountInfoPage(userUid: FirebaseAuth.instance.currentUser!.uid),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.all(5.0),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFF7f97ed),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          35.0),
                                                ),
                                                child: ListTile(
                                                  trailing: Image.asset(
                                                      'assets/arrow.png'),
                                                  title: Text(
                                                    translation(context)
                                                        .security,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 25.0,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    translation(context)
                                                        .privacySettingsForPatientDataAccess,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    // Navigate to Security settings page
                                                  },
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.all(5.0),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFF7f97ed),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          35.0),
                                                ),
                                                child: ListTile(
                                                  trailing: Image.asset(
                                                      'assets/arrow.png'),
                                                  title: Text(
                                                    translation(context)
                                                        .notifications,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 25.0,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    '',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    // Navigate to Security settings page
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFF1F56DE),
                                            minimumSize: Size(300.0, 50.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),
                                          ),
                                          child: Text(
                                            //'Logout',
                                            translation(context).logout,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30.0,
                                            ),
                                          ),
                                          onPressed: () {
                                            _signOut();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
