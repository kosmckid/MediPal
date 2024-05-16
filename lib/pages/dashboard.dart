import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medipal/chat/chat_page.dart';
import 'package:medipal/constant/images.dart';
import 'package:medipal/objects/appointment.dart';
import 'package:medipal/objects/practitioner.dart';
import 'package:medipal/pages/appointment_page.dart';

class Dashboard extends StatefulWidget {
  final String? userUid;
  const Dashboard({
    super.key,
    required this.userUid,
  });

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  late Practitioner _practitioner;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPractitioner();
  }

  void _fetchPractitioner() async {
    Practitioner? practitioner =
        await Practitioner.getPractitioner(widget.userUid!);
    practitioner!.id = widget.userUid;
    practitioner.appointments.sort((a, b) {
      return a.patient!.toLowerCase().compareTo(b.patient!.toLowerCase());
    });
    setState(() {
      _practitioner = practitioner;
      _isLoading = false;
    });
  }

  Widget _buildAppointmentInfo(Appointment appointment) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    'Name: ${appointment.patient}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Topic: ${appointment.topic}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Time: ${appointment.time}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'M E D I P A L',
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
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /* Row(
                        children: [
                          Row(
                            mainAxisAlignment:
                                FirebaseAuth.instance.currentUser!.uid !=
                                        _practitioner.id
                                    ? MainAxisAlignment.spaceBetween
                                    : MainAxisAlignment.end,
                            children: [
                              if (FirebaseAuth.instance.currentUser!.uid !=
                                  _practitioner.id)
                                IconButton(
                                  icon: const Icon(Icons.arrow_back,
                                      color: Colors.black, size: 40),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              SizedBox(
                                height: 100,
                                width: 100,
                                child: Image.asset(
                                  myImage,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, left: 148.0),
                                  child: SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: Image.asset(
                                          profilePic) /* Image.asset(
                                    FirebaseAuth.instance.currentUser!
                                                .photoURL !=
                                            null
                                        ? FirebaseAuth
                                            .instance.currentUser!.photoURL!
                                        : profilePic,
                                  ), */
                                      ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(width: 55),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Text(
                                    'Welcome Dr. ${_practitioner.name}',
                                    style: TextStyle(
                                      fontSize: 30,
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
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(width: 25),
                              Image.asset('assets/checkmarkCal.png'),
                              const SizedBox(width: 7),
                              Padding(
                                padding: const EdgeInsets.only(top: 1),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, left: 148.0),
                              child: Container(
                                  height: 100,
                                  width: 100,
                                  child: Image.asset(
                                      profilePic) /* Image.asset(
                                  FirebaseAuth.instance.currentUser!
                                              .photoURL !=
                                          null
                                      ? FirebaseAuth
                                          .instance.currentUser!.photoURL!
                                      : profilePic,
                                ), */
                                  ),
                            ),
                          ),
                        ],
                      ), */
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(width: 55),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  'Welcome Dr. ${_practitioner.name}',
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 130,
                              width: 130,
                              child: Image.asset(
                                myLogo,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 25),
                            Image.asset(
                              'assets/checkmarkCal.png',
                              color: Colors.black,
                            ),
                            const SizedBox(width: 7),
                            const Padding(
                              padding: EdgeInsets.only(top: 1),
                              child: Text(
                                'Upcoming Appointments',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Center(
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width - 35),
                            height: 400,
                            padding: const EdgeInsets.all(25),
                            decoration: BoxDecoration(
                              color: Color(0xFFDADFEC),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListView.builder(
                              itemCount: _practitioner.appointments.length,
                              itemBuilder: (context, index) {
                                return _buildAppointmentInfo(
                                    (_practitioner.appointments)[index]);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                      ],
                    ),
                  ),
                ),
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 5,
            child: Expanded(
              child: widget.userUid != FirebaseAuth.instance.currentUser!.uid
                  ? FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(
                              receiverUid: _practitioner.id!,
                              receiverName: _practitioner.name!,
                            ),
                          ),
                        );
                      },
                      backgroundColor: const Color(0xFF003CD6),
                      child: const Icon(
                        Icons.chat,
                        color: Colors.white,
                      ),
                    )
                  : FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AppointmentPage(
                              userUid: _practitioner.id!,
                            ),
                          ),
                        );
                      },
                      backgroundColor: const Color(0xFF003CD6),
                      child: const Icon(
                        Icons.people,
                        color: Colors.white,
                      ),
                    ),
            ),
          )),
    );
  }
}
