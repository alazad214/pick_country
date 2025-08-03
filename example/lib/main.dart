import 'package:flutter/material.dart';
import 'package:pick_country/pick_country.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Pick Country',
        debugShowCheckedModeBanner: false,
        home: CountryExampleScreen());
  }
}

class CountryExampleScreen extends StatefulWidget {
  const CountryExampleScreen({super.key});

  @override
  CountryExampleScreenState createState() => CountryExampleScreenState();
}

class CountryExampleScreenState extends State<CountryExampleScreen> {
  String? countryNameBySheet;
  String? countryNameByDialog;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Country Sheet--->>
              ElevatedButton.icon(
                onPressed: () async {
                  final result = await PickCountry.sheet(context);
                  if (result != null) {
                    setState(() => countryNameBySheet = result);
                  }
                },
                icon: const Icon(Icons.public),
                label: Text(countryNameBySheet ?? 'Tap from sheet'),
              ),

              //Country Dialog--->>
              ElevatedButton.icon(
                onPressed: () async {
                  final result = await PickCountry.dialog(context);
                  if (result != null) {
                    setState(() => countryNameByDialog = result);
                  }
                },
                icon: const Icon(Icons.public),
                label: Text(countryNameByDialog ?? 'Tap from dialog'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
