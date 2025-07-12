import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roadsurfer_app/stores/campsites_store.dart';

class CampsiteFiltersWidget extends ConsumerStatefulWidget {
  const CampsiteFiltersWidget({super.key});

  @override
  ConsumerState<CampsiteFiltersWidget> createState() => _CampsiteFiltersWidgetState();
}

class _CampsiteFiltersWidgetState extends ConsumerState<CampsiteFiltersWidget> {
  final TextEditingController _searchController = TextEditingController();
  bool? _isCloseToWater;
  bool? _isCampFireAllowed;
  final List<String> _selectedLanguages = [];
  double? _minPrice;
  double? _maxPrice;

  @override
  void initState() {
    super.initState();
    _loadCurrentFilters();
  }

  void _loadCurrentFilters() {
    final currentFilters = ref.read(campsiteFiltersProvider);
    _searchController.text = currentFilters.searchQuery ?? '';
    _isCloseToWater = currentFilters.isCloseToWater;
    _isCampFireAllowed = currentFilters.isCampFireAllowed;
    _selectedLanguages.clear();
    _selectedLanguages.addAll(currentFilters.hostLanguages);
    _minPrice = currentFilters.minPrice;
    _maxPrice = currentFilters.maxPrice;
  }

  void _applyFilters() {
    final filters = CampsiteFilters(
      searchQuery: _searchController.text.isEmpty ? null : _searchController.text,
      isCloseToWater: _isCloseToWater,
      isCampFireAllowed: _isCampFireAllowed,
      hostLanguages: List.from(_selectedLanguages),
      minPrice: _minPrice,
      maxPrice: _maxPrice,
    );
    ref.read(campsitesProvider.notifier).updateFilters(filters);
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _isCloseToWater = null;
      _isCampFireAllowed = null;
      _selectedLanguages.clear();
      _minPrice = null;
      _maxPrice = null;
    });
    ref.read(campsitesProvider.notifier).clearFilters();
  }

  @override
  Widget build(BuildContext context) {
    final currentFilters = ref.watch(campsiteFiltersProvider);
    final hasActiveFilters = currentFilters.hasActiveFilters;

    return ExpansionTile(
      title: Row(
        children: [
          const Icon(Icons.filter_list),
          const SizedBox(width: 8),
          const Text('Filters'),
          if (hasActiveFilters) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Active',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ],
        ],
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search filter
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Search campsites',
                  hintText: 'Search by name or language...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (_) => _applyFilters(),
              ),
              const SizedBox(height: 16),

              // Boolean filters
              Row(
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      title: const Text('Close to Water'),
                      value: _isCloseToWater,
                      tristate: true,
                      onChanged: (value) {
                        setState(() {
                          _isCloseToWater = value;
                        });
                        _applyFilters();
                      },
                    ),
                  ),
                  Expanded(
                    child: CheckboxListTile(
                      title: const Text('Campfire Allowed'),
                      value: _isCampFireAllowed,
                      tristate: true,
                      onChanged: (value) {
                        setState(() {
                          _isCampFireAllowed = value;
                        });
                        _applyFilters();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Language filter
              const Text('Host Languages:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['en', 'de'].map((language) {
                  final isSelected = _selectedLanguages.contains(language);
                  return FilterChip(
                    label: Text(language.toUpperCase()),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedLanguages.add(language);
                        } else {
                          _selectedLanguages.remove(language);
                        }
                      });
                      _applyFilters();
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Price range filter
              const Text('Price Range:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Min Price',
                        prefixText: '\$',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _minPrice = double.tryParse(value);
                        _applyFilters();
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Max Price',
                        prefixText: '\$',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _maxPrice = double.tryParse(value);
                        _applyFilters();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _clearFilters,
                      icon: const Icon(Icons.clear),
                      label: const Text('Clear All Filters'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
} 