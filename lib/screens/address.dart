import 'package:firebase_auth101/services/autocomplete_prediction.dart';
import 'package:firebase_auth101/services/network_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/place_auto_complete_response.dart';

class Addressing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Address Picker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AddressPicker(),
    );
  }
}

class AddressPicker extends StatefulWidget {
  const AddressPicker({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddressPickerState createState() => _AddressPickerState();
}

class _AddressPickerState extends State<AddressPicker> {
  final _places = GoogleMapsPlaces(
      apiKey:
          'AIzaSyALTElbx97xhLtJUMVlbKOUylKokr732RM'); // Replace with your Google Maps API Key

  String? _selectedAddress;

  void _selectAddress(String query) async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey:
          'AIzaSyALTElbx97xhLtJUMVlbKOUylKokr732RM', // Replace with your Google Maps API Key
      mode: Mode.fullscreen, // Display the autocomplete widget as fullscreen
    );

    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId!);

      setState(() {
        _selectedAddress = detail.result.formattedAddress;
      });

      // Save the address to Firebase
      CollectionReference addresses =
          FirebaseFirestore.instance.collection('addresses');
      addresses.add({
        'address': _selectedAddress,
      });
    }
  }

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
        title: Text('Address Picker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _selectedAddress ?? 'No address selected',
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Select Address'),
            ),
          ],
        ),
      ),
    );
  }
}
