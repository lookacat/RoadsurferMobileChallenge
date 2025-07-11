import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roadsurfer_app/models/campsite.dart';
import 'package:roadsurfer_app/services/campsites_service.dart';

// Service provider
final campsitesServiceProvider = Provider<CampsitesService>((ref) {
  return CampsitesService();
});

// State notifier for campsites
class CampsitesNotifier extends StateNotifier<AsyncValue<List<Campsite>>> {
  final CampsitesService _campsitesService;

  CampsitesNotifier(this._campsitesService) : super(const AsyncValue.loading());

  Future<void> loadCampsites() async {
    state = const AsyncValue.loading();
    
    try {
      final campsites = await _campsitesService.getCampsites();
      state = AsyncValue.data(campsites);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void clearCampsites() {
    state = const AsyncValue.data([]);
  }
}

// Provider for campsites state
final campsitesProvider = StateNotifierProvider<CampsitesNotifier, AsyncValue<List<Campsite>>>((ref) {
  final service = ref.watch(campsitesServiceProvider);
  return CampsitesNotifier(service);
}); 