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
