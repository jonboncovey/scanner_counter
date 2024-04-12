import 'dart:async';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scanner_counter/riverpod_version/pods/LaneDataRiverpod.dart';
import 'package:scanner_counter/riverpod_version/database.dart';
import 'package:scanner_counter/riverpod_version/models/Lane.dart';
import 'package:scanner_counter/riverpod_version/models/LaneData.dart';
import 'package:scanner_counter/riverpod_version/models/PropositionType.dart';
import 'package:scanner_counter/riverpod_version/pods/DatabaseProvider.dart';
import 'package:soundpool/soundpool.dart';

class RiverScannerPage extends ConsumerStatefulWidget {
  final Soundpool pool;
  final ValueSetter<SoundpoolOptions> onOptionsChange;

  const RiverScannerPage(
      {Key? key, required this.pool, required this.onOptionsChange})
      : super(key: key);

  @override
  ConsumerState createState() {
    return _RiverScannerPageState();
  }
}

class _RiverScannerPageState extends ConsumerState<RiverScannerPage> {
  Soundpool get _soundpool => widget.pool;
  int? _scannedSoundStreamId;
  String qrStatus = 'Looking for scannable items...';
  bool showCameraView = false;
  bool showScanCountdownMode = false;
  Widget qrStatusWidget = Container();
  bool codeJustScanned = false;
  DateTime? _lastSuccessfulScanTime;

  bool _showingSnackbar = false;
  Timer? _snackbarTimer;

  late Future<int> _soundId;

  final Map<Lane, LaneData> laneData = {
    Lane.one: LaneData(
      selectedLane: 1,
      scannableCount: 50,
      scannedData: [],
      scannedCount: 0,
    ),
    Lane.two: LaneData(
      selectedLane: 2,
      scannableCount: 50,
      scannedData: [],
      scannedCount: 0,
    ),
    Lane.three: LaneData(
      selectedLane: 3,
      scannableCount: 50,
      scannedData: [],
      scannedCount: 0,
    ),
  };

  late Lane activeLane;

  void _updateScannedData(String barcode) {
    if (laneData[activeLane]!.scannedCount <
            laneData[activeLane]!.scannableCount &&
        !laneData[activeLane]!.scannedData.contains(barcode)) {
      setState(() {
        laneData[activeLane]!.scannedData.add(barcode);
        laneData[activeLane]!.scannedCount += 1;
        _lastSuccessfulScanTime = DateTime.now();
      });
      Timer(const Duration(seconds: 1), () {
        setState(() {
          codeJustScanned = false;
        });
      });
    } else if (laneData[activeLane]!.scannedCount ==
        laneData[activeLane]!.scannableCount) {
      _showSnackbar('Scanning complete');
    } else if (laneData[activeLane]!.scannedData.contains(barcode)) {
      if (!_showingSnackbar &&
          (_lastSuccessfulScanTime == null ||
              DateTime.now().difference(_lastSuccessfulScanTime!).inSeconds >=
                  3)) {
        _showSnackbar('Already scanned');
      }
    }
  }

