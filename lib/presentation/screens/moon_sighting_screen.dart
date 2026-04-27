import 'package:flutter/material.dart';

import '../../data/local/sighting_box.dart';
import '../../data/mappers/sighting_repository.dart';
import '../../domain/models/moon_sighting.dart';
import '../widgets/sighting/sighting_tile.dart';
import '../widgets/sighting/add_moon_sighting_sheet.dart';

class MoonSightingScreen extends StatefulWidget {
  const MoonSightingScreen({super.key});

  @override
  State<MoonSightingScreen> createState() => _MoonSightingScreenState();
}

class _MoonSightingScreenState extends State<MoonSightingScreen> {
  late final MoonSightingRepository repository;

  List<MoonSighting> sightings = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    repository = MoonSightingRepository(MoonSightingBox());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadSightings(); // 🔑 safe after first frame
    });
  }
  
  /// Load all sightings from storage
  Future<void> loadSightings() async {
    setState(() => isLoading = true);

    try {
      final data = await repository.getAll();

      setState(() {
        sightings = data.reversed.toList();
        isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ Error loading sightings: $e');

      setState(() {
        sightings = [];
        isLoading = false;
      });
    }
  }

  /// Add a new sighting and refresh list
  Future<void> addSighting(DateTime date, String? notes) async {
    try {
      final sighting = MoonSighting(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        recordedAt: date,
        monthStart: date,
        isActive: sightings.isEmpty,
        notes: notes,
      );

      debugPrint('📌 Saving sighting: ${sighting.toMap()}');

      await repository.add(sighting);

      debugPrint('✅ Saved successfully');

      await loadSightings();
    } catch (e) {
      debugPrint('❌ Error saving sighting: $e');
    }
  }

  /// Open bottom sheet
  void openAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return AddMoonSightingSheet(
          onSave: addSighting,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Moon Sightings'),
        centerTitle: true,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : sightings.isEmpty
              ? const Center(
                  child: Text(
                    'No moon sightings recorded yet',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadSightings,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(12),
                    itemCount: sightings.length,
                    itemBuilder: (context, index) {
                      return MoonSightingTile(
                        sighting: sightings[index],
                      );
                    },
                  ),
                ),

      floatingActionButton: FloatingActionButton(
        onPressed: openAddSheet,
        child: const Icon(Icons.add),
      ),
    );
  }
}