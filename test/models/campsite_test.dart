import 'package:flutter_test/flutter_test.dart';
import 'package:roadsurfer_app/models/campsite.dart';

void main() {
  group('Campsite', () {
    test('should create Campsite from JSON', () {
      final json = <String, dynamic>{
        'id': '1',
        'createdAt': '2022-09-11T14:25:09.496Z',
        'label': 'Test Campsite',
        'photo': 'http://loremflickr.com/640/480',
        'geoLocation': <String, dynamic>{
          'lat': 96060.37,
          'long': 72330.52,
        },
        'isCloseToWater': true,
        'isCampFireAllowed': false,
        'hostLanguages': ['en', 'de'],
        'pricePerNight': 78508.23,
        'suitableFor': [],
      };

      final campsite = Campsite.fromJson(json);

      expect(campsite.id, '1');
      expect(campsite.createdAt, '2022-09-11T14:25:09.496Z');
      expect(campsite.label, 'Test Campsite');
      expect(campsite.photo, 'http://loremflickr.com/640/480');
      expect(campsite.isCloseToWater, true);
      expect(campsite.isCampFireAllowed, false);
      expect(campsite.hostLanguages, ['en', 'de']);
      expect(campsite.pricePerNight, 78508.23);
      expect(campsite.suitableFor, isEmpty);
      expect(campsite.geoLocation.lat, 96060.37);
      expect(campsite.geoLocation.long, 72330.52);
    });

    test('should convert Campsite to JSON', () {
      final campsite = Campsite(
        id: '1',
        createdAt: '2022-09-11T14:25:09.496Z',
        label: 'Test Campsite',
        photo: 'http://loremflickr.com/640/480',
        geoLocation: GeoLocation(lat: 96060.37, long: 72330.52),
        isCloseToWater: true,
        isCampFireAllowed: false,
        hostLanguages: ['en', 'de'],
        pricePerNight: 78508.23,
        suitableFor: [],
      );

      final json = campsite.toJson();

      expect(json['id'], '1');
      expect(json['createdAt'], '2022-09-11T14:25:09.496Z');
      expect(json['label'], 'Test Campsite');
      expect(json['photo'], 'http://loremflickr.com/640/480');
      expect(json['isCloseToWater'], true);
      expect(json['isCampFireAllowed'], false);
      expect(json['hostLanguages'], ['en', 'de']);
      expect(json['pricePerNight'], 78508.23);
      expect(json['suitableFor'], isEmpty);
      expect(json['geoLocation']['lat'], 96060.37);
      expect(json['geoLocation']['long'], 72330.52);
    });

    test('should handle missing optional fields with defaults', () {
      final json = <String, dynamic>{
        'id': '1',
        'label': 'Test Campsite',
        'photo': 'http://loremflickr.com/640/480',
        'geoLocation': <String, dynamic>{
          'lat': 96060.37,
          'long': 72330.52,
        },
      };

      final campsite = Campsite.fromJson(json);

      expect(campsite.id, '1');
      expect(campsite.label, 'Test Campsite');
      expect(campsite.createdAt, '');
      expect(campsite.isCloseToWater, false);
      expect(campsite.isCampFireAllowed, false);
      expect(campsite.hostLanguages, isEmpty);
      expect(campsite.pricePerNight, 0.0);
      expect(campsite.suitableFor, isEmpty);
    });

    test('should handle null values', () {
      final json = <String, dynamic>{
        'id': null,
        'createdAt': null,
        'label': null,
        'photo': null,
        'geoLocation': null,
        'isCloseToWater': null,
        'isCampFireAllowed': null,
        'hostLanguages': null,
        'pricePerNight': null,
        'suitableFor': null,
      };

      final campsite = Campsite.fromJson(json);

      expect(campsite.id, '');
      expect(campsite.createdAt, '');
      expect(campsite.label, '');
      expect(campsite.photo, '');
      expect(campsite.isCloseToWater, false);
      expect(campsite.isCampFireAllowed, false);
      expect(campsite.hostLanguages, isEmpty);
      expect(campsite.pricePerNight, 0.0);
      expect(campsite.suitableFor, isEmpty);
      expect(campsite.geoLocation.lat, 0.0);
      expect(campsite.geoLocation.long, 0.0);
    });
  });
} 