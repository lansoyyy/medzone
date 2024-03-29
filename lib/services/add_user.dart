import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addUser(email, fname, mname, lname, nname, suffix, bday, sex, gender,
    profilePicture, number) async {
  final docUser = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  final json = {
    'email': email,
    'fname': fname,
    'mname': mname,
    'lname': lname,
    'nname': nname,
    'suffix': suffix,
    'bday': bday,
    'sex': sex,
    'gender': gender,
    'number': number,
    'profilePicture': profilePicture == ''
        ? 'https://cdn-icons-png.flaticon.com/256/149/149071.png'
        : profilePicture,
    'status': 'Active',
    'userId': FirebaseAuth.instance.currentUser!.uid,
    'type': 'User',
  };

  await docUser.set(json);
}
