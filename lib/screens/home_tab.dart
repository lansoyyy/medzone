import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medzone/screens/notif_page.dart';
import 'package:medzone/utils/colors.dart';
import 'package:medzone/widgets/text_widget.dart';
import 'package:intl/intl.dart' show DateFormat, toBeginningOfSentenceCase;

import 'doctor_profile_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final searchController = TextEditingController();
  String nameSearched = '';

  List<String> selectedStatus = [
    'All',
    'General',
    'Nutritionist',
    'Dentist',
    'Neurologist',
  ];

  String selectedChip = 'All';
  @override
  Widget build(BuildContext context) {
    print(selectedChip);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: 'Hello User!',
                          fontSize: 18,
                          fontFamily: 'Bold',
                        ),
                        TextWidget(
                          text: 'Keep taking care of your health',
                          fontSize: 10,
                          fontFamily: 'Regular',
                        ),
                      ],
                    ),
                    const Expanded(
                      child: SizedBox(),
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Bookings')
                            .where('status', isEqualTo: 'Completed')
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
                          return IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const NotifPage()));
                            },
                            icon: Badge(
                              label: TextWidget(
                                  text: data.docs.length.toString(),
                                  color: Colors.white,
                                  fontSize: 12),
                              child: const Icon(
                                Icons.notifications_sharp,
                              ),
                            ),
                          );
                        }),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(100)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: TextFormField(
                      style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Regular',
                          fontSize: 14),
                      onChanged: (value) {
                        setState(() {
                          nameSearched = value;
                        });
                      },
                      decoration: const InputDecoration(
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          hintText: 'Search',
                          hintStyle: TextStyle(fontFamily: 'QRegular'),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey,
                          )),
                      controller: searchController,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextWidget(
                  text: 'Popular doctors',
                  fontSize: 14,
                  fontFamily: 'Bold',
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: selectedStatus.map((String status) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedChip = status;
                            });

                            print('asdadsd');
                          },
                          child: FilterChip(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                              side: BorderSide(
                                color: selectedChip == status
                                    ? Colors.blue
                                    : Colors.transparent,
                                width: 2.0,
                              ),
                            ),
                            showCheckmark: false,
                            backgroundColor: const Color(0xFFC6C6C6),
                            disabledColor: Colors.grey,
                            selectedColor: Colors.blue,
                            label: Text(
                              status,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                            selected: selectedChip == status,
                            onSelected: (bool selected) {
                              print('asdadsd');
                              setState(() {
                                selectedChip = status;
                              });
                              // This can be an empty callback since we're handling onTap separately
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: selectedChip == 'All'
                        ? FirebaseFirestore.instance
                            .collection('Doctors')
                            .where('fname',
                                isGreaterThanOrEqualTo:
                                    toBeginningOfSentenceCase(nameSearched))
                            .where('fname',
                                isLessThan:
                                    '${toBeginningOfSentenceCase(nameSearched)}z')
                            .snapshots()
                        : FirebaseFirestore.instance
                            .collection('Doctors')
                            .where('type', isEqualTo: selectedChip)
                            .where('fname',
                                isGreaterThanOrEqualTo:
                                    toBeginningOfSentenceCase(nameSearched))
                            .where('fname',
                                isLessThan:
                                    '${toBeginningOfSentenceCase(nameSearched)}z')
                            .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        print(snapshot.error);
                        return const Center(child: Text('Error'));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 50),
                          child: Center(
                              child: CircularProgressIndicator(
                            color: Colors.black,
                          )),
                        );
                      }

                      final data = snapshot.requireData;
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (int i = 0; i < data.docs.length; i++)
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, right: 5),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DoctorProfileScreen(
                                                  id: data.docs[i].id,
                                                )));
                                  },
                                  child: Container(
                                    height: 175,
                                    width: 125,
                                    decoration: BoxDecoration(
                                      color: primary.withOpacity(0.25),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          child: CircleAvatar(
                                            minRadius: 35,
                                            maxRadius: 35,
                                            backgroundImage: NetworkImage(
                                                data.docs[i]['profilePicture']),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        TextWidget(
                                          text: '☆ ${data.docs[i]['stars']}',
                                          fontSize: 10,
                                          color: Colors.black,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        TextWidget(
                                          text:
                                              'Dr. ${data.docs[i]['fname']}  ${data.docs[i]['lname']}',
                                          fontSize: 12,
                                          fontFamily: 'Bold',
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        TextWidget(
                                          text: '${data.docs[i]['type']}',
                                          fontSize: 12,
                                          fontFamily: 'Medium',
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                const SizedBox(
                  height: 20,
                ),
                TextWidget(
                  text: 'Upcoming Appointments',
                  fontSize: 14,
                  fontFamily: 'Bold',
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Bookings')
                        .where('status', isEqualTo: 'Pending')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        print(snapshot.error);
                        return const Center(child: Text('Error'));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 50),
                          child: Center(
                              child: CircularProgressIndicator(
                            color: Colors.black,
                          )),
                        );
                      }

                      final data = snapshot.requireData;
                      return SizedBox(
                        height: 300,
                        child: ListView.builder(
                          itemCount: data.docs.length,
                          itemBuilder: (context, index) {
                            return StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('Doctors')
                                    .doc(data.docs[index]['doctorid'])
                                    .snapshots(),
                                builder: (context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return const SizedBox();
                                  } else if (snapshot.hasError) {
                                    return const Center(
                                        child: Text('Something went wrong'));
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
                                        color: primary.withOpacity(0.25),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            child: CircleAvatar(
                                              minRadius: 50,
                                              maxRadius: 50,
                                              backgroundImage: NetworkImage(
                                                  doctor['profilePicture']),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 30,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              TextWidget(
                                                text:
                                                    'Dr. ${doctor['fname']}  ${doctor['lname']}',
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
                                });
                          },
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
