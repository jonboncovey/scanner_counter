// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $LaneScansTable extends LaneScans
    with TableInfo<$LaneScansTable, LaneScan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LaneScansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _laneIdMeta = const VerificationMeta('laneId');
  @override
  late final GeneratedColumn<int> laneId = GeneratedColumn<int>(
      'lane_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _scannedDataMeta =
      const VerificationMeta('scannedData');
  @override
  late final GeneratedColumn<String> scannedData = GeneratedColumn<String>(
      'scanned_data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scannedAtMeta =
      const VerificationMeta('scannedAt');
  @override
  late final GeneratedColumn<DateTime> scannedAt = GeneratedColumn<DateTime>(
      'scanned_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, laneId, scannedData, scannedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lane_scans';
  @override
  VerificationContext validateIntegrity(Insertable<LaneScan> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('lane_id')) {
      context.handle(_laneIdMeta,
          laneId.isAcceptableOrUnknown(data['lane_id']!, _laneIdMeta));
    } else if (isInserting) {
      context.missing(_laneIdMeta);
    }
    if (data.containsKey('scanned_data')) {
      context.handle(
          _scannedDataMeta,
          scannedData.isAcceptableOrUnknown(
              data['scanned_data']!, _scannedDataMeta));
    } else if (isInserting) {
      context.missing(_scannedDataMeta);
    }
    if (data.containsKey('scanned_at')) {
      context.handle(_scannedAtMeta,
          scannedAt.isAcceptableOrUnknown(data['scanned_at']!, _scannedAtMeta));
    } else if (isInserting) {
      context.missing(_scannedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LaneScan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LaneScan(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      laneId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}lane_id'])!,
      scannedData: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}scanned_data'])!,
      scannedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}scanned_at'])!,
    );
  }

  @override
  $LaneScansTable createAlias(String alias) {
    return $LaneScansTable(attachedDatabase, alias);
  }
}

class LaneScan extends DataClass implements Insertable<LaneScan> {
  final int id;
  final int laneId;
  final String scannedData;
  final DateTime scannedAt;
  const LaneScan(
      {required this.id,
      required this.laneId,
      required this.scannedData,
      required this.scannedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['lane_id'] = Variable<int>(laneId);
    map['scanned_data'] = Variable<String>(scannedData);
    map['scanned_at'] = Variable<DateTime>(scannedAt);
    return map;
  }

  LaneScansCompanion toCompanion(bool nullToAbsent) {
    return LaneScansCompanion(
      id: Value(id),
      laneId: Value(laneId),
      scannedData: Value(scannedData),
      scannedAt: Value(scannedAt),
    );
  }

  factory LaneScan.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LaneScan(
      id: serializer.fromJson<int>(json['id']),
      laneId: serializer.fromJson<int>(json['laneId']),
      scannedData: serializer.fromJson<String>(json['scannedData']),
      scannedAt: serializer.fromJson<DateTime>(json['scannedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'laneId': serializer.toJson<int>(laneId),
      'scannedData': serializer.toJson<String>(scannedData),
      'scannedAt': serializer.toJson<DateTime>(scannedAt),
    };
  }

  LaneScan copyWith(
          {int? id, int? laneId, String? scannedData, DateTime? scannedAt}) =>
      LaneScan(
        id: id ?? this.id,
        laneId: laneId ?? this.laneId,
        scannedData: scannedData ?? this.scannedData,
        scannedAt: scannedAt ?? this.scannedAt,
      );
  @override
  String toString() {
    return (StringBuffer('LaneScan(')
          ..write('id: $id, ')
          ..write('laneId: $laneId, ')
          ..write('scannedData: $scannedData, ')
          ..write('scannedAt: $scannedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, laneId, scannedData, scannedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LaneScan &&
          other.id == this.id &&
          other.laneId == this.laneId &&
          other.scannedData == this.scannedData &&
          other.scannedAt == this.scannedAt);
}

class LaneScansCompanion extends UpdateCompanion<LaneScan> {
  final Value<int> id;
  final Value<int> laneId;
  final Value<String> scannedData;
  final Value<DateTime> scannedAt;
  const LaneScansCompanion({
    this.id = const Value.absent(),
    this.laneId = const Value.absent(),
    this.scannedData = const Value.absent(),
    this.scannedAt = const Value.absent(),
  });
  LaneScansCompanion.insert({
    this.id = const Value.absent(),
    required int laneId,
    required String scannedData,
    required DateTime scannedAt,
  })  : laneId = Value(laneId),
        scannedData = Value(scannedData),
        scannedAt = Value(scannedAt);
  static Insertable<LaneScan> custom({
    Expression<int>? id,
    Expression<int>? laneId,
    Expression<String>? scannedData,
    Expression<DateTime>? scannedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (laneId != null) 'lane_id': laneId,
      if (scannedData != null) 'scanned_data': scannedData,
      if (scannedAt != null) 'scanned_at': scannedAt,
    });
  }

  LaneScansCompanion copyWith(
      {Value<int>? id,
      Value<int>? laneId,
      Value<String>? scannedData,
      Value<DateTime>? scannedAt}) {
    return LaneScansCompanion(
      id: id ?? this.id,
      laneId: laneId ?? this.laneId,
      scannedData: scannedData ?? this.scannedData,
      scannedAt: scannedAt ?? this.scannedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (laneId.present) {
      map['lane_id'] = Variable<int>(laneId.value);
    }
    if (scannedData.present) {
      map['scanned_data'] = Variable<String>(scannedData.value);
    }
    if (scannedAt.present) {
      map['scanned_at'] = Variable<DateTime>(scannedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LaneScansCompanion(')
          ..write('id: $id, ')
          ..write('laneId: $laneId, ')
          ..write('scannedData: $scannedData, ')
          ..write('scannedAt: $scannedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $LaneScansTable laneScans = $LaneScansTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [laneScans];
}
