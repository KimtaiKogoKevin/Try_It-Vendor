import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:image_picker/image_picker.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final _businessName = TextEditingController();
  final _phoneNumber = TextEditingController();
  final email = TextEditingController();
  final kra_pin = TextEditingController();
  final _address = TextEditingController();
  final _city = TextEditingController();
  final _country = TextEditingController();
  String? _taxStatus;

  String? bname;
  XFile? _shopImage;
  XFile? logo;
  Widget _formField(
      {TextEditingController? controller,
      String? label,
      TextInputType? type,
      String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        prefixText: controller == _phoneNumber ? '+254' : null,
        hintText: controller == _address
            ? 'Enter street / road where business is located'
            : null,
        prefixIcon: controller == _country
            ? IconButton(icon: Icon(Icons.flag), onPressed: () {})
            : null,
      ),
      validator: validator,
      onChanged: (value) {
        if (controller == _businessName) {
          setState(() {
            bname = value;
          });
        }
      },
    );
  }

  Future<XFile?> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 240,
                  child: Stack(
                    children: [
                      _shopImage == null
                          ? Container(
                              color: Colors.blue,
                              height: 250,
                              child: TextButton(
                                onPressed: () {
                                  pickImage().then((value) {
                                    setState(() {
                                      _shopImage = value;
                                    });
                                  });
                                },
                                child: const Center(
                                  child: Text('Upload Shop Image',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 20)),
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                pickImage().then((value) {
                                  setState(() {
                                    _shopImage = value;
                                  });
                                });
                              },
                              child: InkWell(
                                onTap: () {
                                  pickImage().then((value) {
                                    setState(() {
                                      _shopImage = value;
                                    });
                                  });
                                },
                                child: Container(
                                  height: 250,
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      image: DecorationImage(
                                        opacity: 100,
                                          image: FileImage(
                                            File(_shopImage!.path),
                                          ),
                                          fit: BoxFit.cover)),
                                ),
                              ),
                            ),
                      SizedBox(
                        height: 80,
                        child: AppBar(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            actions: [
                              IconButton(
                                icon: const Icon(Icons.exit_to_app),
                                onPressed: () {
                                  FirebaseAuth.instance.signOut();
                                },
                              )
                            ]),
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(children: [
                              InkWell(
                                onTap: (){
                                  pickImage().then((value){
                                    setState(() {
                                      logo = value;
                                    });
                                  });
                                },
                                child: Card(
                                  elevation: 10,
                                  child:  logo == null ? const SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: Center(
                                        child: Text('+')),
                                  ) : ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Container(
                                      height: 50 ,
                                        width: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          image: DecorationImage(
                                              image: FileImage(
                                                File(logo!.path),
                                              ),
                                              fit: BoxFit.cover)),


                                    ),
                                  )
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(bname == null ? ' Brand Name ' : bname!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white ,
                                  fontSize: 20))
                            ]),
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 8, 30, 8),
                  child: Column(
                    children: [
                      _formField(
                          controller: _businessName,
                          label: 'Business Name',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ' Enter Business Name';
                            }
                            return null;
                          },
                          type: TextInputType.text),
                      _formField(
                          controller: _phoneNumber,
                          label: 'Enter Phone Number',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ' Enter Phone Number';
                            }
                            return null;
                          },
                          type: TextInputType.phone),
                      _formField(
                          controller: email,
                          label: 'Email Address',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ' Email Address';
                            }
                            bool _isValid = (EmailValidator.validate(value));
                            if (_isValid == false) {
                              return 'Invalid Email';
                            }
                          },
                          type: TextInputType.emailAddress),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 8, 30, 8),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Tax Registered"),
                      ),
                      Expanded(
                        child: DropdownButtonFormField(
                            value: _taxStatus,
                            validator: (value) {
                              if (_taxStatus == null) {
                                return 'No value selected';
                              }
                            },
                            hint: const Text('Select'),
                            items: <String>['Yes', 'No']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                _taxStatus = value;
                              });
                            }),
                      )
                    ],
                  ),
                ),
                if (_taxStatus == 'Yes')
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 8, 30, 8),
                    child: _formField(
                        controller: kra_pin,
                        label: 'Enter KRA Pin',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter KRA PIN';
                          }
                        },
                        type: TextInputType.number),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 8, 30, 8),
                  child: _formField(
                      controller: _address,
                      label: 'Address',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ' Enter Your Address';
                        }
                        return null;
                      },
                      type: TextInputType.text),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 8, 30, 8),
                  child: _formField(
                      controller: _city,
                      label: 'City',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ' Enter City Name';
                        }
                        return null;
                      },
                      type: TextInputType.text),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 8, 30, 8),
                  child: _formField(
                      controller: _country,
                      label: 'Country Name',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ' Enter Country Name';
                        }
                        return null;
                      },
                      type: TextInputType.text),
                ),
              ],
            ),
          ),
          persistentFooterButtons: [
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                        } else {}
                      },
                      child: const Text('Register')),
                ))
              ],
            ),
          ]),
    );
  }
}
