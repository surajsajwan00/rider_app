import 'package:flutter/material.dart';
import 'package:riders/screens/upload_documents.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:riders/widgets/riderdata.dart';
import 'package:provider/provider.dart';

class AddNewRiderScreen extends StatefulWidget {
  @override
  _AddNewRiderScreenState createState() => _AddNewRiderScreenState();
}

class _AddNewRiderScreenState extends State<AddNewRiderScreen> {
  String name = '';
  String phonenumber = '';
  List<String> local = [];
  String addr = '';
  String p = '';
  String bank = '';
  String ifsccode = '';
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _pincodeController = TextEditingController();
  TextEditingController _bankAccountController = TextEditingController();
  TextEditingController _ifscController = TextEditingController();

  //Sample location to choose from:
  List<String> _localities = [
    'Rajpur Road',
    'ISBT',
    'Prem Nagar',
    'Doiwala',
    'Nehru Colony',
    'Indra Nagar Colony'
  ];

  bool _isFormValid = false; //This will track the overall-validation status

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _pincodeController.dispose();
    _bankAccountController.dispose();
    _ifscController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RiderData(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add New Rider"),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            onChanged: () {
              setState(() {
                _isFormValid = _formKey.currentState?.validate() ?? false;
              });
            },
            child: Consumer<RiderData>(
              builder: (context, riderData, _) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: "Name",
                            ),
                            validator: (nm) {
                              if (nm == null || nm.isEmpty) {
                                return 'Please enter a name';
                              }
                              return null;
                            },
                            onChanged: (nm) {
                              name = nm;
                              riderData.updateName(nm);
                            },
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            controller: _phoneNumberController,
                            decoration: InputDecoration(
                              labelText: "Phone Number",
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (pn) {
                              if (pn == null || pn.isEmpty) {
                                return 'Please enter a phone number';
                              }
                              if (pn.length != 9) {
                                return 'Phone number must have 9 digits';
                              }
                              return null;
                            },
                            onChanged: (pn) {
                              phonenumber = pn;
                              riderData.updatePhoneNumber(pn);
                            },
                          ),
                          SizedBox(height: 16.0),
                          MultiSelectDialogField(
                            items: _localities
                                .map(
                                  (locality) =>
                                      MultiSelectItem(locality, locality),
                                )
                                .toList(),
                            title: Text("Localities"),
                            selectedColor: Theme.of(context).primaryColor,
                            buttonText: Text("Select Localities"),
                            onConfirm: (values) {
                              local = values;
                              riderData.updateLocalities(values);
                            },
                            validator: (loc) {
                              if (loc == null || loc.isEmpty) {
                                return "Please select at least 1 locality";
                              }
                              if (loc.length > 3) {
                                return "Please select a maximum of 3 localities";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            controller: _addressController,
                            decoration: InputDecoration(
                              labelText: "Current Address",
                            ),
                            validator: (ad) {
                              if (ad == null || ad.isEmpty) {
                                return 'Please enter an address';
                              }
                              return null;
                            },
                            onChanged: (ad) {
                              addr = ad;
                              riderData.updateAddress(ad);
                            },
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            controller: _pincodeController,
                            decoration: InputDecoration(
                              labelText: "Current Pincode",
                            ),
                            keyboardType: TextInputType.number,
                            validator: (pin) {
                              if (pin == null || pin.isEmpty) {
                                return 'Please enter a pincode';
                              }
                              if (pin.length != 6) {
                                return 'Pincode must have 6 digits';
                              }
                              return null;
                            },
                            onChanged: (pin) {
                              p = pin;
                              riderData.updatePincode(pin);
                            },
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            controller: _bankAccountController,
                            decoration: InputDecoration(
                              labelText: "Bank Account Number",
                            ),
                            validator: (ba) {
                              if (ba == null || ba.isEmpty) {
                                return 'Please enter a bank account number';
                              }
                              return null;
                            },
                            onChanged: (ba) {
                              bank = ba;
                              riderData.updateBankAccountNumber(ba);
                            },
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            controller: _ifscController,
                            decoration: InputDecoration(
                              labelText: "IFSC Number",
                            ),
                            validator: (ifsc) {
                              if (ifsc == null || ifsc.isEmpty) {
                                return 'Please enter an IFSC number';
                              }
                              return null;
                            },
                            onChanged: (ifsc) {
                              ifsccode = ifsc;
                              riderData.updateIfscNumber(ifsc);
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        width: 100.0,
                        height: 50,
                        child: FloatingActionButton(
                          onPressed: _isFormValid
                              ? () {
                                  _nameController.clear();
                                  _phoneNumberController.clear();
                                  _addressController.clear();
                                  _pincodeController.clear();
                                  _bankAccountController.clear();
                                  _ifscController.clear();

                                  // Navigate to the next screen i.e.(UploadDocumentsScreen)
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UploadDocumentsScreen(
                                        name: name,
                                        phoneNumber: phonenumber,
                                        localities: local,
                                        address: addr,
                                        pincode: p,
                                        bankAccountNumber: bank,
                                        ifscNumber: ifsccode,
                                      ),
                                    ),
                                  );
                                }
                              : null,
                          child: Text("Next"),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          backgroundColor:
                              _isFormValid ? Colors.blue : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
