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
  List<Item> _filteredItems = [];
  List<Item> items = [
    Item(
      id: '1',
      title: 'Hair',
      price: 15.0,
      imageUrl:
          'https://litb-cgis.rightinthebox.com/images/640x640/201912/hhsmxa1577242370688.jpg',
      description: 'Green cocktail vintage sleeveless dress, knee length',
    ),

    Item(
      id: '2',
      title: 'Jeans',
      price: 20.0,
      imageUrl:
          'https://img.abercrombie.com/is/image/anf/KIC_155-2645-2983-278_prod1?policy=product-medium',
      description: 'Women\s straight jeans',
    ),
    Item(
      id: '3',
      title: 'Hair Bow',
      price: 5.5,
      imageUrl:
          'https://litb-cgis.rightinthebox.com/images/640x640/202206/bps/product/inc/nxehbx1656497131020.jpg',
      description: 'Retro Vintage 1950s Headband Women. Red and white dotted',
    ),
    Item(
      id: '4',
      title: 'Gloves',
      price: 9.9,
      imageUrl:
          'https://litb-cgis.rightinthebox.com/images/640x640/202207/bps/product/inc/zijola1656992030186.jpg',
      description: 'The Great Gatsby 1950s Roaring 20s Gloves',
    ),
    // Add more items as needed
  ];

  @override
  // void initState() {
  //   super.initState();
  //   _filteredItems = items;
  // }

  // void _filterItems(String query) {
  //   if (query.isEmpty) {
  //     setState(() {
  //       _filteredItems = items;
  //     });
  //     return;
  //   }

  //   List<Item> filtered = items
  //       .where((item) => item.title.toLowerCase().contains(query.toLowerCase()))
  //       .toList();

  //   setState(() {
  //     _filteredItems = filtered;
  //   });
  // }

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
      body: ListView.separated(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return GFListTile(
            avatar: GFAvatar(
              backgroundImage: NetworkImage(items[index].imageUrl),
              shape: GFAvatarShape.square,
              radius: 70,
              borderRadius: BorderRadius.circular(15),
            ),
            title: GFTypography(
              child: Text(
                items[index].title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              showDivider: false,
            ),
            subTitle: GFTypography(
              child: Text(
                '\$${items[index].price}',
                style: TextStyle(
                  color: Color.fromARGB(255, 162, 162, 162),
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              showDivider: false,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemDetails(item: items[index]),
                ),
              );
            },
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
