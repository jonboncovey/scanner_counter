// lane_data_state.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scanner_counter/riverpod_version/database.dart';
import 'package:scanner_counter/riverpod_version/models/Lane.dart';
import 'package:scanner_counter/riverpod_version/models/LaneData.dart';
import 'package:scanner_counter/riverpod_version/pods/DatabaseProvider.dart';

class LaneDataState {
  final Map<Lane, LaneData> laneData;
  final Lane activeLane;
  final List<LaneScan> scannedData;

  LaneDataState({
    required this.laneData,
    required this.activeLane,
    required this.scannedData,
  });

  LaneDataState copyWith({
    Map<Lane, LaneData>? laneData,
    Lane? activeLane,
    List<LaneScan>? scannedData,
  }) {
    return LaneDataState(
      laneData: laneData ?? this.laneData,
      activeLane: activeLane ?? this.activeLane,
      scannedData: scannedData ?? this.scannedData,
    );
  }
}

class LaneDataNotifier extends StateNotifier<LaneDataState> {
  final AppDatabase _appDatabase;

  LaneDataNotifier(this._appDatabase)
      : super(LaneDataState(
          laneData: {
            Lane.one: LaneData(
                selectedLane: 1,
                scannableCount: 50,
                scannedCount: 0,
                scannedData: []),
            Lane.two: LaneData(
                selectedLane: 2,
                scannableCount: 50,
                scannedCount: 0,
                scannedData: []),
            Lane.three: LaneData(
                selectedLane: 3,
                scannableCount: 50,
                scannedCount: 0,
                scannedData: []),
          },
          activeLane: Lane.one,
          scannedData: [],
        ));

  void updateScannedData(String barcode) {
    // ... (Update scanned data logic)
  }

  void changeActiveLane(Lane lane) {
    state = state.copyWith(activeLane: lane);
  }

  Future<void> fetchScannedData() async {
    final scannedData = await _appDatabase.getLaneScans();
    state = state.copyWith(scannedData: scannedData);
  }

  Future<void> resetLaneData() async {
    await _appDatabase.deleteAllLaneScans();
    state = LaneDataState(
      laneData: {
        Lane.one: LaneData(
            selectedLane: 1,
            scannableCount: 50,
            scannedCount: 0,
            scannedData: []),
        Lane.two: LaneData(
            selectedLane: 2,
            scannableCount: 50,
            scannedCount: 0,
            scannedData: []),
        Lane.three: LaneData(
            selectedLane: 3,
            scannableCount: 50,
            scannedCount: 0,
            scannedData: []),
      },
      activeLane: Lane.one,
      scannedData: [],
    );
  }
}

final laneDataProvider =
    StateNotifierProvider<LaneDataNotifier, LaneDataState>((ref) {
  final appDatabase = ref.watch(appDatabaseProvider);
  return LaneDataNotifier(appDatabase);
});
