import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:roadsurfer_app/models/campsite.dart';

class CampsitesService {
  static const String _baseUrl = 'https://62ed0389a785760e67622eb2.mockapi.io/spots/v1/campsites';
  
  final http.Client _client;
  
  CampsitesService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Campsite>> getCampsites() async {
    try {
      final response = await _client.get(Uri.parse(_baseUrl));
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Campsite.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load campsites: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load campsites: $e');
    }
  }
} 