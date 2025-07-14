import 'package:flutter/material.dart';
import 'package:roadsurfer_app/models/campsite.dart';

class CampsiteDetailView extends StatelessWidget {
  final Campsite campsite;

  const CampsiteDetailView({
    super.key,
    required this.campsite,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(campsite.label),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (campsite.photo.isNotEmpty)
              Container(
                width: double.infinity,
                height: 250,
                child: Image.network(
                  campsite.photo,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 250,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image,
                        size: 64,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.attach_money,
                          color: Colors.green[700],
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Price per night',
                              style: TextStyle(
                                color: Colors.green[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '\$${campsite.pricePerNight.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Amenities section
                  _buildSection(
                    title: 'Amenities & Features',
                    icon: Icons.forest,
                    iconColor: Colors.orange,
                    children: [
                      _buildAmenityItem(
                        icon: Icons.water,
                        label: 'Close to water',
                        isAvailable: campsite.isCloseToWater,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 8),
                      _buildAmenityItem(
                        icon: Icons.local_fire_department,
                        label: 'Campfire allowed',
                        isAvailable: campsite.isCampFireAllowed,
                        color: Colors.orange,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Suitable for section
                  if (campsite.suitableFor.isNotEmpty)
                    _buildSection(
                      title: 'Suitable for',
                      icon: Icons.people,
                      iconColor: Colors.purple,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: campsite.suitableFor.map((item) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.purple[100],
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.purple[200]!),
                              ),
                              child: Text(
                                item,
                                style: TextStyle(
                                  color: Colors.purple[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),

                  if (campsite.suitableFor.isNotEmpty) const SizedBox(height: 24),

                  // Host languages section
                  if (campsite.hostLanguages.isNotEmpty)
                    _buildSection(
                      title: 'Host Languages',
                      icon: Icons.language,
                      iconColor: Colors.teal,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: campsite.hostLanguages.map((language) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.teal[100],
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.teal[200]!),
                              ),
                              child: Text(
                                language,
                                style: TextStyle(
                                  color: Colors.teal[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),

                  if (campsite.hostLanguages.isNotEmpty) const SizedBox(height: 24),

                  // Additional info section
                  _buildSection(
                    title: 'Additional Information',
                    icon: Icons.info,
                    iconColor: Colors.grey,
                    children: [
                      Text(
                        'Campsite ID: ${campsite.id}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Created: ${_formatDate(campsite.createdAt)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Implement booking functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Booking feature coming soon!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          icon: const Icon(Icons.book_online),
                          label: const Text('Book Now'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Implement contact host functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Contact feature coming soon!'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.message),
                          label: const Text('Contact Host'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildAmenityItem({
    required IconData icon,
    required String label,
    required bool isAvailable,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: isAvailable ? color : Colors.grey[400],
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: isAvailable ? Colors.black87 : Colors.grey[500],
            fontWeight: isAvailable ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
        const Spacer(),
        Icon(
          isAvailable ? Icons.check_circle : Icons.cancel,
          color: isAvailable ? Colors.green : Colors.grey[400],
          size: 20,
        ),
      ],
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
} 