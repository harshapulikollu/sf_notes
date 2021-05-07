# sf_notes

A note taking application developed using flutter developed by Harsha Pulikollu.

## Checklist

[X] Users can login/SingUp using email or google auth. (Email auth implemented)
[X] Save data to Firebase DB(Firestore). Saves both user data and user notes.
[X] Users can change password.
[X] Password was hashed.
[X] User can create note and add text and/or image.
[X] List Notes with title and 2 line content if text.
[X] Detail page for note.
[X] Note should be editable.
[X] User should able to see, edit and create new note even when there is no internet (Data should be synced when there is internet).

## Usage

- Sign up/login into app using email and password.
- Click on profile/user icon on top left to get loggedIn user details and button to update password.
- Click on red color power/SignOut button on top right, to signOut from the app.

Add new note: 
- Click on FAB with + icon to add new notes.
- In Note detail page, add title, description of note.
- Click on Image/photo icon on add a image to the note.
- Once done, click on save/floppy icon to add the note.

Update a note:
- Click on a note from a list of notes in homepage.
- In Note detail page, update the note content.
- Once done, click on save/floppy icon to update the note.

Delete the note:
- A note can be deleted in two ways
- Either swipe left on a note in homepage and click delete icon.
- Click on a note you wanted to delete and go into detailed note page, now on tte.op right click on red color trash/bin icon to delete a no


While offline, notes with images won't be synced if the app is terminated.