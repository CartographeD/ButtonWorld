import 'package:flutter/material.dart';

import '../data/countries.dart';
import '../services/player_service.dart';

class CountryScreen extends StatefulWidget {
  final String? selectedCountry;

  const CountryScreen({
    super.key,
    this.selectedCountry,
  });

  @override
  State<CountryScreen> createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  String search = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Country> get filteredCountries {
    final query = search.trim().toLowerCase();

    if (query.isEmpty) {
      return countries;
    }

    return countries.where((country) {
      return country.name.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> _selectCountry(Country country) async {
    try {
      await PlayerService.updateCountry(country.name);

      if (!mounted) return;

      Navigator.of(context).pop(country.name);
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not save your country.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'YOUR COUNTRY',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  search = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search a country...',
                prefixIcon: const Icon(
                  Icons.search_rounded,
                ),
                suffixIcon: search.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                        ),
                        onPressed: () {
                          _searchController.clear();

                          setState(() {
                            search = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              itemCount: filteredCountries.length,
              itemBuilder: (context, index) {
                final country = filteredCountries[index];

                final selected =
                    country.name == widget.selectedCountry;

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFFFFE9E9)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    onTap: () => _selectCountry(country),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 3,
                    ),
                    leading: Text(
                      country.flag,
                      style: const TextStyle(
                        fontSize: 26,
                      ),
                    ),
                    title: Text(
                      country.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: selected
                            ? FontWeight.w800
                            : FontWeight.w600,
                      ),
                    ),
                    trailing: selected
                        ? const Icon(
                            Icons.check_circle_rounded,
                            color: Color(0xFFE53935),
                          )
                        : const Icon(
                            Icons.chevron_right_rounded,
                            color: Colors.black26,
                          ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}