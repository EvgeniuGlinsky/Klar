import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:klar/core/time/local_date.dart';
import 'package:klar/features/alarms/domain/models/sound_ref.dart';
import 'package:klar/features/tasks/domain/models/recurrence_rule.dart';

class LocalDateConverter extends TypeConverter<LocalDate, String> {
  const LocalDateConverter();

  @override
  LocalDate fromSql(String fromDb) => LocalDate.parse(fromDb);

  @override
  String toSql(LocalDate value) => value.iso;
}

class RecurrenceConverter extends TypeConverter<RecurrenceRule, String> {
  const RecurrenceConverter();

  @override
  RecurrenceRule fromSql(String fromDb) => RecurrenceRule.fromJson(jsonDecode(fromDb) as Map<String, Object?>);

  @override
  String toSql(RecurrenceRule value) => jsonEncode(value.toJson());
}

class SoundRefConverter extends TypeConverter<SoundRef, String> {
  const SoundRefConverter();

  @override
  SoundRef fromSql(String fromDb) => SoundRef.decode(fromDb)!;

  @override
  String toSql(SoundRef value) => value.encode();
}
