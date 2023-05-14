import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../constraints/items.dart';
import '../widgets/HomeBottomBar.dart';
import 'itemDetails.dart';
import 'package:getwidget/getwidget.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ItemListing extends StatefulWidget {
  @override
  _ItemListingState createState() => _ItemListingState();
}

class _ItemListingState extends State<ItemListing> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 155, 22, 175),
        automaticallyImplyLeading: false,
        title: TextField(
          controller: _searchController,
          onChanged: (value) {
            // Add search functionality here
            //_filterItems(value);
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Posts').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView.separated(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var item = snapshot.data!.docs[index];
              return GFCard(
                boxFit: BoxFit.cover,
                titlePosition: GFPosition.start,
                image: Image.network(
                  item['image_urls'][0],
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
                showImage: true,
                title: GFListTile(
                  titleText: item['title'],
                  subTitleText: "by ${item['full_name']}",
                ),
                content: Text("Some quick example text to build on the card"),
                buttonBar: GFButtonBar(
                  children: <Widget>[
                    GFAvatar(
                      backgroundColor: GFColors.PRIMARY,
                      child: Icon(
                        Icons.share,
                        color: Colors.white,
                      ),
                    ),
                    GFAvatar(
                      backgroundColor: GFColors.SECONDARY,
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                    GFAvatar(
                      backgroundColor: GFColors.SUCCESS,
                      child: Icon(
                        Icons.phone,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                thickness: 0,
              );
            },
          );
        },
      ),
     
      bottomNavigationBar: HomeBottomBar(),
    );
  }
}
