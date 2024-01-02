import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:medzone/widgets/text_widget.dart';

import '../utils/colors.dart';

class AppointmentsTab extends StatefulWidget {
  const AppointmentsTab({super.key});

  @override
  State<AppointmentsTab> createState() => _AppointmentsTabState();
}

class _AppointmentsTabState extends State<AppointmentsTab> {
  double rating = 0.0;
  TextEditingController reviewController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: 'Appointments',
                      fontSize: 24,
                      fontFamily: 'Bold',
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const TabBar(
                  tabs: [
                    Tab(
                      text: 'Upcoming',
                    ),
                    Tab(
                      text: 'Completed',
                    ),
                    Tab(
                      text: 'Cancelled',
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 500,
                  child: TabBarView(
                    children: [
                      for (int i = 0; i < 3; i++)
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('Bookings')
                                .where('status',
                                    isEqualTo: i == 0
                                        ? 'Pending'
                                        : i == 1
                                            ? 'Completed'
                                            : 'Cancelled')
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                print(snapshot.error);
                                return const Center(child: Text('Error'));
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Padding(
                                  padding: EdgeInsets.only(top: 50),
                                  child: Center(
                                      child: CircularProgressIndicator(
                                    color: Colors.black,
                                  )),
                                );
                              }

                              final data = snapshot.requireData;
                              return ListView.builder(
                                itemCount: data.docs.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      if (i == 1) {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title:
                                                    const Text('Rate doctor'),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    RatingBar.builder(
                                                      initialRating: rating,
                                                      minRating: 1,
                                                      direction:
                                                          Axis.horizontal,
                                                      allowHalfRating: true,
                                                      itemCount: 5,
                                                      itemSize: 40,
                                                      itemBuilder:
                                                          (context, _) =>
                                                              const Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                      onRatingUpdate: (value) {
                                                        setState(() {
                                                          rating = value;
                                                        });
                                                      },
                                                    ),
                                                    const SizedBox(height: 20),
                                                    TextField(
                                                      controller:
                                                          reviewController,
                                                      maxLines: 3,
                                                      decoration:
                                                          const InputDecoration(
                                                        labelText:
                                                            'Write your review',
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(); // Close the dialog
                                                    },
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('Doctors')
                                                          .doc(data.docs[index]
                                                              ['doctorid'])
                                                          .update({
                                                        "stars": FieldValue
                                                            .increment(rating),
                                                        'reviewers': FieldValue
                                                            .arrayUnion([
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid
                                                        ]),
                                                        'reviews': FieldValue
                                                            .arrayUnion([
                                                          {
                                                            'myid': FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid,
                                                            'comment':
                                                                reviewController
                                                                    .text,
                                                            'stars': rating
                                                          }
                                                        ]),
                                                      });

                                                      Navigator.of(context)
                                                          .pop(); // Close the dialog
                                                    },
                                                    child: const Text('Submit'),
                                                  ),
                                                ],
                                              );
                                            });
                                      }
                                    },
                                    child: StreamBuilder<DocumentSnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('Doctors')
                                            .doc(data.docs[index]['doctorid'])
                                            .snapshots(),
                                        builder: (context,
                                            AsyncSnapshot<DocumentSnapshot>
                                                snapshot) {
                                          if (!snapshot.hasData) {
                                            return const SizedBox();
                                          } else if (snapshot.hasError) {
                                            return const Center(
                                                child: Text(
                                                    'Something went wrong'));
                                          } else if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const SizedBox();
                                          }
                                          dynamic doctor = snapshot.data;
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10, bottom: 10),
                                            child: Container(
                                              height: 150,
                                              width: 125,
                                              decoration: BoxDecoration(
                                                color:
                                                    primary.withOpacity(0.25),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Image.network(
                                                    doctor['profilePicture'],
                                                    height: 100,
                                                  ),
                                                  const SizedBox(
                                                    width: 30,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      TextWidget(
                                                        text:
                                                            'Dr. ${doctor['fname']} ${doctor['mname'][0]}. ${doctor['lname']}',
                                                        fontSize: 14,
                                                        fontFamily: 'Bold',
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      TextWidget(
                                                        text: doctor['type'],
                                                        fontSize: 12,
                                                        fontFamily: 'Regular',
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      TextWidget(
                                                        text:
                                                            '${data.docs[index]['date']} || ${data.docs[index]['time']}',
                                                        fontSize: 12,
                                                        fontFamily: 'Medium',
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  );
                                },
                              );
                            }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
