import 'package:flutter/material.dart';

import '../../service/db_service.dart';
import '../../utils/form_validators.dart';

class UpdatePasswordPage extends StatefulWidget {
  @override
  _UpdatePasswordPageState createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  bool oldPasswordVisible = false;
  bool _showLoading = false;

  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  final TextEditingController _oldPasswordController = TextEditingController();

  FirestoreDbService _db = FirestoreDbService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Update Password',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: TextField(
                  controller: _oldPasswordController,
                  obscureText: !oldPasswordVisible,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    suffixIcon: GestureDetector(
                      child: Icon(
                        // Based on passwordVisible state choose the icon
                        oldPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.black,
                      ),
                      onTap: () {
                        // Update the state i.e. toggle the state of passwordVisible variable
                        setState(() {
                          oldPasswordVisible = !oldPasswordVisible;
                        });
                      },
                    ),
                    labelText: 'Current Password',
                    filled: true,
                    contentPadding: EdgeInsets.all(16),
                  )),
            ),
          ),
          //new password field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: TextField(
                  controller: _newPasswordController,
                  obscureText: !passwordVisible,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    suffixIcon: GestureDetector(
                      child: Icon(
                        /// Based on passwordVisible state choose the icon
                        passwordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.black,
                      ),
                      onTap: () {
                        /// Update the state i.e. toggle the state of passwordVisible variable
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    ),
                    labelText: 'New Password',
                    filled: true,
                    contentPadding: EdgeInsets.all(16),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: TextField(
                  controller: _confirmPasswordController,
                  obscureText: !confirmPasswordVisible,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    suffixIcon: GestureDetector(
                      child: Icon(
                        // Based on passwordVisible state choose the icon
                        confirmPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.black,
                      ),
                      onTap: () {
                        // Update the state i.e. toggle the state of passwordVisible variable
                        setState(() {
                          confirmPasswordVisible = !confirmPasswordVisible;
                        });
                      },
                    ),
                    labelText: 'Confirm Password',
                    filled: true,
                    contentPadding: EdgeInsets.all(16),
                  )),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: _showLoading
                ? CircularProgressIndicator()
                : OutlinedButton(
                    child: Text('Update'),
                    onPressed: () {
                      _validatePasswordAndUpdate();
                    },
                  ),
          )
        ],
      ),
    );
  }

  void _validatePasswordAndUpdate() async {
    setState(() {
      _showLoading = true;
    });
    if ((_confirmPasswordController.text.length > 0 &&
            _newPasswordController.text.length > 0) &&
        _newPasswordController.text == _confirmPasswordController.text) {
      String validatorString =
          validatePassword(_confirmPasswordController.text.trim());

      if (validatorString == null) {
        if (await _db.validateOldPassword(_oldPasswordController.text)) {
          bool passwordUpdated =
              await _db.changePassword(_confirmPasswordController.text);
          _oldPasswordController.clear();
          _newPasswordController.clear();
          _confirmPasswordController.clear();
          if (passwordUpdated) {
            setState(() {
              _showLoading = false;
            });
            Navigator.pop(context);
          }
        } else {
          setState(() {
            _showLoading = false;
          });
          showToastMessages('Check your current password once');
        }
      } else {
        setState(() {
          _showLoading = false;
        });
        showToastMessages(validatorString);
      }
    } else {
      setState(() {
        _showLoading = false;
      });
      showToastMessages('New and confirm password, didn\'t matched');
    }
  }
}
