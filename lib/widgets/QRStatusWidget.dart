import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum QRStatus {
  blank,
  failed,
  alreadyScanned,
  successfullyScanned,
  scanningComplete,
}

class QRStatusWidget extends StatelessWidget {
  final QRStatus qrStatus;

  QRStatusWidget({this.qrStatus = QRStatus.blank});

  @override
  Widget build(BuildContext context) {
    switch (qrStatus) {
      case QRStatus.blank:
        {
          return Container();
        }
      case QRStatus.failed:
        {
          return Container();
        }
      case QRStatus.alreadyScanned:
        {
          return const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Already Scanned',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 24,
                  )),
              SizedBox(width: 8),
              Icon(
                Icons.cancel_outlined,
                color: Colors.red,
              )
            ],
          );
        }
      case QRStatus.successfullyScanned:
        {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Successfully scanned',
                style: TextStyle(color: Colors.green[100], fontSize: 24),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.check_circle_outline,
                color: Colors.green,
              )
            ],
          );
        }
      case QRStatus.scanningComplete:
        {
          return const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'All tickets scanned',
                style: TextStyle(color: Colors.green, fontSize: 24),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.check_circle_outline,
                color: Colors.green,
              )
            ],
          );
        }
    }
    return Container();
  }
}
