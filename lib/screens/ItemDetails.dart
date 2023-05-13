import 'package:flutter/material.dart';

import '../constraints/items.dart';

class ItemDetails extends StatelessWidget {
  final Item item;

  ItemDetails({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
        backgroundColor: Color.fromARGB(255, 155, 22, 175),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(item.imageUrl, width: double.infinity),
            SizedBox(height: 0),
            Padding(
              padding:
                  const EdgeInsets.only(left: 15, bottom: 0, right: 0, top: 10),
              child: Text(
                item.title,
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Raleway',
                    color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding:
                  const EdgeInsets.only(left: 15, bottom: 0, right: 0, top: 0),
              child: Text('USD ${item.price}', style: TextStyle(fontSize: 19)),
            ),
            SizedBox(height: 10),
            Padding(
              padding:
                  const EdgeInsets.only(left: 15, bottom: 0, right: 0, top: 10),
              child: Text(
                'Description',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding:
                  const EdgeInsets.only(left: 15, bottom: 20, right: 0, top: 0),
              child: Text(
                item.description,
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
