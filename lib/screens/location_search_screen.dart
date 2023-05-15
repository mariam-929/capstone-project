import 'package:flutter/material.dart';

import '../services/autocomplete_prediction.dart';
import '../services/network_utility.dart';
import '../services/place_auto_complete_response.dart';
import '../widgets/location_list_tile.dart';

class SearchLocationScreen extends StatefulWidget {
  const SearchLocationScreen({Key? key}) : super(key: key);

  @override
  State<SearchLocationScreen> createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  List<AutocompletePrediction> placePredictions = [];
  void placeAutocomplete(String query) async {
    Uri uri = Uri.https(
        "maps.googleapis.com",
        'maps/api/place/autocomplete/json',
        {"input": query, "key": 'AIzaSyALTElbx97xhLtJUMVlbKOUylKokr732RM'});

    String? response = await NetworkUtility.fetchUrl(uri);

    if (response != null) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parseAutocompleteResult(response);
      if (result.predictions != null) {
        setState(() {
          placePredictions = result.predictions!;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Padding(
        //   //padding: const EdgeInsets.only(left: defaultPadding),
        //   child: CircleAvatar(
        //       //backgroundColor: secondaryColor10LightTheme,
        //       // child: SvgPicture.asset(
        //       //   "assets/icons/location.svg",
        //       //   height: 16,
        //       //   width: 16,
        //       //   color: secondaryColor40LightTheme,
        //       // ),
        //       ),
        // ),
        title: const Text(
          "Set Delivery Location",
          //  style: TextStyle(color: textColorLightTheme),
        ),
        actions: [
          CircleAvatar(
            //  backgroundColor: secondaryColor10LightTheme,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.close, color: Colors.black),
            ),
          ),
          //  const SizedBox(width: defaultPadding)
        ],
      ),
      body: Column(
        children: [
          Form(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                onChanged: (value) {
                  placeAutocomplete(value);
                },
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: "Search your location",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    // child: SvgPicture.asset(
                    //   "assets/icons/location_pin.svg",
                    //   color: secondaryColor40LightTheme,
                    // ),
                  ),
                ),
              ),
            ),
          ),
          const Divider(
            height: 4,
            thickness: 4,
            //  color: secondaryColor5LightTheme,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Select Address'),
            ),
          ),
          const Divider(
            height: 4,
            thickness: 4,
            // color: secondaryColor5LightTheme,
          ),
          Expanded(
              child: ListView.builder(
            itemCount: placePredictions.length,
            itemBuilder: (context, index) => LocationListTile(
              press: () {},
              location: placePredictions[index].description!,
            ),
          ))
        ],
      ),
    );
  }
}
