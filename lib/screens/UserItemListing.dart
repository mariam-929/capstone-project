import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth101/screens/viewitem.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../constraints/items.dart';
import '../widgets/HomeBottomBar.dart';

import 'itemDetails.dart';
import 'package:getwidget/getwidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'location_search_screen.dart';
import 'package:intl/intl.dart'; // Add this line
import 'package:firebase_storage/firebase_storage.dart';

class UserItemListing extends StatefulWidget {
  @override
  _ItemListingState createState() => _ItemListingState();
}

class _ItemListingState extends State<UserItemListing> {
  TextEditingController _searchController = TextEditingController();
  String title = "";
  String selectedCategory = 'All';
  String _locationText = '';
  String FULLNAME = '';
  String selectedDateFilter =
      'Newest to Oldest'; // Default value for the date filter
  List<String> categories = ['All', 'Category 1', 'Category 2', 'Category 3'];
  List<String> dateFilters = ['Newest to Oldest', 'Oldest to Newest'];

  Future<String?> getUserImageUrl(String userID) async {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('Users').doc(userID).get();

    if (userSnapshot.exists) {
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      return userData['imageUrl'];
    }

    return null;
  }

  Future<String?> getUserFullName(String userID) async {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('Users').doc(userID).get();

    if (userSnapshot.exists) {
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      return userData['fullname'];
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 155, 22, 175),
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            FutureBuilder<String?>(
              future: getUserFullName(FirebaseAuth.instance.currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  FULLNAME = snapshot.data!;
                  // Do any additional processing or operations with the fullName variable if needed
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                return const SizedBox
                    .shrink(); // Return an empty widget or null
              },
            ),
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    title = value;
                  });
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search...",
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 30,
                    color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly, // adjust this as needed
            children: categories.map((String value) {
              return TextButton(
                onPressed: () {
                  setState(() {
                    selectedCategory = value;
                  });
                },
                child: Text(
                  value,
                  style: TextStyle(
                    color: selectedCategory == value
                        ? Color.fromARGB(255, 190, 135, 242)
                        : Colors.black, // Highlights the selected category
                  ),
                ),
              );
            }).toList(),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    height: 65,
                    child: ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchLocationScreen()),
                        );
                        if (result != null) {
                          setState(() {
                            _locationText = result;
                          });
                        }
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color.fromARGB(255, 237, 235, 235),
                                  width: 1.5,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    _locationText.isEmpty
                                        ? "Location"
                                        : _locationText,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(
                                  Icons.location_pin,
                                  color: Colors.black,
                                  size: 22,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                            side: BorderSide(
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 255, 255, 255)),
                        elevation: MaterialStateProperty.all<double>(0),
                      ),
                    ),
                  ),
                  DropdownButton<String>(
                    value: selectedDateFilter,
                    icon: Icon(
                      Icons.date_range,
                      size: 22,
                    ),
                    items: dateFilters.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                            style: TextStyle(
                              fontSize: 15,
                            )),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDateFilter = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Posts')
                  .where('id',
                      isEqualTo: FirebaseAuth.instance.currentUser!
                          .uid) // Filter by current user ID
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }
                List<DocumentSnapshot> docs = snapshot.data!.docs;
                if (selectedDateFilter == 'Newest to Oldest') {
                  docs.sort((a, b) {
                    Timestamp aTime = a['date'];
                    Timestamp bTime = b['date'];
                    return bTime.compareTo(aTime);
                  });
                } else {
                  docs.sort((a, b) {
                    Timestamp aTime = a['date'];
                    Timestamp bTime = b['date'];
                    return aTime.compareTo(bTime);
                  });
                }
                return ListView.separated(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var item = docs[index].data() as Map<String, dynamic>;
                    String userID = item['id'];
                    bool shouldDisplay = (title.isEmpty ||
                            item['title']
                                .toString()
                                .toLowerCase()
                                .contains(title.toLowerCase())) &&
                        (selectedCategory == 'All' ||
                            item['category'].toString() == selectedCategory) &&
                        (_locationText.isEmpty ||
                            item['address'].toString() == _locationText);

                    if (shouldDisplay) {
                      DateTime date = item['date']
                          .toDate(); // Convert Timestamp to DateTime
                      String formattedDate =
                          DateFormat('MMMM d').format(date); // Format the date

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewItemPage(
                                  item: item,
                                  userID: item['id'],
                                  postID: docs[index].id),
                            ),
                          );
                        },
                        child: FutureBuilder<String?>(
                          future: getUserImageUrl(userID),
                          builder: (BuildContext context,
                              AsyncSnapshot<String?> snapshot) {
                            if (snapshot.hasError || !snapshot.hasData) {
                              return Container();
                            }

                            String imageUrl = snapshot.data!;
                            return GFCard(
                              boxFit: BoxFit.cover,
                              titlePosition: GFPosition.start,
                              image: Image.network(
                                item['image_urls'][0],
                                height:
                                    MediaQuery.of(context).size.height * 0.35,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                              ),
                              showImage: true,
                              title: GFListTile(
                                avatar: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      imageUrl), // Set the user's profile picture
                                ),
                                title: Text(item['title'],
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500)),
                                subTitle: Text("by ${item['full_name']}"),
                              ),
                              buttonBar: GFButtonBar(
                                children: <Widget>[
                                  GFListTile(
                                    avatar: GFAvatar(
                                      shape: GFAvatarShape.circle,
                                      backgroundImage: AssetImage(
                                        'assets/location (2).png',
                                      ),
                                      backgroundColor: Colors.transparent,
                                      radius: 13,
                                    ),
                                    title: Text(item['address']),
                                    subTitle: Text(
                                      formattedDate,
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      thickness: 0,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: HomeBottomBar(),
    );
  }
}
