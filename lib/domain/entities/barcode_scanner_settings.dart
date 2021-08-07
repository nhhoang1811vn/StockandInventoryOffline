class BarcodeScannerSettings {
  bool enableVibrate = false;
  bool enableBeep = false;
  BatchModeScan batchModeScan = BatchModeScan.AUTO;
}

enum BatchModeScan { AUTO, MANUALLY }

class BatchModeScanHelper {
  static BatchModeScan get(int value) {
    switch (value) {
      case 0:
        {
          return BatchModeScan.AUTO;
        }
      default:
        {
          return BatchModeScan.MANUALLY;
        }
    }
  }

  static int getValue(BatchModeScan a) {
    switch (a) {
      case BatchModeScan.AUTO:
        {
          return 0;
        }
      default:
        {
          return 1;
        }
    }
  }
}