  void _showSnackbar(String message) {
    setState(() {
      _showingSnackbar = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
    _startSnackbarTimer();
  }

  @override
  void initState() {
    super.initState();
    final laneDataNotifier = ref.read(laneDataProvider.notifier);
    laneDataNotifier.fetchScannedData();
    activeLane = Lane.one;
  }

  @override
  void dispose() {
    _snackbarTimer?.cancel();
    super.dispose();
  }

  void _loadSounds() {
    _soundId = _loadSound();
  }

  Future<int> _loadSound() async {
    var asset = await rootBundle.load("assets/dingShort.m4a");
    return await _soundpool.load(asset);
  }

  Future<void> _playSound() async {
    var _alarmSound = await _soundId;
    _scannedSoundStreamId = await _soundpool.play(_alarmSound);
  }

  void _startSnackbarTimer() {
    _snackbarTimer?.cancel();
    _snackbarTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _showingSnackbar = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final laneDataState = ref.watch(laneDataProvider);
    final appDatabase = ref.read(appDatabaseProvider);

    return Scaffold(
      appBar: getAppBar(),
      body: Stack(children: [
        MobileScanner(
          controller: MobileScannerController(
            detectionSpeed: DetectionSpeed.unrestricted,
            facing: CameraFacing.front,
          ),
          onDetect: (capture) {
            final List<Barcode> barcodes = capture.barcodes;
            final Uint8List? image = capture.image;
            for (final barcode in barcodes) {
              debugPrint('Barcode found! ${barcode.rawValue}');
              ref
                  .read(laneDataProvider.notifier)
                  .updateScannedData(barcode.rawValue!);
              appDatabase.insertLaneScan(
                LaneScansCompanion(
                  laneId: drift.Value(laneDataState.activeLane.index),
                  scannedData: drift.Value(barcode.rawValue!),
                  scannedAt: drift.Value(DateTime.now()),
                ),
              );
            }
          },
        ),
        Column(
          children: [
            !showCameraView ? getLaneView() : const SizedBox(),
          ],
        ),
      ]),
    );
    // ... (keep the existing code)
  }

  Widget getLaneView() {
    final propositionType = activeLane == Lane.three
        ? PropositionType.weAreBallot
        : PropositionType.buildingHighSchool;
    final propositionText =
        propositionType == PropositionType.buildingHighSchool
            ? '"Building of the new High School"'
            : '';
    final laneText = activeLane == Lane.one
        ? 'Yes'
        : activeLane == Lane.two
            ? 'No'
            : 'We Are the Ballot';

    return Expanded(
      child: Container(
        color: _getLaneColor(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  showScanCountdownMode
                      ? laneData[activeLane]!.scannableCount.toString()
                      : laneData[activeLane]!.scannedCount.toString(),
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontSize: 360, color: Colors.white),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Proposition 48',
                    style: TextStyle(color: Colors.white, fontSize: 54),
                    textAlign: TextAlign.center,
                  ),
                  if (propositionType == PropositionType.buildingHighSchool)
                    Text(
                      propositionText,
                      style: const TextStyle(color: Colors.white, fontSize: 54),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 16),
                  Text(
                    laneText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: propositionType == PropositionType.weAreBallot
                          ? 54
                          : 128,
                      fontWeight: propositionType == PropositionType.weAreBallot
                          ? FontWeight.normal
                          : FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  showScanCountdownMode
                      ? laneData[activeLane]!.scannableCount.toString()
                      : laneData[activeLane]!.scannedCount.toString(),
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontSize: 360, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getLaneColor() {
    switch (activeLane) {
      case Lane.one:
        return Colors.blue;
      case Lane.two:
        return Colors.green;
      case Lane.three:
        return Colors.orange;
    }
  }

  AppBar getAppBar() {
    final laneDataNotifier = ref.read(laneDataProvider.notifier);

    return AppBar(
      backgroundColor: _getLaneColor(),
      leading: TextButton(
        onPressed: () {
          setState(() {
            qrStatusWidget = const Text('');
            activeLane = _getNextLane();
          });
        },
        child: Text(
          _getLaneNumber(),
          style: TextStyle(
            color: _getLaneTextColor(),
            fontSize: 24,
          ),
        ),
      ),
      actions: [
        getCameraButton(),
        IconButton(
          onPressed: () {
            laneDataNotifier.resetLaneData();
          },
          icon: const Icon(Icons.refresh),
        ),
      ],
      centerTitle: true,
      title: Text(
        showCameraView ? (codeJustScanned ? 'Scanned code' : '') : '',
      ),
      elevation: 0,
    );
  }

  Lane _getNextLane() {
    switch (activeLane) {
      case Lane.one:
        return Lane.two;
      case Lane.two:
        return Lane.three;
      case Lane.three:
        return Lane.one;
    }
  }

  String _getLaneNumber() {
    switch (activeLane) {
      case Lane.one:
        return '1';
      case Lane.two:
        return '2';
      case Lane.three:
        return '3';
    }
  }

  Color _getLaneTextColor() {
    switch (activeLane) {
      case Lane.one:
        return Colors.blue[400]!;
      case Lane.two:
        return Colors.green[400]!;
      case Lane.three:
        return Colors.orange[400]!;
    }
  }

  Widget getCameraButton() {
    return IconButton(
      onPressed: () {
        setState(() {
          showCameraView = !showCameraView;
        });
      },
      icon: Icon(
        showCameraView == false ? Icons.camera_alt_outlined : Icons.close,
        color: activeLane == Lane.one
            ? Colors.blue[300]
            : activeLane == Lane.two
                ? Colors.green[300]
                : Colors.orange[300],
      ),
    );
  }
}
