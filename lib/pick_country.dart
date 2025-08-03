import 'package:flutter/material.dart';
import 'package:pick_country/src/country_helpers.dart';

class PickCountry {
  static Future<String?> sheet(BuildContext context) async {
    return await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (_) => const CountryPickerSheet(),
    );
  }

  static Future<String?> dialog(BuildContext context) async {
    return await showDialog<String>(
      context: context,
      builder: (_) => const CountryPickerDialog(),
    );
  }
}
