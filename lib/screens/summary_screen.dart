import 'package:flutter/material.dart';
import 'package:medzone/screens/home_screen.dart';
import 'package:medzone/services/add_booking.dart';
import 'package:medzone/widgets/button_widget.dart';
import 'package:medzone/widgets/text_widget.dart';
import 'package:medzone/widgets/toast_widget.dart';

class SummaryScreen extends StatefulWidget {
  var doctor;

  String name;
  String gender;
  String age;
  String problem;
  String date;
  String time;

  SummaryScreen(
      {super.key,
      required this.doctor,
      required this.name,
      required this.gender,
      required this.age,
      required this.problem,
      required this.date,
      required this.time});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                      text:
                          'Dr. ${widget.doctor['fname']} ${widget.doctor['lname']}',
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
                    height: 125,
                    width: 400,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.network(
                          widget.doctor['profilePicture'],
                          height: 100,
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
                                  'Dr. ${widget.doctor['fname']} ${widget.doctor['lname']}',
                              fontSize: 14,
                              fontFamily: 'Bold',
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextWidget(
                              text: widget.doctor['type'],
                              fontSize: 12,
                              fontFamily: 'Regular',
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
                Card(
                  child: SizedBox(
                    height: 175,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextWidget(
                                text: 'Date and Hour',
                                fontSize: 12,
                              ),
                              TextWidget(
                                text: '${widget.date} | ${widget.time}',
                                fontSize: 12,
                                fontFamily: 'Bold',
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextWidget(
                                text: 'Service',
                                fontSize: 12,
                              ),
                              TextWidget(
                                text: 'Chat',
                                fontSize: 12,
                                fontFamily: 'Bold',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: ButtonWidget(
                    radius: 100,
                    label: 'Confirm',
                    onPressed: () {
                      showToast('You have successfully booked a consultation!');

                      addBooking(
                          widget.name,
                          widget.date,
                          widget.time,
                          widget.gender,
                          widget.age,
                          widget.problem,
                          widget.doctor.id);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const HomeScreen()));
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
      ),
    );
  }
}
