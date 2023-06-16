import 'package:flutter/foundation.dart';
import 'dart:io';

class RiderData extends ChangeNotifier {
  String _name = '';
  String _phoneNumber = '';
  List<String> _localities = [];
  String _address = '';
  String _pincode = '';
  String _bankAccountNumber = '';
  String _ifscNumber = '';

  String get name => _name;
  String get phoneNumber => _phoneNumber;
  List<String> get localities => _localities;
  String get address => _address;
  String get pincode => _pincode;
  String get bankAccountNumber => _bankAccountNumber;
  String get ifscNumber => _ifscNumber;

  Map<String, File> documentImages = {};

  void updateName(String nm) {
    _name = nm;
    notifyListeners();
  }

  void updatePhoneNumber(String pn) {
    _phoneNumber = pn;
    notifyListeners();
  }

  void updateLocalities(List<String> loc) {
    _localities = loc;
    notifyListeners();
  }

  void updateAddress(String ad) {
    _address = ad;
    notifyListeners();
  }

  void updatePincode(String pin) {
    _pincode = pin;
    notifyListeners();
  }

  void updateBankAccountNumber(String ba) {
    _bankAccountNumber = ba;
    notifyListeners();
  }

  void updateIfscNumber(String ifsc) {
    _ifscNumber = ifsc;
    notifyListeners();
  }

  void addDocumentImage(String document, File file) {
    documentImages[document] = file;
    notifyListeners();
  }

  void removeDocumentImage(String document) {
    documentImages.remove(document);
    notifyListeners();
  }

  void addNameToRidersList(List<String> riders) {
    riders.add(_name);
  }
}
