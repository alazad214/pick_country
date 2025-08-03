# pick_country

A simple and customizable Flutter package to display a country picker with flag emojis, either in a dialog or a draggable bottom sheet. It includes a search feature for easy filtering.


![](https://raw.githubusercontent.com/alazad214/pick_country/refs/heads/main/banner.png)


## 🚀 Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  pick_country: <latest_version>
```

Then run:

```bash
flutter pub get
```

## 📦 Import

```dart
import 'package:pick_country/pick_country.dart';
```

## 💡 Usage Example

The package provides a static helper class `PickCountry` with two main methods to show the country picker.

### Showing the Country Picker as a Bottom Sheet

```dart
ElevatedButton.icon(
  onPressed: () async {
    final result = await PickCountry.sheet(context);
    if (result != null) {
      // Do something with the selected country name, e.g., update UI state
      print('Selected country from sheet: $result');
    }
  },
  icon: const Icon(Icons.public),
  label: const Text('Tap from sheet'),
)
```

### Showing the Country Picker as a Dialog

```dart
ElevatedButton.icon(
  onPressed: () async {
    final result = await PickCountry.dialog(context);
    if (result != null) {
      // Do something with the selected country name, e.g., update UI state
      print('Selected country from dialog: $result');
    }
  },
  icon: const Icon(Icons.public),
  label: const Text('Tap from dialog'),
)


## 🛠 Customization

The `CountryPickerDialog` and `CountryPickerSheet` widgets are built to be responsive and include a search bar and a list grouped by the first letter of the country name. You can customize the styling of these widgets by modifying the source files directly.
