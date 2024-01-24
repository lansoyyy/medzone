import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medzone/screens/book_screen.dart';
import 'package:medzone/utils/colors.dart';
import 'package:medzone/widgets/button_widget.dart';
import 'package:medzone/widgets/text_widget.dart';

class DoctorProfileScreen extends StatefulWidget {
  String id;

  DoctorProfileScreen({super.key, required this.id});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> userData = FirebaseFirestore.instance
        .collection('Doctors')
        .doc(widget.id)
        .snapshots();
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
          stream: userData,
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox();
            }
            dynamic data = snapshot.data;
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                            ),
                          ),
                          TextWidget(
                            text: 'Dr. ${data['fname']}  ${data['lname']}',
                            fontSize: 16,
                            fontFamily: 'Bold',
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Card(
                        child: SizedBox(
                          height: 150,
                          width: 400,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.network(
                                data['profilePicture'],
                                width: 75,
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextWidget(
                                    text:
                                        'Dr. ${data['fname']}  ${data['lname']}',
                                    fontSize: 14,
                                    fontFamily: 'Bold',
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  TextWidget(
                                    text: '${data['type']}',
                                    fontSize: 12,
                                    fontFamily: 'Regular',
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: primary.withOpacity(0.1),
                                ),
                                child: Icon(
                                  Icons.star,
                                  color: primary,
                                ),
                              ),
                              const SizedBox(
                                height: 2.5,
                              ),
                              TextWidget(
                                text: double.parse(
                                        (data['stars'] / data['reviews'].length)
                                            .toString())
                                    .toStringAsFixed(2),
                                fontSize: 14,
                                fontFamily: 'Bold',
                              ),
                              const SizedBox(
                                height: 2.5,
                              ),
                              TextWidget(
                                text: 'Ratings',
                                fontSize: 10,
                                fontFamily: 'Regular',
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: primary.withOpacity(0.1),
                                ),
                                child: Icon(
                                  Icons.rate_review,
                                  color: primary,
                                ),
                              ),
                              const SizedBox(
                                height: 2.5,
                              ),
                              TextWidget(
                                text: data['reviews'].length.toString(),
                                fontSize: 14,
                                fontFamily: 'Bold',
                              ),
                              const SizedBox(
                                height: 2.5,
                              ),
                              TextWidget(
                                text: 'Reviews',
                                fontSize: 10,
                                fontFamily: 'Regular',
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextWidget(
                        text: 'About Me',
                        fontSize: 18,
                        fontFamily: 'Bold',
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextWidget(
                        align: TextAlign.start,
                        text: data['aboutme'],
                        fontSize: 12,
                        fontFamily: 'Regular',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextWidget(
                        text: 'Reviews',
                        fontSize: 18,
                        fontFamily: 'Bold',
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 200,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              for (int i = 0; i < data['reviews'].length; i++)
                                StreamBuilder<DocumentSnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('Users')
                                        .doc(data['reviews'][i]['myid'])
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<DocumentSnapshot>
                                            snapshot) {
                                      if (!snapshot.hasData) {
                                        return const SizedBox();
                                      } else if (snapshot.hasError) {
                                        return const Center(
                                            child:
                                                Text('Something went wrong'));
                                      } else if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const SizedBox();
                                      }
                                      dynamic users = snapshot.data;
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                child: CircleAvatar(
                                                  minRadius: 75,
                                                  maxRadius: 75,
                                                  backgroundImage: NetworkImage(
                                                      users['profilePicture']),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              TextWidget(
                                                text:
                                                    '${users['fname']}  ${users['lname']}',
                                                fontSize: 14,
                                                fontFamily: 'Bold',
                                              ),
                                              const Expanded(
                                                child: SizedBox(
                                                  width: 20,
                                                ),
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    height: 50,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: primary
                                                          .withOpacity(0.1),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3.0),
                                                      child: Column(
                                                        children: [
                                                          Icon(
                                                            Icons.star,
                                                            color: primary,
                                                          ),
                                                          TextWidget(
                                                            text:
                                                                data['reviews']
                                                                            [i][
                                                                        'stars']
                                                                    .toString(),
                                                            fontSize: 12,
                                                            fontFamily: 'Bold',
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          TextWidget(
                                            align: TextAlign.start,
                                            text: data['reviews'][i]['comment'],
                                            fontSize: 12,
                                            fontFamily: 'Regular',
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Divider(
                                            color: Colors.grey,
                                            thickness: 0.5,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                        ],
                                      );
                                    }),
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: ButtonWidget(
                          radius: 100,
                          label: 'Book an Appointment',
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => BookScreen(
                                      doctor: data,
                                    )));
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
