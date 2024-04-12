import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scanner_counter/riverpod_version/database.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});
