import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:roadsurfer_app/models/campsite.dart';
import 'package:roadsurfer_app/services/campsites_service.dart';

import 'campsites_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('CampsitesService', () {
    late CampsitesService campsitesService;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      campsitesService = CampsitesService(client: mockClient);
    });

    group('getCampsites', () {
      test('returns a list of campsites when API call is successful', () async {
        final mockResponse = '''
        [
          {
            "id": "1",
            "createdAt": "2022-09-11T14:25:09.496Z",
            "label": "Test Campsite",
            "photo": "http://loremflickr.com/640/480",
            "geoLocation": {
              "lat": 96060.37,
              "long": 72330.52
            },
            "isCloseToWater": true,
            "isCampFireAllowed": false,
            "hostLanguages": ["en", "de"],
            "pricePerNight": 78508.23,
            "suitableFor": []
          }
        ]
        ''';

        when(mockClient.get(Uri.parse('https://62ed0389a785760e67622eb2.mockapi.io/spots/v1/campsites')))
            .thenAnswer((_) async => http.Response(mockResponse, 200));

        final result = await campsitesService.getCampsites();

        expect(result, isA<List<Campsite>>());
        expect(result.length, 1);
        expect(result.first.id, '1');
        expect(result.first.label, 'Test Campsite');
        expect(result.first.isCloseToWater, true);
        expect(result.first.isCampFireAllowed, false);
        expect(result.first.pricePerNight, 78508.23);
        expect(result.first.hostLanguages, ['en', 'de']);
        expect(result.first.geoLocation.lat, 96060.37);
        expect(result.first.geoLocation.long, 72330.52);
      });

      test('returns multiple campsites when API call is successful', () async {
        final mockResponse = '''
        [
          {
            "id": "1",
            "createdAt": "2022-09-11T14:25:09.496Z",
            "label": "Campsite 1",
            "photo": "http://loremflickr.com/640/480",
            "geoLocation": {
              "lat": 96060.37,
              "long": 72330.52
            },
            "isCloseToWater": true,
            "isCampFireAllowed": false,
            "hostLanguages": ["en"],
            "pricePerNight": 78508.23,
            "suitableFor": []
          },
          {
            "id": "2",
            "createdAt": "2022-09-11T15:04:21.217Z",
            "label": "Campsite 2",
            "photo": "http://loremflickr.com/640/480",
            "geoLocation": {
              "lat": 32955.74,
              "long": 93715.96
            },
            "isCloseToWater": false,
            "isCampFireAllowed": true,
            "hostLanguages": ["de"],
            "pricePerNight": 80694.76,
            "suitableFor": []
          }
        ]
        ''';

        when(mockClient.get(Uri.parse('https://62ed0389a785760e67622eb2.mockapi.io/spots/v1/campsites')))
            .thenAnswer((_) async => http.Response(mockResponse, 200));

        final result = await campsitesService.getCampsites();

        expect(result, isA<List<Campsite>>());
        expect(result.length, 2);
        expect(result[0].id, '1');
        expect(result[0].label, 'Campsite 1');
        expect(result[1].id, '2');
        expect(result[1].label, 'Campsite 2');
      });

      test('throws exception when API call fails with non-200 status code', () async {
        when(mockClient.get(Uri.parse('https://62ed0389a785760e67622eb2.mockapi.io/spots/v1/campsites')))
            .thenAnswer((_) async => http.Response('Not Found', 404));

        expect(
          () => campsitesService.getCampsites(),
          throwsA(isA<Exception>()),
        );
      });

      test('throws exception when API call throws an exception', () async {
        when(mockClient.get(Uri.parse('https://62ed0389a785760e67622eb2.mockapi.io/spots/v1/campsites')))
            .thenThrow(Exception('Network error'));

        expect(
          () => campsitesService.getCampsites(),
          throwsA(isA<Exception>()),
        );
      });

      test('handles empty response correctly', () async {
        when(mockClient.get(Uri.parse('https://62ed0389a785760e67622eb2.mockapi.io/spots/v1/campsites')))
            .thenAnswer((_) async => http.Response('[]', 200));

        final result = await campsitesService.getCampsites();

        expect(result, isA<List<Campsite>>());
        expect(result.length, 0);
      });

      test('handles malformed JSON', () async {
        when(mockClient.get(Uri.parse('https://62ed0389a785760e67622eb2.mockapi.io/spots/v1/campsites')))
            .thenAnswer((_) async => http.Response('invalid json', 200));

        expect(
          () => campsitesService.getCampsites(),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
} 