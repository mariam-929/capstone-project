import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../constraints/items.dart';
import '../widgets/HomeBottomBar.dart';
import 'itemDetails.dart';

import 'package:getwidget/getwidget.dart';
import 'package:cached_network_image/cached_network_image.dart';

class lostFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        itemCount: 2,
        itemBuilder: (context, index) {
          return const GFCard(
            color: Color.fromARGB(255, 209, 185, 250),
             borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(15),
                    right: Radius.circular(30),
                  ),
            height: 210,
            //boxFit: BoxFit.cover,
            titlePosition: GFPosition.start,
            //showOverlayImage: true,
            title: GFListTile(
              avatar: GFAvatar(
                backgroundImage: AssetImage('assets/lost-and-found.png'),
                
                shape: GFAvatarShape.square,
                backgroundColor: Color.fromARGB(255, 209, 185, 250),
              ),
              titleText: 'Lost',
              subTitleText: 'PlayStation 4',
            ),
            content: Text("Some quick example text to build on the card"),
            buttonBar: GFButtonBar(
              children: <Widget>[
             
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            thickness: 0,
          );
        },
      ),
      bottomNavigationBar: HomeBottomBar(),
    );
  }
}
