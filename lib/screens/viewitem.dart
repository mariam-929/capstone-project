import 'package:firebase_auth101/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/button/gf_button_bar.dart';
import 'package:getwidget/components/carousel/gf_carousel.dart';
import 'package:getwidget/getwidget.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:flutter_icons/flutter_icons.dart';

class ViewItemPage extends StatefulWidget {
  final Map<String, dynamic> item;
  final String userID;
  final String postID;

  const ViewItemPage(
      {required this.item, required this.userID, required this.postID});

  @override
  _ViewItemPageState createState() => _ViewItemPageState();
}

class _ViewItemPageState extends State<ViewItemPage> {
  late Future<DocumentSnapshot> _postFuture;
  late Future<DocumentSnapshot> _userFuture;

  @override
  void initState() {
    super.initState();
    _postFuture =
        FirebaseFirestore.instance.collection('Posts').doc(widget.postID).get();
    _userFuture =
        FirebaseFirestore.instance.collection('Users').doc(widget.userID).get();
  }

  void _launchWhatsApp(String phoneNumber) async {
    String url = "https://wa.me/$phoneNumber";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchSMS(String phoneNumber) async {
    String url = "sms:$phoneNumber";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchDialer(String phoneNumber) async {
    String url = "tel:$phoneNumber";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _openMap(String address) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$address';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map';
    }
  }

  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _postFuture,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError || !snapshot.hasData) {
            return Text('Error: ${snapshot.error}');
          }

          Map<String, dynamic> data = snapshot.data!.exists
              ? snapshot.data!.data() as Map<String, dynamic>
              : {};

          return FutureBuilder<DocumentSnapshot>(
            future: _userFuture,
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.done) {
                if (userSnapshot.hasError || !userSnapshot.hasData) {
                  return Text('Error: ${userSnapshot.error}');
                }

                Map<String, dynamic> userData = userSnapshot.data!.exists
                    ? userSnapshot.data!.data() as Map<String, dynamic>
                    : {};
                String phoneNumber = userData['phoneNumber'];

                return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    leading: IconButton(
                      icon:
                          Icon(Icons.arrow_back_ios_sharp, color: Colors.black),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(' ${data['title']}',
                              style: TextStyle(
                                fontSize: 31,
                                fontWeight: FontWeight.w600,
                              )),
                          SizedBox(height: 10),
                          Text(
                            'Description: ${data['description']}',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () => _openMap(data['address']),
                            child: Text(
                              'Location: ${data['address']}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue,
                                  ),
                            ),
                          ),
                          SizedBox(height: 10),
                          GFCarousel(
                            hasPagination: true,
                            enlargeMainPage: true,
                            passiveIndicator: Colors.white,
                            activeIndicator: purple,
                            enableInfiniteScroll: false,
                            items: data['image_urls'].map<Widget>(
                              (url) {
                                return Container(
                                  width: MediaQuery.of(context)
                                      .size
                                      .width, // sets the width of the image to the screen width
                                  child: ClipRRect(
                                    child: Image.network(
                                      url,
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width,
                                      // sets the width of the image to the screen width
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                            onPageChanged: (index) {
                              setState(() {
                                index;
                              });
                            },
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Posted by: ${userData['fullname']}',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                      ),
                    ),
                  ),
                  bottomNavigationBar: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    height: 80,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 0.1,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GFButton(
                          //   padding: EdgeInsets.symmetric(horizontal: 10),
                          color: purple,
                          size: 46,
                          onPressed: () => _launchWhatsApp(phoneNumber),
                          text: "Whatsapp",
                          icon: Icon(
                            FontAwesomeIcons.whatsapp,
                            color: purple,
                          ),
                          type: GFButtonType.outline2x,
                        ),
                        GFButton(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          color: purple,
                          size: 46,
                          onPressed: () => _launchSMS(phoneNumber),
                          text: "Message",
                          icon: Icon(
                            Icons.sms,
                            color: purple,
                          ),
                          type: GFButtonType.outline2x,
                        ),
                        GFButton(
                          padding: EdgeInsets.symmetric(horizontal: 22),
                          color: purple,
                          size: 46,
                          onPressed: () => _launchDialer(phoneNumber),
                          text: "Dial",
                          icon: Icon(Icons.phone, color: Colors.white),
                          // type: GFButtonType.outline2x,
                        ),
                      ],
                    ),
                  ),
                );
              }
              // Show an empty container instead of CircularProgressIndicator
              return Container();
            },
          );
        }

        // Show an empty container instead of CircularProgressIndicator
        return Container();
      },
    );
  }
}
