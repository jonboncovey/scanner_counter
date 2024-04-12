import 'dart:async';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:soundpool/soundpool.dart';

class LaneData {
  LaneData({
    required this.selectedLane,
    required this.scannableCount,
    required this.scannedData,
    required this.scannedCount,
  });

  int selectedLane;
  int scannedCount;
  int scannableCount;
  List<String> scannedData;
}

class ScannerPage extends StatefulWidget {
  final Soundpool pool;
  final ValueSetter<SoundpoolOptions> onOptionsChange;

  const ScannerPage(
      {Key? key, required this.pool, required this.onOptionsChange})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ScannerPageState();
  }
}

class _ScannerPageState extends State<ScannerPage> {
  Soundpool get _soundpool => widget.pool;
  int? _scannedSoundStreamId;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  LaneData laneOne = LaneData(
      selectedLane: 1, scannableCount: 50, scannedData: [], scannedCount: 0);
  LaneData laneTwo = LaneData(
      selectedLane: 2, scannableCount: 50, scannedData: [], scannedCount: 0);
  LaneData laneThree = LaneData(
      selectedLane: 3, scannableCount: 50, scannedData: [], scannedCount: 0);
  late LaneData activeLane;

  String qrStatus = 'Looking for scannable items...';
  bool showCameraView = false;
  bool showScanCountdownMode = false;
  Widget qrStatusWidget = Container();
  bool codeJustScanned = false;
  DateTime? _lastSuccessfulScanTime;

  bool _showingSnackbar = false;
  Timer? _snackbarTimer;

  late Future<int> _soundId;

  @override
  void initState() {
    super.initState();
    activeLane = laneOne;
    _loadSounds();
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
    print('hitting page');
    return Scaffold(
      appBar: getAppBar(),
      body: Stack(children: [
        MobileScanner(
          // fit: BoxFit.contain,
          controller: MobileScannerController(
            detectionSpeed: DetectionSpeed.unrestricted,
            facing: CameraFacing.front,
            // torchEnabled: true,
          ),
          onDetect: (capture) {
            final List<Barcode> barcodes = capture.barcodes;
            final Uint8List? image = capture.image;
            for (final barcode in barcodes) {
              debugPrint('Barcode found! ${barcode.rawValue}');

              setState(
                () {
                  if (activeLane.scannedCount < activeLane.scannableCount &&
                      activeLane.scannedData.contains(barcode.rawValue) ==
                          false) {
                    if (barcode.rawValue != null) {
                      print(
                          'adding ${barcode.rawValue} to ${activeLane.scannedData}');
                      codeJustScanned = true;
                      _playSound();
                      activeLane.scannedData.add(barcode.rawValue!);
                      activeLane.scannedCount += 1;
                      _lastSuccessfulScanTime = DateTime
                          .now(); // Update the last successful scan time
                      Timer(const Duration(seconds: 1), () {
                        codeJustScanned = false;
                      });
                    }
                  } else if (activeLane.scannedCount ==
                      activeLane.scannableCount) {
                    print('scanned count == scannable count');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Scanning complete'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else if (activeLane.scannedData
                      .contains(barcode.rawValue)) {
                    print('activeLane.scannedData.contains(barcode.rawValue)');
                    // Check if at least 3 seconds have passed since the last successful scan
                    if (!_showingSnackbar &&
                        (_lastSuccessfulScanTime == null ||
                            DateTime.now()
                                    .difference(_lastSuccessfulScanTime!)
                                    .inSeconds >=
                                3)) {
                      _showingSnackbar = true;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Already scanned'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      _startSnackbarTimer();
                    }
                  }
                },
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
  }

  getLaneView() {
    return Expanded(
      child: Container(
        color: activeLane == laneOne
            ? Colors.blue
            : activeLane == laneTwo
                ? Colors.green
                : Colors.orange,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  showScanCountdownMode
                      ? activeLane.scannableCount.toString()
                      : activeLane.scannedCount.toString(),
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
                    Text(
                      activeLane == laneOne
                          ? 'Proposition 48'
                          : activeLane == laneTwo
                              ? 'Proposition 48'
                              : 'Proposition 49',
                      style: const TextStyle(color: Colors.white, fontSize: 54),
                      textAlign: TextAlign.center,
                    ),
                    activeLane == laneOne || activeLane == laneTwo
                        ? const Text(
                            '“Building of the new High School”',
                            style: TextStyle(color: Colors.white, fontSize: 54),
                            textAlign: TextAlign.center,
                          )
                        : const SizedBox(),
                    const SizedBox(height: 16),
                    Text(
                      activeLane == laneOne
                          ? "Yes"
                          : activeLane == laneTwo
                              ? "No"
                              : "We Are the Ballot",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 128,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ]),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  showScanCountdownMode
                      ? activeLane.scannableCount.toString()
                      : activeLane.scannedCount.toString(),
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

  AppBar getAppBar() {
    final player = AudioPlayer();
    return AppBar(
      backgroundColor: activeLane == laneOne
          ? Colors.blue
          : activeLane == laneTwo
              ? Colors.green
              : Colors.orange,
      leading: TextButton(
        onPressed: () {
          setState(() {
            // player.play(AssetSource('dingShort.mp3'));
            qrStatusWidget = const Text('');
            activeLane = activeLane == laneOne
                ? laneTwo
                : activeLane == laneTwo
                    ? laneThree
                    : laneOne;
          });
        },
        child: Text(
          activeLane == laneOne
              ? "1"
              : activeLane == laneTwo
                  ? "2"
                  : "3",
          style: TextStyle(
              color: activeLane == laneOne
                  ? Colors.blue[400]
                  : activeLane == laneTwo
                      ? Colors.green[400]
                      : Colors.orange[400],
              fontSize: 24),
        ),
      ),
      actions: [getCameraButton()],
      centerTitle: true,
      title: Text(showCameraView
          ? codeJustScanned
              ? 'Scanned code'
              : ''
          : ''),
      elevation: 0,
    );
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
        color: activeLane == laneOne ? Colors.blue[300] : Colors.green[300],
      ),
    );
  }
}
