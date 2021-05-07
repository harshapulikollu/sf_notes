import 'package:flutter/material.dart';
import 'package:sf_notes/auth/auth.dart';
import 'package:sf_notes/pages/profile/update_password_page.dart';

class ProfileDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Profile details',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        ListTile(
          title: Text(loggedInUser.displayName),
          subtitle: Text(loggedInUser.email),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: OutlinedButton(
            child: Text('update password'),
            onPressed: () {
              ///closing the Bottom sheet before opening the update password page
              Navigator.pop(context);

              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return UpdatePasswordPage();
              }));
            },
          ),
        ),
      ],
    );
  }
}
