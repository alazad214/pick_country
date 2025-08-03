import 'package:flutter/material.dart';

import 'country_list.dart';

///Country Model--->>
class Country {
  final String name;
  final String iso;
  final String flagEmoji;

  Country({required this.name, required this.iso})
      : flagEmoji = _emojiFlagFromIso(iso);

  /// Flag emoji created--->>>
  static String _emojiFlagFromIso(String isoAlpha2) {
    final int base = 0x1F1E6;
    return isoAlpha2
        .toUpperCase()
        .codeUnits
        .map((c) => String.fromCharCode(base + c - 0x41))
        .join();
  }
}

///Country Picker With Dialog--->>>
class CountryPickerDialog extends StatefulWidget {
  const CountryPickerDialog({super.key});

  @override
  State<CountryPickerDialog> createState() => _CountryPickerDialogState();
}

class _CountryPickerDialogState extends State<CountryPickerDialog> {
  late List<Country> _filtered;
  late Map<String, List<Country>> _groups;
  late List<String> _letters;
  final TextEditingController _searchCtrl = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _filtered = List.from(allCountries)
      ..sort((a, b) => a.name.compareTo(b.name));
    _recomputeGroups();
  }

  void _recomputeGroups() {
    _groups = {};
    for (final country in _filtered) {
      final lk = country.name[0].toUpperCase();
      _groups.putIfAbsent(lk, () => []).add(country);
    }
    _letters = _groups.keys.toList()..sort();
  }

  void _onSearch(String q) {
    setState(() {
      _filtered = allCountries
          .where(
            (c) =>
                c.name.toLowerCase().contains(q.toLowerCase()) ||
                c.iso.toLowerCase().contains(q.toLowerCase()),
          )
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name));
      _recomputeGroups();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(12),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 50,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchCtrl,
                onChanged: _onSearch,
                decoration: InputDecoration(
                  hintText: 'Search country name',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchCtrl.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchCtrl.clear();
                            _onSearch('');
                          },
                        ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _calculateTotalItemCount(),
                itemBuilder: (context, index) {
                  var currentIndex = 0;
                  for (final letter in _letters) {
                    final countries = _groups[letter]!;
                    if (index == currentIndex) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 6,
                        ),
                        child: Text(
                          letter,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                    currentIndex++;

                    for (final country in countries) {
                      if (index == currentIndex) {
                        return InkWell(
                          onTap: () => Navigator.pop(context, country.name),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  country.flagEmoji,
                                  style: const TextStyle(fontSize: 24),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    country.name,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                Text(
                                  country.iso,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      currentIndex++;
                    }
                  }
                  return const SizedBox.shrink(); // fallback
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _calculateTotalItemCount() {
    int count = 0;
    for (final letter in _letters) {
      count += 1;
      count += _groups[letter]!.length;
    }
    return count;
  }
}

///Country Picker With Sheet--->>>
class CountryPickerSheet extends StatefulWidget {
  const CountryPickerSheet({super.key});

  @override
  State<CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<CountryPickerSheet> {
  late List<Country> _filtered;
  late Map<String, List<Country>> _groups;
  late List<String> _letters;
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filtered = List.from(allCountries)
      ..sort((a, b) => a.name.compareTo(b.name));
    _recomputeGroups();
  }

  void _recomputeGroups() {
    _groups = {};
    for (final country in _filtered) {
      final lk = country.name[0].toUpperCase();
      _groups.putIfAbsent(lk, () => []).add(country);
    }
    _letters = _groups.keys.toList()..sort();
  }

  void _onSearch(String q) {
    setState(() {
      _filtered = allCountries
          .where(
            (c) =>
                c.name.toLowerCase().contains(q.toLowerCase()) ||
                c.iso.toLowerCase().contains(q.toLowerCase()),
          )
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name));
      _recomputeGroups();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: Material(
            color: theme.canvasColor,
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 6,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: _onSearch,
                    decoration: InputDecoration(
                      hintText: 'Search country name',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchCtrl.text.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchCtrl.clear();
                                _onSearch('');
                              },
                            ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: _getTotalItemCount(),
                    itemBuilder: (context, index) {
                      int currentIndex = 0;
                      for (final letter in _letters) {
                        // Header
                        if (index == currentIndex) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 6,
                            ),
                            child: Text(
                              letter,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }
                        currentIndex++;

                        // Items
                        final countries = _groups[letter]!;
                        for (final country in countries) {
                          if (index == currentIndex) {
                            return InkWell(
                              onTap: () => Navigator.pop(context, country.name),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      country.flagEmoji,
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        country.name,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    Text(
                                      country.iso,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          currentIndex++;
                        }
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  int _getTotalItemCount() {
    int count = 0;
    for (final letter in _letters) {
      count += 1;
      count += _groups[letter]!.length;
    }
    return count;
  }
}
