import 'package:flutter/material.dart';
import 'package:medipal/objects/practitioner.dart';
import 'package:medipal/pages/dashboard.dart';

class PractitionerList extends StatefulWidget {
  const PractitionerList({super.key});

  @override
  PractitionerListState createState() => PractitionerListState();
}

class PractitionerListState extends State<PractitionerList> {
  late List<Practitioner> _practitioners = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchPractitioners();
  }

  void _fetchPractitioners() async {
    List<Practitioner>? practitioner = await Practitioner.getAllPractitioners();
    practitioner!.sort((a, b) {
      return a.name!.toLowerCase().compareTo(b.name!.toLowerCase());
    });
    setState(() {
      _practitioners = practitioner;
    });
  }

  List<Practitioner> _filterPractitioners(List<Practitioner> practitioners) {
    if (_searchQuery.isEmpty) {
      return practitioners;
    } else {
      return practitioners
          .where((practitioner) =>
              practitioner.name!.toLowerCase().contains(_searchQuery))
          .toList();
    }
  }

  Widget _buildPractitionerInfo(Practitioner practitioner) {
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
        trailing: const Icon(Icons.arrow_forward_ios),
        title: Text('${practitioner.name}'),
        subtitle: Text('${practitioner.email}'),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard(
                userUid: practitioner.id,
              ),
            )),
        tileColor: const Color(0xFFDADFEC),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Practitioner List',
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
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
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
            ),
          ),
        ),
        body: _practitioners.isNotEmpty
            ? ListView.builder(
                itemCount: _filterPractitioners(_practitioners).length,
                itemBuilder: (context, index) {
                  return _buildPractitionerInfo(
                      _filterPractitioners(_practitioners)[index]);
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
