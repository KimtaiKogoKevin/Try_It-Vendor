import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:tryit_vendor_app/Screens/home.dart';
import 'package:tryit_vendor_app/Screens/landingscreen.dart';

import '../../firebase_services.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseServices _services = FirebaseServices();
  String? countryValue ;
  String? stateValue ;
  String? cityValue ;
  String?  address ;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final _businessName = TextEditingController();
  final _phoneNumber = TextEditingController();
  final email = TextEditingController();
  final kraPin = TextEditingController();
  final _landMark = TextEditingController();
  String? _taxStatus;

  String? bName;
  XFile? _shopImage;
  XFile? logo;
  String? shopImageUrl;
  String? logoImageUrl;

  Widget _formField({TextEditingController? controller,
    String? label,
    TextInputType? type,
    String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        prefixText: controller == _phoneNumber ? '+254' : null,


      ),
      validator: validator,
      onChanged: (value) {
        if (controller == _businessName) {
          setState(() {
            bName = value;
          });
        }
      },
    );
  }

  _scaffold(message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message),
    action: SnackBarAction(
      label:'OK',
      onPressed: (){
        ScaffoldMessenger.of(context).clearSnackBars();
      },
    ),));
  }

  saveToDB(){
    if(_shopImage==null){
      _scaffold('Shop Image Required');
      return;
    }
    if( logo==null){
      _scaffold('Logo Required');
      return;
    }

    if (_formKey.currentState!.validate()) {
      if( stateValue==null || countryValue==null){
        _scaffold('Address fields cannot be null');

        return;
      }
      EasyLoading.show(status: "Please Wait...");
      _services.uploadImage(_shopImage, 'vendors/${_services.user!.uid}/shopImage.jpg').then((url){
        setState(() {
          shopImageUrl = url;
        });
      }).then((value) {
        _services.uploadImage(logo, 'vendors/${_services.user!.uid}/logo.jpg').then((url) {
          setState(() {
            logoImageUrl=url;
          });
        }).then((value){
          _services.addVendor(
              data: {
                'shopImage':shopImageUrl,
                'logoImage' : logoImageUrl,
                'businessName' : _businessName.text,
                'phoneNo' : '+254${_phoneNumber.text}',
                'email' : email.text,
                'taxRegistered' : _taxStatus,
                'kraPin' : kraPin.text.isEmpty ? 'no value' : kraPin.text ,
                'landMark' : _landMark.text,
                'country': countryValue,
                'state' : stateValue,
                'city' : cityValue,
                'approved' : false,
                'uid' : _services.user?.uid,
                'time':DateTime.now()
              })

              .then((value) {
            EasyLoading.dismiss();
            return  Navigator.of(context).pushReplacement( MaterialPageRoute (
              builder: (BuildContext context) => const LandingScreen(),
            ),);

          });
        });
      });
    }
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
                                onTap: () {
                                  pickImage().then((value) {
                                    setState(() {
                                      logo = value;
                                    });
                                  });
                                },
                                child: Card(
                                    elevation: 10,
                                    child: logo == null ? const SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: Center(
                                          child: Text('+')),
                                    ) : ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: Container(
                                        height: 50,
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
                              Text(bName == null ? ' Brand Name ' : bName!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
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
                            return null;
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
                              return null;
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
                        controller: kraPin,
                        label: 'Enter KRA Pin',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter KRA PIN';
                          }
                          return null;
                        },
                        type: TextInputType.number),
                  ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 8, 30, 0),
                  child: _formField(
                      controller: _landMark,
                      label: 'Enter a landmark near your business',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Value cannot be null';
                        }
                        return null;
                      },
                      type: TextInputType.text),
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CSCPicker(
                    ///Enable disable state dropdown [OPTIONAL PARAMETER]
                    showStates: true,

                    /// Enable disable city drop down [OPTIONAL PARAMETER]
                     showCities: true,

                    ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                    flagState: CountryFlag.ENABLE,

                    ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                    dropdownDecoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                        border:
                        Border.all(color: Colors.grey.shade300, width: 1)),

                    ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                    disabledDropdownDecoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                        border:
                        Border.all(color: Colors.grey.shade300, width: 1)),

                    ///placeholders for dropdown search field
                    countrySearchPlaceholder: "Country",
                    stateSearchPlaceholder: "State",
                    citySearchPlaceholder: "City",

                    ///labels for dropdown
                    countryDropdownLabel: "Country",
                    stateDropdownLabel: "State",
                    cityDropdownLabel: "City",

                    ///Default Country
                    defaultCountry: DefaultCountry.Kenya,

                    ///Disable country dropdown (Note: use it with default country)
                    //disableCountry: true,

                    ///selected item style [OPTIONAL PARAMETER]
                    selectedItemStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),

                    ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                    dropdownHeadingStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),

                    ///DropdownDialog Item style [OPTIONAL PARAMETER]
                    dropdownItemStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),

                    ///Dialog box radius [OPTIONAL PARAMETER]
                    dropdownDialogRadius: 10.0,

                    ///Search bar radius [OPTIONAL PARAMETER]
                    searchBarRadius: 10.0,

                    ///triggers once country selected in dropdown
                    onCountryChanged: (value) {
                      setState(() {
                        ///store value in country variable
                        countryValue = value;
                      });
                    },

                    ///triggers once state selected in dropdown
                    onStateChanged: (value) {
                      setState(() {
                        ///store value in state variable
                        stateValue = value;
                      });
                    },

                    ///triggers once city selected in dropdown
                    onCityChanged: (value) {
                      setState(() {
                        ///store value in city variable
                        cityValue = value;

                      });
                    },

                  ),
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
                          onPressed: saveToDB,

                          child: const Text('Register')),
                    ))
              ],
            ),
          ]),
    );
  }
}
