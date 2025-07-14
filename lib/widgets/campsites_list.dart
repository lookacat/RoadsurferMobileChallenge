import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roadsurfer_app/models/campsite.dart';
import 'package:roadsurfer_app/stores/campsites_store.dart';
import 'package:roadsurfer_app/widgets/campsite_detail_view.dart';

class CampsitesList extends ConsumerWidget {
  const CampsitesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final campsitesAsync = ref.watch(campsitesProvider);
    final hasActiveFilters = ref.watch(campsiteFiltersProvider).hasActiveFilters;

    return campsitesAsync.when(
      data: (campsites) => _buildCampsitesList(campsites, hasActiveFilters),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error loading campsites',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(campsitesProvider.notifier).loadCampsites(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCampsitesList(List<Campsite> campsites, bool hasActiveFilters) {
    if (campsites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasActiveFilters ? Icons.filter_list_off : Icons.park,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              hasActiveFilters ? 'No campsites match your filters' : 'No campsites loaded',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hasActiveFilters 
                ? 'Try adjusting your filters or clear them to see all campsites'
                : 'Click "Load Campsites" to fetch data from the API',
              style: TextStyle(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: campsites.length,
      itemBuilder: (context, index) {
        final campsite = campsites[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: campsite.photo.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      campsite.photo,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.image, color: Colors.grey),
                        );
                      },
                    ),
                  )
                : Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
            title: Text(
              campsite.label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Location: ${campsite.geoLocation.lat.toStringAsFixed(2)}, ${campsite.geoLocation.long.toStringAsFixed(2)}'),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.attach_money, size: 16, color: Colors.green),
                    Text(' \$${campsite.pricePerNight.toStringAsFixed(2)}/night'),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (campsite.isCloseToWater)
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('Water', style: TextStyle(fontSize: 10)),
                      ),
                    if (campsite.isCampFireAllowed)
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('Campfire', style: TextStyle(fontSize: 10)),
                      ),
                  ],
                ),
                if (campsite.hostLanguages.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Languages: ${campsite.hostLanguages.join(', ')}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CampsiteDetailView(campsite: campsite),
                ),
              );
            },
          ),
        );
      },
    );
  }
} 