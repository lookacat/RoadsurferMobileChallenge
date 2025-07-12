import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:roadsurfer_app/models/campsite.dart';
import 'package:roadsurfer_app/services/campsites_service.dart';
import 'package:roadsurfer_app/stores/campsites_store.dart';

import 'campsites_store_test.mocks.dart';

@GenerateMocks([CampsitesService])
void main() {
  group('CampsitesNotifier', () {
    late CampsitesNotifier notifier;
    late MockCampsitesService mockService;
    late ProviderContainer container;

    setUp(() {
      mockService = MockCampsitesService();
      container = ProviderContainer(
        overrides: [
          campsitesServiceProvider.overrideWithValue(mockService),
        ],
      );
      notifier = container.read(campsitesProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    group('initial state', () {
      test('should start with loading state', () {
        expect(notifier.state, const AsyncValue<List<Campsite>>.loading());
      });
    });

    group('loadCampsites', () {
      test('should update state to loading when called', () async {
        when(mockService.getCampsites()).thenAnswer(
          (_) async => Future.delayed(const Duration(milliseconds: 100), () => []),
        );

        final future = notifier.loadCampsites();

        expect(notifier.state, const AsyncValue<List<Campsite>>.loading());
        await future;
      });

      test('should update state to data when API call succeeds', () async {
        final mockCampsites = [
          Campsite(
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
          ),
        ];

        when(mockService.getCampsites()).thenAnswer((_) async => mockCampsites);
        await notifier.loadCampsites();

        expect(notifier.state, isA<AsyncValue<List<Campsite>>>());
        expect(notifier.state.value, mockCampsites);
        expect(notifier.state.value!.length, 1);
        expect(notifier.state.value!.first.id, '1');
        expect(notifier.state.value!.first.label, 'Test Campsite');
      });

      test('should update state to error when API call fails', () async {
        when(mockService.getCampsites()).thenThrow(Exception('Network error'));

        await notifier.loadCampsites();

        expect(notifier.state, isA<AsyncValue<List<Campsite>>>());
        expect(notifier.state.hasError, true);
        expect(notifier.state.error, isA<Exception>());
        expect(notifier.state.error.toString(), contains('Network error'));
      });

      test('should handle empty list from API', () async {
        when(mockService.getCampsites()).thenAnswer((_) async => []);
				
        await notifier.loadCampsites();

        expect(notifier.state, isA<AsyncValue<List<Campsite>>>());
        expect(notifier.state.value, isEmpty);
      });

      test('should handle multiple campsites from API', () async {
        final mockCampsites = [
          Campsite(
            id: '1',
            createdAt: '2022-09-11T14:25:09.496Z',
            label: 'Campsite 1',
            photo: 'http://loremflickr.com/640/480',
            geoLocation: GeoLocation(lat: 96060.37, long: 72330.52),
            isCloseToWater: true,
            isCampFireAllowed: false,
            hostLanguages: ['en'],
            pricePerNight: 78508.23,
            suitableFor: [],
          ),
          Campsite(
            id: '2',
            createdAt: '2022-09-11T15:04:21.217Z',
            label: 'Campsite 2',
            photo: 'http://loremflickr.com/640/480',
            geoLocation: GeoLocation(lat: 32955.74, long: 93715.96),
            isCloseToWater: false,
            isCampFireAllowed: true,
            hostLanguages: ['de'],
            pricePerNight: 80694.76,
            suitableFor: [],
          ),
        ];

        when(mockService.getCampsites()).thenAnswer((_) async => mockCampsites);

        await notifier.loadCampsites();

        expect(notifier.state, isA<AsyncValue<List<Campsite>>>());
        expect(notifier.state.value, mockCampsites);
        expect(notifier.state.value!.length, 2);
        expect(notifier.state.value![0].id, '1');
        expect(notifier.state.value![1].id, '2');
      });
    });
  });
} 