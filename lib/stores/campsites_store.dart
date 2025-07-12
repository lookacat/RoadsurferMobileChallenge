import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roadsurfer_app/models/campsite.dart';
import 'package:roadsurfer_app/services/campsites_service.dart';

// Service provider
final campsitesServiceProvider = Provider<CampsitesService>((ref) {
  return CampsitesService();
});

// Filter state
class CampsiteFilters {
  final String? searchQuery;
  final bool? isCloseToWater;
  final bool? isCampFireAllowed;
  final List<String> hostLanguages;
  final double? minPrice;
  final double? maxPrice;

  CampsiteFilters({
    this.searchQuery,
    this.isCloseToWater,
    this.isCampFireAllowed,
    this.hostLanguages = const [],
    this.minPrice,
    this.maxPrice,
  });

  CampsiteFilters copyWith({
    String? searchQuery,
    bool? isCloseToWater,
    bool? isCampFireAllowed,
    List<String>? hostLanguages,
    double? minPrice,
    double? maxPrice,
  }) {
    return CampsiteFilters(
      searchQuery: searchQuery ?? this.searchQuery,
      isCloseToWater: isCloseToWater ?? this.isCloseToWater,
      isCampFireAllowed: isCampFireAllowed ?? this.isCampFireAllowed,
      hostLanguages: hostLanguages ?? this.hostLanguages,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
    );
  }

  bool get hasActiveFilters {
    return searchQuery?.isNotEmpty == true ||
        isCloseToWater != null ||
        isCampFireAllowed != null ||
        hostLanguages.isNotEmpty ||
        minPrice != null ||
        maxPrice != null;
  }
}

// State notifier for campsites
class CampsitesNotifier extends StateNotifier<AsyncValue<List<Campsite>>> {
  final CampsitesService _campsitesService;
  List<Campsite> _allCampsites = [];
  CampsiteFilters _filters = CampsiteFilters();

  CampsitesNotifier(this._campsitesService) : super(const AsyncValue.loading());

  CampsiteFilters get filters => _filters;

  Future<void> loadCampsites() async {
    state = const AsyncValue.loading();
    
    try {
      final campsites = await _campsitesService.getCampsites();
      _allCampsites = campsites;
      _applyFiltersAndSort();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void updateFilters(CampsiteFilters newFilters) {
    _filters = newFilters;
    _applyFiltersAndSort();
  }

  void clearFilters() {
    _filters = CampsiteFilters();
    _applyFiltersAndSort();
  }

  void _applyFiltersAndSort() {
    if (_allCampsites.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    List<Campsite> filteredCampsites = List.from(_allCampsites);

    // Apply search filter
    if (_filters.searchQuery?.isNotEmpty == true) {
      final query = _filters.searchQuery!.toLowerCase();
      filteredCampsites = filteredCampsites.where((campsite) {
        return campsite.label.toLowerCase().contains(query) ||
               campsite.hostLanguages.any((lang) => lang.toLowerCase().contains(query));
      }).toList();
    }

    // Apply water proximity filter
    if (_filters.isCloseToWater != null) {
      filteredCampsites = filteredCampsites.where(
        (campsite) => campsite.isCloseToWater == _filters.isCloseToWater,
      ).toList();
    }

    // Apply campfire filter
    if (_filters.isCampFireAllowed != null) {
      filteredCampsites = filteredCampsites.where(
        (campsite) => campsite.isCampFireAllowed == _filters.isCampFireAllowed,
      ).toList();
    }

    // Apply language filter
    if (_filters.hostLanguages.isNotEmpty) {
      filteredCampsites = filteredCampsites.where((campsite) {
        return campsite.hostLanguages.any((lang) => _filters.hostLanguages.contains(lang));
      }).toList();
    }

    // Apply price range filter
    if (_filters.minPrice != null) {
      filteredCampsites = filteredCampsites.where(
        (campsite) => campsite.pricePerNight >= _filters.minPrice!,
      ).toList();
    }

    if (_filters.maxPrice != null) {
      filteredCampsites = filteredCampsites.where(
        (campsite) => campsite.pricePerNight <= _filters.maxPrice!,
      ).toList();
    }

    // Sort by name
    filteredCampsites.sort((a, b) => a.label.compareTo(b.label));

    state = AsyncValue.data(filteredCampsites);
  }

  void clearCampsites() {
    _allCampsites = [];
    _filters = CampsiteFilters();
    state = const AsyncValue.data([]);
  }
}

// Provider for campsites state
final campsitesProvider = StateNotifierProvider<CampsitesNotifier, AsyncValue<List<Campsite>>>((ref) {
  final service = ref.watch(campsitesServiceProvider);
  return CampsitesNotifier(service);
});

// Provider for filters
final campsiteFiltersProvider = Provider<CampsiteFilters>((ref) {
  final notifier = ref.watch(campsitesProvider.notifier);
  return notifier.filters;
}); 