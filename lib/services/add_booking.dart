import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addBooking(myname, date, time, gender, age, problem, doctorid) async {
  final docUser = FirebaseFirestore.instance.collection('Bookings').doc();

  final json = {
    'myname': myname,
    'date': date,
    'time': time,
    'gender': gender,
    'age': age,
    'problem': problem,
    'doctorid': doctorid,
    'id': docUser.id,
    'userId': FirebaseAuth.instance.currentUser!.uid,
    'status': 'Pending',
    'dateTime': DateTime.now(),
  };

  await docUser.set(json);
}
