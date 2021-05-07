import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

String validateEmail(String email) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (email.isEmpty) {
    return 'Please check your email';
  } else if (email.length > 60) {
    return 'Email entered is too lengthy';
  } else if (!regex.hasMatch(email)) {
    return 'Please enter proper email';
  } else {
    return null;
  }
}

String validatePassword(String password) {
  if (password.isEmpty) {
    return 'Please enter password';
  } else if (password.length < 6) {
    return 'Minimum 6 characters required';
  } else if (password.length > 20) {
    return 'Please enter less than 20 characters as password';
  } else {
    return null;
  }
}

void showErrorToast(String error) {
  if (error.contains('email address is badly formatted')) {
    error = 'Please check your email once';
  } else if (error
      .contains('no user record corresponding to this identifier')) {
    error = 'Please register to continue';
  } else if (error.contains('password is invalid')) {
    error = 'Please check your credentials';
  } else if (error
      .contains('email address is already in use by another account')) {
    error = 'Email already used, please login instead';
  } else if (error.contains(
      'PlatformException(ERROR_NETWORK_REQUEST_FAILED, A network error')) {
    error = 'Oops.. No Internet connection';
  } else {
    error = 'Oops.. Something went wrong';
  }
  showToastMessages(error);
}

void showToastMessages(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      fontSize: 16.0,
      backgroundColor: Colors.black,
      textColor: Colors.white);
}
