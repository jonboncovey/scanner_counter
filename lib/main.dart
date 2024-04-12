import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scanner_counter/ScanningPage.dart';
import 'package:scanner_counter/widgets/SoundpoolInitializer.dart';

// import 'river/CounterProviders.dart';
// import 'ScanningPage.dart';
// import 'river/ScanningPageRiver.dart';

void main() {
  runApp(const ProviderScope(
    child: MaterialApp(home: MyHome()),
  ));
}

class MyHome extends ConsumerWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final String value = ref.watch(helloWorldProvider);

    return SoundpoolInitializer();
  }
}
