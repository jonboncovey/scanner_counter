import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
part 'database.g.dart';

class LaneScans extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get laneId => integer()();
  TextColumn get scannedData => text()();
  DateTimeColumn get scannedAt => dateTime()();
}

@DriftDatabase(tables: [LaneScans])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<int> insertLaneScan(LaneScansCompanion laneScan) async {
    return await into(laneScans).insert(laneScan);
  }

  Future<List<LaneScan>> getLaneScans() async {
    return await select(laneScans).get();
  }

  Future<int> deleteAllLaneScans() async {
    return await delete(laneScans).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
