import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roadsurfer_app/stores/campsites_store.dart';
import 'package:roadsurfer_app/widgets/campsites_list.dart';
import 'package:roadsurfer_app/widgets/campsite_filters.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Roadsurfer Mobile Challenge',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF6BBBAE, {
          50: Color(0xFFE8F5F3),
          100: Color(0xFFC5E7E1),
          200: Color(0xFF9FD7CE),
          300: Color(0xFF79C7BB),
          400: Color(0xFF5DBBAB),
          500: Color(0xFF6BBBAE),
          600: Color(0xFF5FB5A7),
          700: Color(0xFF55AC9D),
          800: Color(0xFF4BA494),
          900: Color(0xFF3A9687),
        }),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF6BBBAE),
          brightness: Brightness.light,
        ),
        fontFamily: GoogleFonts.inter().fontFamily,
        textTheme: GoogleFonts.interTextTheme(),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return Color(0xFF6BBBAE);
            }
            return null;
          }),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF6BBBAE),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load campsites when the app opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(campsitesProvider.notifier).loadCampsites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final campsitesAsync = ref.watch(campsitesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Roadsurfer Mobile Challenge'),
        backgroundColor: Color(0xFF6BBBAE),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [

          // Filters section
          const CampsiteFiltersWidget(),

          // Results count
          campsitesAsync.when(
            data: (campsites) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    '${campsites.length} campsite${campsites.length == 1 ? '' : 's'} found',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  if (ref.watch(campsiteFiltersProvider).hasActiveFilters)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Filtered',
                        style: TextStyle(
                          color: Colors.orange[800],
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          // Campsites list
          Expanded(
            child: campsitesAsync.when(
              data: (campsites) => CampsitesList(),
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
            ),
          ),
        ],
      ),
    );
  }
}
