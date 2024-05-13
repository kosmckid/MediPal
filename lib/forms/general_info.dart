import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medipal/templates/input_template.dart';
import 'package:medipal/objects/patient.dart';

class GeneralInfoForm extends StatefulWidget {
  final Patient patient;
  final GlobalKey<FormState> formKey;
  const GeneralInfoForm({
    super.key,
    required this.patient,
    required this.formKey,
  });

  @override
  GeneralInfoFormState createState() => GeneralInfoFormState();
}

class GeneralInfoFormState extends State<GeneralInfoForm> {
  // list choices
  final List<String> _bloodGroups = ['A', 'B', 'AB', 'O'];
  final List<String> _rhFactors = ['+', '-'];
  final List<String> _phoneTypes = ['home', 'work', 'mobile'];
  late FileData _idImage = FileData();
  bool _fetchingIdImage = false;

  @override
  void initState() {
    super.initState();
    if (widget.patient.id != null) {
      _fetchIDImage();
    }
  }

  Future<void> _fetchIDImage() async {
    setState(() {
      _fetchingIdImage = true;
    });
    Reference idImageRef = FirebaseStorage.instance
        .ref()
        .child('patients/${widget.patient.id}/idImage');
    String downloadUrl = await idImageRef.getDownloadURL();
    setState(() {
      _idImage = FileData(
        name: 'idImage',
        url: downloadUrl,
      );
      _fetchingIdImage = false;
    });
  }

  // build
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  if (_fetchingIdImage)
                    const CircularProgressIndicator()
                  else if (_idImage.url != null)
                    Image.network(_idImage.url!, height: 200, width: 200)
                  else if (_idImage.file != null)
                    Image.file(_idImage.file!, height: 200, width: 200),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        final image = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          setState(() {
                            _idImage = FileData(
                              file: File(image.path),
                              name: 'idImage',
                            );
                            widget.patient.files.add(_idImage);
                          });
                        }
                      },
                      child: const Text('Select ID Image'),
                    ),
                  ),
                ],
              ),
              buildTextFormField(
                labelText: 'First Name',
                value: widget.patient.firstName,
                onChanged: (value) {
                  setState(() {
                    widget.patient.firstName = value;
                  });
                },
              ),
              buildTextFormField(
                labelText: 'Middle Name',
                value: widget.patient.middleName,
                onChanged: (value) {
                  setState(() {
                    widget.patient.middleName = value;
                  });
                },
              ),
              buildTextFormField(
                labelText: 'Last Name',
                value: widget.patient.lastName,
                onChanged: (value) {
                  setState(() {
                    widget.patient.lastName = value;
                  });
                },
              ),
              buildTextFormField(
                labelText: 'Location',
                value: widget.patient.location,
                onChanged: (value) {
                  setState(() {
                    widget.patient.location = value;
                  });
                },
              ),
              buildTextFormField(
                labelText: 'Sex',
                value: widget.patient.sex,
                onChanged: (value) {
                  setState(() {
                    widget.patient.sex = value;
                  });
                },
              ),
              const Text('Date of Birth'),
              ElevatedButton(
                onPressed: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      widget.patient.dob = pickedDate;
                    });
                  }
                },
                child: Text(
                  widget.patient.dob != null
                      ? 'DOB: ${widget.patient.dob!.year}-${widget.patient.dob!.month}-${widget.patient.dob!.day}'
                      : 'Select DOB',
                ),
              ),
              Row(
                children: [
                  const Text('Blood Group'),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 50,
                    child: buildDropdownFormField<String>(
                      value: widget.patient.bloodGroup,
                      onChanged: (String? value) {
                        setState(() {
                          widget.patient.bloodGroup = value;
                        });
                      },
                      items: _bloodGroups,
                    ),
                  ),
                  const Text('RH Factor'),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 50,
                    child: buildDropdownFormField<String>(
                      value: widget.patient.rhFactor,
                      onChanged: (String? value) {
                        setState(() {
                          widget.patient.rhFactor = value;
                        });
                      },
                      items: _rhFactors,
                    ),
                  ),
                ],
              ),
              buildTextFormField(
                labelText: 'Marital Status',
                value: widget.patient.maritalStatus,
                onChanged: (value) {
                  setState(() {
                    widget.patient.maritalStatus = value;
                  });
                },
              ),
              buildTextFormField(
                labelText: 'E-mail',
                value: widget.patient.email,
                onChanged: (value) {
                  setState(() {
                    widget.patient.email = value;
                  });
                },
              ),
              const Text('Phone'),
              Column(
                children: [
                  ...List.generate(
                    widget.patient.phone.length,
                    (index) {
                      PhoneData contact = widget.patient.phone[index];
                      return Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: buildDropdownFormField<String>(
                              value: contact.type,
                              onChanged: (String? value) {
                                setState(() {
                                  contact.type = value;
                                });
                              },
                              items: _phoneTypes,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: buildTextFormField(
                              labelText: 'Phone Number ${index + 1}',
                              value: contact.phoneNumber?.toString(),
                              onChanged: (value) {
                                contact.phoneNumber = value;
                              },
                              onSuffixIconTap: index == 0
                                  ? null
                                  : () => setState(() =>
                                      widget.patient.phone.removeAt(index)),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          widget.patient.phone.add(PhoneData());
                        });
                      },
                      child: const Text("Add More"),
                    ),
                  ),
                ],
              ),
              const Text('Emergancy Contacts'),
              Column(
                children: [
                  ...List.generate(
                    widget.patient.emergency.length,
                    (index) {
                      EmergancyData contact = widget.patient.emergency[index];
                      return Row(
                        children: [
                          Expanded(
                            child: buildTextFormField(
                              labelText: 'Name ${index + 1}',
                              value: contact.name?.toString(),
                              onChanged: (value) {
                                contact.name = value;
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          SizedBox(
                            width: 100,
                            child: buildDropdownFormField<String>(
                              value: contact.type,
                              onChanged: (String? value) {
                                setState(() {
                                  contact.type = value;
                                });
                              },
                              items: _phoneTypes,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: buildTextFormField(
                              labelText: 'Phone Number ${index + 1}',
                              value: contact.phoneNumber?.toString(),
                              onChanged: (value) {
                                contact.phoneNumber = value;
                              },
                              onSuffixIconTap: index == 0
                                  ? null
                                  : () => setState(() =>
                                      widget.patient.emergency.removeAt(index)),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          widget.patient.emergency.add(EmergancyData());
                        });
                      },
                      child: const Text("Add More"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
