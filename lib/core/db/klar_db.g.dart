// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'klar_db.dart';

// ignore_for_file: type=lint
class $TaskListsTableTable extends TaskListsTable
    with TableInfo<$TaskListsTableTable, TaskListRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskListsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorKeyMeta = const VerificationMeta(
    'colorKey',
  );
  @override
  late final GeneratedColumn<String> colorKey = GeneratedColumn<String>(
    'color_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconKeyMeta = const VerificationMeta(
    'iconKey',
  );
  @override
  late final GeneratedColumn<String> iconKey = GeneratedColumn<String>(
    'icon_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    colorKey,
    iconKey,
    sortOrder,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_lists';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskListRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color_key')) {
      context.handle(
        _colorKeyMeta,
        colorKey.isAcceptableOrUnknown(data['color_key']!, _colorKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_colorKeyMeta);
    }
    if (data.containsKey('icon_key')) {
      context.handle(
        _iconKeyMeta,
        iconKey.isAcceptableOrUnknown(data['icon_key']!, _iconKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_iconKeyMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskListRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskListRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      colorKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_key'],
      )!,
      iconKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_key'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TaskListsTableTable createAlias(String alias) {
    return $TaskListsTableTable(attachedDatabase, alias);
  }
}

class TaskListRow extends DataClass implements Insertable<TaskListRow> {
  final String id;
  final String name;
  final String colorKey;
  final String iconKey;
  final int sortOrder;
  final DateTime createdAt;
  const TaskListRow({
    required this.id,
    required this.name,
    required this.colorKey,
    required this.iconKey,
    required this.sortOrder,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['color_key'] = Variable<String>(colorKey);
    map['icon_key'] = Variable<String>(iconKey);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TaskListsTableCompanion toCompanion(bool nullToAbsent) {
    return TaskListsTableCompanion(
      id: Value(id),
      name: Value(name),
      colorKey: Value(colorKey),
      iconKey: Value(iconKey),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
    );
  }

  factory TaskListRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskListRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      colorKey: serializer.fromJson<String>(json['colorKey']),
      iconKey: serializer.fromJson<String>(json['iconKey']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'colorKey': serializer.toJson<String>(colorKey),
      'iconKey': serializer.toJson<String>(iconKey),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TaskListRow copyWith({
    String? id,
    String? name,
    String? colorKey,
    String? iconKey,
    int? sortOrder,
    DateTime? createdAt,
  }) => TaskListRow(
    id: id ?? this.id,
    name: name ?? this.name,
    colorKey: colorKey ?? this.colorKey,
    iconKey: iconKey ?? this.iconKey,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
  );
  TaskListRow copyWithCompanion(TaskListsTableCompanion data) {
    return TaskListRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      colorKey: data.colorKey.present ? data.colorKey.value : this.colorKey,
      iconKey: data.iconKey.present ? data.iconKey.value : this.iconKey,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskListRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorKey: $colorKey, ')
          ..write('iconKey: $iconKey, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, colorKey, iconKey, sortOrder, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskListRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.colorKey == this.colorKey &&
          other.iconKey == this.iconKey &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt);
}

class TaskListsTableCompanion extends UpdateCompanion<TaskListRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> colorKey;
  final Value<String> iconKey;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TaskListsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.colorKey = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskListsTableCompanion.insert({
    required String id,
    required String name,
    required String colorKey,
    required String iconKey,
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       colorKey = Value(colorKey),
       iconKey = Value(iconKey),
       createdAt = Value(createdAt);
  static Insertable<TaskListRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? colorKey,
    Expression<String>? iconKey,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (colorKey != null) 'color_key': colorKey,
      if (iconKey != null) 'icon_key': iconKey,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskListsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? colorKey,
    Value<String>? iconKey,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return TaskListsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      colorKey: colorKey ?? this.colorKey,
      iconKey: iconKey ?? this.iconKey,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (colorKey.present) {
      map['color_key'] = Variable<String>(colorKey.value);
    }
    if (iconKey.present) {
      map['icon_key'] = Variable<String>(iconKey.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskListsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorKey: $colorKey, ')
          ..write('iconKey: $iconKey, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TasksTableTable extends TasksTable
    with TableInfo<$TasksTableTable, TaskRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _listIdMeta = const VerificationMeta('listId');
  @override
  late final GeneratedColumn<String> listId = GeneratedColumn<String>(
    'list_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES task_lists (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Priority, int> priority =
      GeneratedColumn<int>(
        'priority',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<Priority>($TasksTableTable.$converterpriority);
  @override
  late final GeneratedColumnWithTypeConverter<LocalDate?, String> dueDate =
      GeneratedColumn<String>(
        'due_date',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<LocalDate?>($TasksTableTable.$converterdueDaten);
  static const VerificationMeta _dueTimeMeta = const VerificationMeta(
    'dueTime',
  );
  @override
  late final GeneratedColumn<int> dueTime = GeneratedColumn<int>(
    'due_time',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<RecurrenceRule?, String>
  recurrence = GeneratedColumn<String>(
    'recurrence',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<RecurrenceRule?>($TasksTableTable.$converterrecurrencen);
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<SoundRef?, String> sound =
      GeneratedColumn<String>(
        'sound',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<SoundRef?>($TasksTableTable.$convertersoundn);
  @override
  late final GeneratedColumnWithTypeConverter<VibrationPattern?, String>
  vibration = GeneratedColumn<String>(
    'vibration',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<VibrationPattern?>($TasksTableTable.$convertervibrationn);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    listId,
    title,
    notes,
    priority,
    dueDate,
    dueTime,
    recurrence,
    completedAt,
    createdAt,
    sortOrder,
    sound,
    vibration,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('list_id')) {
      context.handle(
        _listIdMeta,
        listId.isAcceptableOrUnknown(data['list_id']!, _listIdMeta),
      );
    } else if (isInserting) {
      context.missing(_listIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('due_time')) {
      context.handle(
        _dueTimeMeta,
        dueTime.isAcceptableOrUnknown(data['due_time']!, _dueTimeMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      listId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}list_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      priority: $TasksTableTable.$converterpriority.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}priority'],
        )!,
      ),
      dueDate: $TasksTableTable.$converterdueDaten.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}due_date'],
        ),
      ),
      dueTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_time'],
      ),
      recurrence: $TasksTableTable.$converterrecurrencen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}recurrence'],
        ),
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      sound: $TasksTableTable.$convertersoundn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sound'],
        ),
      ),
      vibration: $TasksTableTable.$convertervibrationn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}vibration'],
        ),
      ),
    );
  }

  @override
  $TasksTableTable createAlias(String alias) {
    return $TasksTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Priority, int, int> $converterpriority =
      const EnumIndexConverter<Priority>(Priority.values);
  static TypeConverter<LocalDate, String> $converterdueDate =
      const LocalDateConverter();
  static TypeConverter<LocalDate?, String?> $converterdueDaten =
      NullAwareTypeConverter.wrap($converterdueDate);
  static TypeConverter<RecurrenceRule, String> $converterrecurrence =
      const RecurrenceConverter();
  static TypeConverter<RecurrenceRule?, String?> $converterrecurrencen =
      NullAwareTypeConverter.wrap($converterrecurrence);
  static TypeConverter<SoundRef, String> $convertersound =
      const SoundRefConverter();
  static TypeConverter<SoundRef?, String?> $convertersoundn =
      NullAwareTypeConverter.wrap($convertersound);
  static JsonTypeConverter2<VibrationPattern, String, String>
  $convertervibration = const EnumNameConverter<VibrationPattern>(
    VibrationPattern.values,
  );
  static JsonTypeConverter2<VibrationPattern?, String?, String?>
  $convertervibrationn = JsonTypeConverter2.asNullable($convertervibration);
}

class TaskRow extends DataClass implements Insertable<TaskRow> {
  final String id;
  final String listId;
  final String title;
  final String notes;
  final Priority priority;
  final LocalDate? dueDate;
  final int? dueTime;
  final RecurrenceRule? recurrence;
  final DateTime? completedAt;
  final DateTime createdAt;
  final int sortOrder;
  final SoundRef? sound;
  final VibrationPattern? vibration;
  const TaskRow({
    required this.id,
    required this.listId,
    required this.title,
    required this.notes,
    required this.priority,
    this.dueDate,
    this.dueTime,
    this.recurrence,
    this.completedAt,
    required this.createdAt,
    required this.sortOrder,
    this.sound,
    this.vibration,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['list_id'] = Variable<String>(listId);
    map['title'] = Variable<String>(title);
    map['notes'] = Variable<String>(notes);
    {
      map['priority'] = Variable<int>(
        $TasksTableTable.$converterpriority.toSql(priority),
      );
    }
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<String>(
        $TasksTableTable.$converterdueDaten.toSql(dueDate),
      );
    }
    if (!nullToAbsent || dueTime != null) {
      map['due_time'] = Variable<int>(dueTime);
    }
    if (!nullToAbsent || recurrence != null) {
      map['recurrence'] = Variable<String>(
        $TasksTableTable.$converterrecurrencen.toSql(recurrence),
      );
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || sound != null) {
      map['sound'] = Variable<String>(
        $TasksTableTable.$convertersoundn.toSql(sound),
      );
    }
    if (!nullToAbsent || vibration != null) {
      map['vibration'] = Variable<String>(
        $TasksTableTable.$convertervibrationn.toSql(vibration),
      );
    }
    return map;
  }

  TasksTableCompanion toCompanion(bool nullToAbsent) {
    return TasksTableCompanion(
      id: Value(id),
      listId: Value(listId),
      title: Value(title),
      notes: Value(notes),
      priority: Value(priority),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      dueTime: dueTime == null && nullToAbsent
          ? const Value.absent()
          : Value(dueTime),
      recurrence: recurrence == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrence),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      createdAt: Value(createdAt),
      sortOrder: Value(sortOrder),
      sound: sound == null && nullToAbsent
          ? const Value.absent()
          : Value(sound),
      vibration: vibration == null && nullToAbsent
          ? const Value.absent()
          : Value(vibration),
    );
  }

  factory TaskRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskRow(
      id: serializer.fromJson<String>(json['id']),
      listId: serializer.fromJson<String>(json['listId']),
      title: serializer.fromJson<String>(json['title']),
      notes: serializer.fromJson<String>(json['notes']),
      priority: $TasksTableTable.$converterpriority.fromJson(
        serializer.fromJson<int>(json['priority']),
      ),
      dueDate: serializer.fromJson<LocalDate?>(json['dueDate']),
      dueTime: serializer.fromJson<int?>(json['dueTime']),
      recurrence: serializer.fromJson<RecurrenceRule?>(json['recurrence']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      sound: serializer.fromJson<SoundRef?>(json['sound']),
      vibration: $TasksTableTable.$convertervibrationn.fromJson(
        serializer.fromJson<String?>(json['vibration']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'listId': serializer.toJson<String>(listId),
      'title': serializer.toJson<String>(title),
      'notes': serializer.toJson<String>(notes),
      'priority': serializer.toJson<int>(
        $TasksTableTable.$converterpriority.toJson(priority),
      ),
      'dueDate': serializer.toJson<LocalDate?>(dueDate),
      'dueTime': serializer.toJson<int?>(dueTime),
      'recurrence': serializer.toJson<RecurrenceRule?>(recurrence),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'sound': serializer.toJson<SoundRef?>(sound),
      'vibration': serializer.toJson<String?>(
        $TasksTableTable.$convertervibrationn.toJson(vibration),
      ),
    };
  }

  TaskRow copyWith({
    String? id,
    String? listId,
    String? title,
    String? notes,
    Priority? priority,
    Value<LocalDate?> dueDate = const Value.absent(),
    Value<int?> dueTime = const Value.absent(),
    Value<RecurrenceRule?> recurrence = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
    DateTime? createdAt,
    int? sortOrder,
    Value<SoundRef?> sound = const Value.absent(),
    Value<VibrationPattern?> vibration = const Value.absent(),
  }) => TaskRow(
    id: id ?? this.id,
    listId: listId ?? this.listId,
    title: title ?? this.title,
    notes: notes ?? this.notes,
    priority: priority ?? this.priority,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    dueTime: dueTime.present ? dueTime.value : this.dueTime,
    recurrence: recurrence.present ? recurrence.value : this.recurrence,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    createdAt: createdAt ?? this.createdAt,
    sortOrder: sortOrder ?? this.sortOrder,
    sound: sound.present ? sound.value : this.sound,
    vibration: vibration.present ? vibration.value : this.vibration,
  );
  TaskRow copyWithCompanion(TasksTableCompanion data) {
    return TaskRow(
      id: data.id.present ? data.id.value : this.id,
      listId: data.listId.present ? data.listId.value : this.listId,
      title: data.title.present ? data.title.value : this.title,
      notes: data.notes.present ? data.notes.value : this.notes,
      priority: data.priority.present ? data.priority.value : this.priority,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      dueTime: data.dueTime.present ? data.dueTime.value : this.dueTime,
      recurrence: data.recurrence.present
          ? data.recurrence.value
          : this.recurrence,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      sound: data.sound.present ? data.sound.value : this.sound,
      vibration: data.vibration.present ? data.vibration.value : this.vibration,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskRow(')
          ..write('id: $id, ')
          ..write('listId: $listId, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('priority: $priority, ')
          ..write('dueDate: $dueDate, ')
          ..write('dueTime: $dueTime, ')
          ..write('recurrence: $recurrence, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('sound: $sound, ')
          ..write('vibration: $vibration')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    listId,
    title,
    notes,
    priority,
    dueDate,
    dueTime,
    recurrence,
    completedAt,
    createdAt,
    sortOrder,
    sound,
    vibration,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskRow &&
          other.id == this.id &&
          other.listId == this.listId &&
          other.title == this.title &&
          other.notes == this.notes &&
          other.priority == this.priority &&
          other.dueDate == this.dueDate &&
          other.dueTime == this.dueTime &&
          other.recurrence == this.recurrence &&
          other.completedAt == this.completedAt &&
          other.createdAt == this.createdAt &&
          other.sortOrder == this.sortOrder &&
          other.sound == this.sound &&
          other.vibration == this.vibration);
}

class TasksTableCompanion extends UpdateCompanion<TaskRow> {
  final Value<String> id;
  final Value<String> listId;
  final Value<String> title;
  final Value<String> notes;
  final Value<Priority> priority;
  final Value<LocalDate?> dueDate;
  final Value<int?> dueTime;
  final Value<RecurrenceRule?> recurrence;
  final Value<DateTime?> completedAt;
  final Value<DateTime> createdAt;
  final Value<int> sortOrder;
  final Value<SoundRef?> sound;
  final Value<VibrationPattern?> vibration;
  final Value<int> rowid;
  const TasksTableCompanion({
    this.id = const Value.absent(),
    this.listId = const Value.absent(),
    this.title = const Value.absent(),
    this.notes = const Value.absent(),
    this.priority = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.dueTime = const Value.absent(),
    this.recurrence = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.sound = const Value.absent(),
    this.vibration = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksTableCompanion.insert({
    required String id,
    required String listId,
    required String title,
    this.notes = const Value.absent(),
    this.priority = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.dueTime = const Value.absent(),
    this.recurrence = const Value.absent(),
    this.completedAt = const Value.absent(),
    required DateTime createdAt,
    this.sortOrder = const Value.absent(),
    this.sound = const Value.absent(),
    this.vibration = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       listId = Value(listId),
       title = Value(title),
       createdAt = Value(createdAt);
  static Insertable<TaskRow> custom({
    Expression<String>? id,
    Expression<String>? listId,
    Expression<String>? title,
    Expression<String>? notes,
    Expression<int>? priority,
    Expression<String>? dueDate,
    Expression<int>? dueTime,
    Expression<String>? recurrence,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? createdAt,
    Expression<int>? sortOrder,
    Expression<String>? sound,
    Expression<String>? vibration,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (listId != null) 'list_id': listId,
      if (title != null) 'title': title,
      if (notes != null) 'notes': notes,
      if (priority != null) 'priority': priority,
      if (dueDate != null) 'due_date': dueDate,
      if (dueTime != null) 'due_time': dueTime,
      if (recurrence != null) 'recurrence': recurrence,
      if (completedAt != null) 'completed_at': completedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (sound != null) 'sound': sound,
      if (vibration != null) 'vibration': vibration,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksTableCompanion copyWith({
    Value<String>? id,
    Value<String>? listId,
    Value<String>? title,
    Value<String>? notes,
    Value<Priority>? priority,
    Value<LocalDate?>? dueDate,
    Value<int?>? dueTime,
    Value<RecurrenceRule?>? recurrence,
    Value<DateTime?>? completedAt,
    Value<DateTime>? createdAt,
    Value<int>? sortOrder,
    Value<SoundRef?>? sound,
    Value<VibrationPattern?>? vibration,
    Value<int>? rowid,
  }) {
    return TasksTableCompanion(
      id: id ?? this.id,
      listId: listId ?? this.listId,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      dueTime: dueTime ?? this.dueTime,
      recurrence: recurrence ?? this.recurrence,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      sortOrder: sortOrder ?? this.sortOrder,
      sound: sound ?? this.sound,
      vibration: vibration ?? this.vibration,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (listId.present) {
      map['list_id'] = Variable<String>(listId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(
        $TasksTableTable.$converterpriority.toSql(priority.value),
      );
    }
    if (dueDate.present) {
      map['due_date'] = Variable<String>(
        $TasksTableTable.$converterdueDaten.toSql(dueDate.value),
      );
    }
    if (dueTime.present) {
      map['due_time'] = Variable<int>(dueTime.value);
    }
    if (recurrence.present) {
      map['recurrence'] = Variable<String>(
        $TasksTableTable.$converterrecurrencen.toSql(recurrence.value),
      );
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (sound.present) {
      map['sound'] = Variable<String>(
        $TasksTableTable.$convertersoundn.toSql(sound.value),
      );
    }
    if (vibration.present) {
      map['vibration'] = Variable<String>(
        $TasksTableTable.$convertervibrationn.toSql(vibration.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksTableCompanion(')
          ..write('id: $id, ')
          ..write('listId: $listId, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('priority: $priority, ')
          ..write('dueDate: $dueDate, ')
          ..write('dueTime: $dueTime, ')
          ..write('recurrence: $recurrence, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('sound: $sound, ')
          ..write('vibration: $vibration, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubtasksTableTable extends SubtasksTable
    with TableInfo<$SubtasksTableTable, SubtaskRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubtasksTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doneMeta = const VerificationMeta('done');
  @override
  late final GeneratedColumn<bool> done = GeneratedColumn<bool>(
    'done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, taskId, title, done, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subtasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubtaskRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('done')) {
      context.handle(
        _doneMeta,
        done.isAcceptableOrUnknown(data['done']!, _doneMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubtaskRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubtaskRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      done: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}done'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $SubtasksTableTable createAlias(String alias) {
    return $SubtasksTableTable(attachedDatabase, alias);
  }
}

class SubtaskRow extends DataClass implements Insertable<SubtaskRow> {
  final String id;
  final String taskId;
  final String title;
  final bool done;
  final int sortOrder;
  const SubtaskRow({
    required this.id,
    required this.taskId,
    required this.title,
    required this.done,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_id'] = Variable<String>(taskId);
    map['title'] = Variable<String>(title);
    map['done'] = Variable<bool>(done);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  SubtasksTableCompanion toCompanion(bool nullToAbsent) {
    return SubtasksTableCompanion(
      id: Value(id),
      taskId: Value(taskId),
      title: Value(title),
      done: Value(done),
      sortOrder: Value(sortOrder),
    );
  }

  factory SubtaskRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubtaskRow(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      title: serializer.fromJson<String>(json['title']),
      done: serializer.fromJson<bool>(json['done']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String>(taskId),
      'title': serializer.toJson<String>(title),
      'done': serializer.toJson<bool>(done),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  SubtaskRow copyWith({
    String? id,
    String? taskId,
    String? title,
    bool? done,
    int? sortOrder,
  }) => SubtaskRow(
    id: id ?? this.id,
    taskId: taskId ?? this.taskId,
    title: title ?? this.title,
    done: done ?? this.done,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  SubtaskRow copyWithCompanion(SubtasksTableCompanion data) {
    return SubtaskRow(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      title: data.title.present ? data.title.value : this.title,
      done: data.done.present ? data.done.value : this.done,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubtaskRow(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('title: $title, ')
          ..write('done: $done, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, taskId, title, done, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubtaskRow &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.title == this.title &&
          other.done == this.done &&
          other.sortOrder == this.sortOrder);
}

class SubtasksTableCompanion extends UpdateCompanion<SubtaskRow> {
  final Value<String> id;
  final Value<String> taskId;
  final Value<String> title;
  final Value<bool> done;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const SubtasksTableCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.title = const Value.absent(),
    this.done = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubtasksTableCompanion.insert({
    required String id,
    required String taskId,
    required String title,
    this.done = const Value.absent(),
    required int sortOrder,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       taskId = Value(taskId),
       title = Value(title),
       sortOrder = Value(sortOrder);
  static Insertable<SubtaskRow> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<String>? title,
    Expression<bool>? done,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (title != null) 'title': title,
      if (done != null) 'done': done,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubtasksTableCompanion copyWith({
    Value<String>? id,
    Value<String>? taskId,
    Value<String>? title,
    Value<bool>? done,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return SubtasksTableCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      done: done ?? this.done,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (done.present) {
      map['done'] = Variable<bool>(done.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubtasksTableCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('title: $title, ')
          ..write('done: $done, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RemindersTableTable extends RemindersTable
    with TableInfo<$RemindersTableTable, ReminderRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _offsetMinutesMeta = const VerificationMeta(
    'offsetMinutes',
  );
  @override
  late final GeneratedColumn<int> offsetMinutes = GeneratedColumn<int>(
    'offset_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ReminderKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ReminderKind>($RemindersTableTable.$converterkind);
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taskId,
    offsetMinutes,
    kind,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReminderRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('offset_minutes')) {
      context.handle(
        _offsetMinutesMeta,
        offsetMinutes.isAcceptableOrUnknown(
          data['offset_minutes']!,
          _offsetMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_offsetMinutesMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReminderRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReminderRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      offsetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}offset_minutes'],
      )!,
      kind: $RemindersTableTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $RemindersTableTable createAlias(String alias) {
    return $RemindersTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ReminderKind, String, String> $converterkind =
      const EnumNameConverter<ReminderKind>(ReminderKind.values);
}

class ReminderRow extends DataClass implements Insertable<ReminderRow> {
  final String id;
  final String taskId;
  final int offsetMinutes;
  final ReminderKind kind;
  final int sortOrder;
  const ReminderRow({
    required this.id,
    required this.taskId,
    required this.offsetMinutes,
    required this.kind,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_id'] = Variable<String>(taskId);
    map['offset_minutes'] = Variable<int>(offsetMinutes);
    {
      map['kind'] = Variable<String>(
        $RemindersTableTable.$converterkind.toSql(kind),
      );
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  RemindersTableCompanion toCompanion(bool nullToAbsent) {
    return RemindersTableCompanion(
      id: Value(id),
      taskId: Value(taskId),
      offsetMinutes: Value(offsetMinutes),
      kind: Value(kind),
      sortOrder: Value(sortOrder),
    );
  }

  factory ReminderRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReminderRow(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      offsetMinutes: serializer.fromJson<int>(json['offsetMinutes']),
      kind: $RemindersTableTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String>(taskId),
      'offsetMinutes': serializer.toJson<int>(offsetMinutes),
      'kind': serializer.toJson<String>(
        $RemindersTableTable.$converterkind.toJson(kind),
      ),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  ReminderRow copyWith({
    String? id,
    String? taskId,
    int? offsetMinutes,
    ReminderKind? kind,
    int? sortOrder,
  }) => ReminderRow(
    id: id ?? this.id,
    taskId: taskId ?? this.taskId,
    offsetMinutes: offsetMinutes ?? this.offsetMinutes,
    kind: kind ?? this.kind,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  ReminderRow copyWithCompanion(RemindersTableCompanion data) {
    return ReminderRow(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      offsetMinutes: data.offsetMinutes.present
          ? data.offsetMinutes.value
          : this.offsetMinutes,
      kind: data.kind.present ? data.kind.value : this.kind,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReminderRow(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('offsetMinutes: $offsetMinutes, ')
          ..write('kind: $kind, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, taskId, offsetMinutes, kind, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReminderRow &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.offsetMinutes == this.offsetMinutes &&
          other.kind == this.kind &&
          other.sortOrder == this.sortOrder);
}

class RemindersTableCompanion extends UpdateCompanion<ReminderRow> {
  final Value<String> id;
  final Value<String> taskId;
  final Value<int> offsetMinutes;
  final Value<ReminderKind> kind;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const RemindersTableCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.offsetMinutes = const Value.absent(),
    this.kind = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RemindersTableCompanion.insert({
    required String id,
    required String taskId,
    required int offsetMinutes,
    required ReminderKind kind,
    required int sortOrder,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       taskId = Value(taskId),
       offsetMinutes = Value(offsetMinutes),
       kind = Value(kind),
       sortOrder = Value(sortOrder);
  static Insertable<ReminderRow> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<int>? offsetMinutes,
    Expression<String>? kind,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (offsetMinutes != null) 'offset_minutes': offsetMinutes,
      if (kind != null) 'kind': kind,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RemindersTableCompanion copyWith({
    Value<String>? id,
    Value<String>? taskId,
    Value<int>? offsetMinutes,
    Value<ReminderKind>? kind,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return RemindersTableCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      offsetMinutes: offsetMinutes ?? this.offsetMinutes,
      kind: kind ?? this.kind,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (offsetMinutes.present) {
      map['offset_minutes'] = Variable<int>(offsetMinutes.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $RemindersTableTable.$converterkind.toSql(kind.value),
      );
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersTableCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('offsetMinutes: $offsetMinutes, ')
          ..write('kind: $kind, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CompletionsTableTable extends CompletionsTable
    with TableInfo<$CompletionsTableTable, CompletionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompletionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<LocalDate, String> occurrence =
      GeneratedColumn<String>(
        'occurrence',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LocalDate>($CompletionsTableTable.$converteroccurrence);
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [taskId, occurrence, completedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'completions';
  @override
  VerificationContext validateIntegrity(
    Insertable<CompletionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {taskId, occurrence};
  @override
  CompletionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CompletionRow(
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      occurrence: $CompletionsTableTable.$converteroccurrence.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}occurrence'],
        )!,
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      )!,
    );
  }

  @override
  $CompletionsTableTable createAlias(String alias) {
    return $CompletionsTableTable(attachedDatabase, alias);
  }

  static TypeConverter<LocalDate, String> $converteroccurrence =
      const LocalDateConverter();
}

class CompletionRow extends DataClass implements Insertable<CompletionRow> {
  final String taskId;
  final LocalDate occurrence;
  final DateTime completedAt;
  const CompletionRow({
    required this.taskId,
    required this.occurrence,
    required this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['task_id'] = Variable<String>(taskId);
    {
      map['occurrence'] = Variable<String>(
        $CompletionsTableTable.$converteroccurrence.toSql(occurrence),
      );
    }
    map['completed_at'] = Variable<DateTime>(completedAt);
    return map;
  }

  CompletionsTableCompanion toCompanion(bool nullToAbsent) {
    return CompletionsTableCompanion(
      taskId: Value(taskId),
      occurrence: Value(occurrence),
      completedAt: Value(completedAt),
    );
  }

  factory CompletionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CompletionRow(
      taskId: serializer.fromJson<String>(json['taskId']),
      occurrence: serializer.fromJson<LocalDate>(json['occurrence']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'taskId': serializer.toJson<String>(taskId),
      'occurrence': serializer.toJson<LocalDate>(occurrence),
      'completedAt': serializer.toJson<DateTime>(completedAt),
    };
  }

  CompletionRow copyWith({
    String? taskId,
    LocalDate? occurrence,
    DateTime? completedAt,
  }) => CompletionRow(
    taskId: taskId ?? this.taskId,
    occurrence: occurrence ?? this.occurrence,
    completedAt: completedAt ?? this.completedAt,
  );
  CompletionRow copyWithCompanion(CompletionsTableCompanion data) {
    return CompletionRow(
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      occurrence: data.occurrence.present
          ? data.occurrence.value
          : this.occurrence,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CompletionRow(')
          ..write('taskId: $taskId, ')
          ..write('occurrence: $occurrence, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(taskId, occurrence, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CompletionRow &&
          other.taskId == this.taskId &&
          other.occurrence == this.occurrence &&
          other.completedAt == this.completedAt);
}

class CompletionsTableCompanion extends UpdateCompanion<CompletionRow> {
  final Value<String> taskId;
  final Value<LocalDate> occurrence;
  final Value<DateTime> completedAt;
  final Value<int> rowid;
  const CompletionsTableCompanion({
    this.taskId = const Value.absent(),
    this.occurrence = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CompletionsTableCompanion.insert({
    required String taskId,
    required LocalDate occurrence,
    required DateTime completedAt,
    this.rowid = const Value.absent(),
  }) : taskId = Value(taskId),
       occurrence = Value(occurrence),
       completedAt = Value(completedAt);
  static Insertable<CompletionRow> custom({
    Expression<String>? taskId,
    Expression<String>? occurrence,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (taskId != null) 'task_id': taskId,
      if (occurrence != null) 'occurrence': occurrence,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CompletionsTableCompanion copyWith({
    Value<String>? taskId,
    Value<LocalDate>? occurrence,
    Value<DateTime>? completedAt,
    Value<int>? rowid,
  }) {
    return CompletionsTableCompanion(
      taskId: taskId ?? this.taskId,
      occurrence: occurrence ?? this.occurrence,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (occurrence.present) {
      map['occurrence'] = Variable<String>(
        $CompletionsTableTable.$converteroccurrence.toSql(occurrence.value),
      );
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompletionsTableCompanion(')
          ..write('taskId: $taskId, ')
          ..write('occurrence: $occurrence, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTableTable extends SettingsTable
    with TableInfo<$SettingsTableTable, SettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<SoundRef, String> sound =
      GeneratedColumn<String>(
        'sound',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SoundRef>($SettingsTableTable.$convertersound);
  static const VerificationMeta _minVolumeMeta = const VerificationMeta(
    'minVolume',
  );
  @override
  late final GeneratedColumn<int> minVolume = GeneratedColumn<int>(
    'min_volume',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rampSecondsMeta = const VerificationMeta(
    'rampSeconds',
  );
  @override
  late final GeneratedColumn<int> rampSeconds = GeneratedColumn<int>(
    'ramp_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<VibrationPattern, String>
  vibration = GeneratedColumn<String>(
    'vibration',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<VibrationPattern>($SettingsTableTable.$convertervibration);
  static const VerificationMeta _snoozeMinutesMeta = const VerificationMeta(
    'snoozeMinutes',
  );
  @override
  late final GeneratedColumn<int> snoozeMinutes = GeneratedColumn<int>(
    'snooze_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _autoSilenceMinutesMeta =
      const VerificationMeta('autoSilenceMinutes');
  @override
  late final GeneratedColumn<int> autoSilenceMinutes = GeneratedColumn<int>(
    'auto_silence_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _allDayMinutesMeta = const VerificationMeta(
    'allDayMinutes',
  );
  @override
  late final GeneratedColumn<int> allDayMinutes = GeneratedColumn<int>(
    'all_day_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstWeekdayMeta = const VerificationMeta(
    'firstWeekday',
  );
  @override
  late final GeneratedColumn<int> firstWeekday = GeneratedColumn<int>(
    'first_weekday',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _onboardedMeta = const VerificationMeta(
    'onboarded',
  );
  @override
  late final GeneratedColumn<bool> onboarded = GeneratedColumn<bool>(
    'onboarded',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarded" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sound,
    minVolume,
    rampSeconds,
    vibration,
    snoozeMinutes,
    autoSilenceMinutes,
    allDayMinutes,
    firstWeekday,
    onboarded,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('min_volume')) {
      context.handle(
        _minVolumeMeta,
        minVolume.isAcceptableOrUnknown(data['min_volume']!, _minVolumeMeta),
      );
    }
    if (data.containsKey('ramp_seconds')) {
      context.handle(
        _rampSecondsMeta,
        rampSeconds.isAcceptableOrUnknown(
          data['ramp_seconds']!,
          _rampSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rampSecondsMeta);
    }
    if (data.containsKey('snooze_minutes')) {
      context.handle(
        _snoozeMinutesMeta,
        snoozeMinutes.isAcceptableOrUnknown(
          data['snooze_minutes']!,
          _snoozeMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_snoozeMinutesMeta);
    }
    if (data.containsKey('auto_silence_minutes')) {
      context.handle(
        _autoSilenceMinutesMeta,
        autoSilenceMinutes.isAcceptableOrUnknown(
          data['auto_silence_minutes']!,
          _autoSilenceMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_autoSilenceMinutesMeta);
    }
    if (data.containsKey('all_day_minutes')) {
      context.handle(
        _allDayMinutesMeta,
        allDayMinutes.isAcceptableOrUnknown(
          data['all_day_minutes']!,
          _allDayMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_allDayMinutesMeta);
    }
    if (data.containsKey('first_weekday')) {
      context.handle(
        _firstWeekdayMeta,
        firstWeekday.isAcceptableOrUnknown(
          data['first_weekday']!,
          _firstWeekdayMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_firstWeekdayMeta);
    }
    if (data.containsKey('onboarded')) {
      context.handle(
        _onboardedMeta,
        onboarded.isAcceptableOrUnknown(data['onboarded']!, _onboardedMeta),
      );
    } else if (isInserting) {
      context.missing(_onboardedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sound: $SettingsTableTable.$convertersound.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sound'],
        )!,
      ),
      minVolume: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_volume'],
      ),
      rampSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ramp_seconds'],
      )!,
      vibration: $SettingsTableTable.$convertervibration.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}vibration'],
        )!,
      ),
      snoozeMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}snooze_minutes'],
      )!,
      autoSilenceMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}auto_silence_minutes'],
      )!,
      allDayMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}all_day_minutes'],
      )!,
      firstWeekday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}first_weekday'],
      )!,
      onboarded: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarded'],
      )!,
    );
  }

  @override
  $SettingsTableTable createAlias(String alias) {
    return $SettingsTableTable(attachedDatabase, alias);
  }

  static TypeConverter<SoundRef, String> $convertersound =
      const SoundRefConverter();
  static JsonTypeConverter2<VibrationPattern, String, String>
  $convertervibration = const EnumNameConverter<VibrationPattern>(
    VibrationPattern.values,
  );
}

class SettingsRow extends DataClass implements Insertable<SettingsRow> {
  final int id;
  final SoundRef sound;
  final int? minVolume;
  final int rampSeconds;
  final VibrationPattern vibration;
  final int snoozeMinutes;
  final int autoSilenceMinutes;
  final int allDayMinutes;
  final int firstWeekday;
  final bool onboarded;
  const SettingsRow({
    required this.id,
    required this.sound,
    this.minVolume,
    required this.rampSeconds,
    required this.vibration,
    required this.snoozeMinutes,
    required this.autoSilenceMinutes,
    required this.allDayMinutes,
    required this.firstWeekday,
    required this.onboarded,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['sound'] = Variable<String>(
        $SettingsTableTable.$convertersound.toSql(sound),
      );
    }
    if (!nullToAbsent || minVolume != null) {
      map['min_volume'] = Variable<int>(minVolume);
    }
    map['ramp_seconds'] = Variable<int>(rampSeconds);
    {
      map['vibration'] = Variable<String>(
        $SettingsTableTable.$convertervibration.toSql(vibration),
      );
    }
    map['snooze_minutes'] = Variable<int>(snoozeMinutes);
    map['auto_silence_minutes'] = Variable<int>(autoSilenceMinutes);
    map['all_day_minutes'] = Variable<int>(allDayMinutes);
    map['first_weekday'] = Variable<int>(firstWeekday);
    map['onboarded'] = Variable<bool>(onboarded);
    return map;
  }

  SettingsTableCompanion toCompanion(bool nullToAbsent) {
    return SettingsTableCompanion(
      id: Value(id),
      sound: Value(sound),
      minVolume: minVolume == null && nullToAbsent
          ? const Value.absent()
          : Value(minVolume),
      rampSeconds: Value(rampSeconds),
      vibration: Value(vibration),
      snoozeMinutes: Value(snoozeMinutes),
      autoSilenceMinutes: Value(autoSilenceMinutes),
      allDayMinutes: Value(allDayMinutes),
      firstWeekday: Value(firstWeekday),
      onboarded: Value(onboarded),
    );
  }

  factory SettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsRow(
      id: serializer.fromJson<int>(json['id']),
      sound: serializer.fromJson<SoundRef>(json['sound']),
      minVolume: serializer.fromJson<int?>(json['minVolume']),
      rampSeconds: serializer.fromJson<int>(json['rampSeconds']),
      vibration: $SettingsTableTable.$convertervibration.fromJson(
        serializer.fromJson<String>(json['vibration']),
      ),
      snoozeMinutes: serializer.fromJson<int>(json['snoozeMinutes']),
      autoSilenceMinutes: serializer.fromJson<int>(json['autoSilenceMinutes']),
      allDayMinutes: serializer.fromJson<int>(json['allDayMinutes']),
      firstWeekday: serializer.fromJson<int>(json['firstWeekday']),
      onboarded: serializer.fromJson<bool>(json['onboarded']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sound': serializer.toJson<SoundRef>(sound),
      'minVolume': serializer.toJson<int?>(minVolume),
      'rampSeconds': serializer.toJson<int>(rampSeconds),
      'vibration': serializer.toJson<String>(
        $SettingsTableTable.$convertervibration.toJson(vibration),
      ),
      'snoozeMinutes': serializer.toJson<int>(snoozeMinutes),
      'autoSilenceMinutes': serializer.toJson<int>(autoSilenceMinutes),
      'allDayMinutes': serializer.toJson<int>(allDayMinutes),
      'firstWeekday': serializer.toJson<int>(firstWeekday),
      'onboarded': serializer.toJson<bool>(onboarded),
    };
  }

  SettingsRow copyWith({
    int? id,
    SoundRef? sound,
    Value<int?> minVolume = const Value.absent(),
    int? rampSeconds,
    VibrationPattern? vibration,
    int? snoozeMinutes,
    int? autoSilenceMinutes,
    int? allDayMinutes,
    int? firstWeekday,
    bool? onboarded,
  }) => SettingsRow(
    id: id ?? this.id,
    sound: sound ?? this.sound,
    minVolume: minVolume.present ? minVolume.value : this.minVolume,
    rampSeconds: rampSeconds ?? this.rampSeconds,
    vibration: vibration ?? this.vibration,
    snoozeMinutes: snoozeMinutes ?? this.snoozeMinutes,
    autoSilenceMinutes: autoSilenceMinutes ?? this.autoSilenceMinutes,
    allDayMinutes: allDayMinutes ?? this.allDayMinutes,
    firstWeekday: firstWeekday ?? this.firstWeekday,
    onboarded: onboarded ?? this.onboarded,
  );
  SettingsRow copyWithCompanion(SettingsTableCompanion data) {
    return SettingsRow(
      id: data.id.present ? data.id.value : this.id,
      sound: data.sound.present ? data.sound.value : this.sound,
      minVolume: data.minVolume.present ? data.minVolume.value : this.minVolume,
      rampSeconds: data.rampSeconds.present
          ? data.rampSeconds.value
          : this.rampSeconds,
      vibration: data.vibration.present ? data.vibration.value : this.vibration,
      snoozeMinutes: data.snoozeMinutes.present
          ? data.snoozeMinutes.value
          : this.snoozeMinutes,
      autoSilenceMinutes: data.autoSilenceMinutes.present
          ? data.autoSilenceMinutes.value
          : this.autoSilenceMinutes,
      allDayMinutes: data.allDayMinutes.present
          ? data.allDayMinutes.value
          : this.allDayMinutes,
      firstWeekday: data.firstWeekday.present
          ? data.firstWeekday.value
          : this.firstWeekday,
      onboarded: data.onboarded.present ? data.onboarded.value : this.onboarded,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingsRow(')
          ..write('id: $id, ')
          ..write('sound: $sound, ')
          ..write('minVolume: $minVolume, ')
          ..write('rampSeconds: $rampSeconds, ')
          ..write('vibration: $vibration, ')
          ..write('snoozeMinutes: $snoozeMinutes, ')
          ..write('autoSilenceMinutes: $autoSilenceMinutes, ')
          ..write('allDayMinutes: $allDayMinutes, ')
          ..write('firstWeekday: $firstWeekday, ')
          ..write('onboarded: $onboarded')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sound,
    minVolume,
    rampSeconds,
    vibration,
    snoozeMinutes,
    autoSilenceMinutes,
    allDayMinutes,
    firstWeekday,
    onboarded,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsRow &&
          other.id == this.id &&
          other.sound == this.sound &&
          other.minVolume == this.minVolume &&
          other.rampSeconds == this.rampSeconds &&
          other.vibration == this.vibration &&
          other.snoozeMinutes == this.snoozeMinutes &&
          other.autoSilenceMinutes == this.autoSilenceMinutes &&
          other.allDayMinutes == this.allDayMinutes &&
          other.firstWeekday == this.firstWeekday &&
          other.onboarded == this.onboarded);
}

class SettingsTableCompanion extends UpdateCompanion<SettingsRow> {
  final Value<int> id;
  final Value<SoundRef> sound;
  final Value<int?> minVolume;
  final Value<int> rampSeconds;
  final Value<VibrationPattern> vibration;
  final Value<int> snoozeMinutes;
  final Value<int> autoSilenceMinutes;
  final Value<int> allDayMinutes;
  final Value<int> firstWeekday;
  final Value<bool> onboarded;
  const SettingsTableCompanion({
    this.id = const Value.absent(),
    this.sound = const Value.absent(),
    this.minVolume = const Value.absent(),
    this.rampSeconds = const Value.absent(),
    this.vibration = const Value.absent(),
    this.snoozeMinutes = const Value.absent(),
    this.autoSilenceMinutes = const Value.absent(),
    this.allDayMinutes = const Value.absent(),
    this.firstWeekday = const Value.absent(),
    this.onboarded = const Value.absent(),
  });
  SettingsTableCompanion.insert({
    this.id = const Value.absent(),
    required SoundRef sound,
    this.minVolume = const Value.absent(),
    required int rampSeconds,
    required VibrationPattern vibration,
    required int snoozeMinutes,
    required int autoSilenceMinutes,
    required int allDayMinutes,
    required int firstWeekday,
    required bool onboarded,
  }) : sound = Value(sound),
       rampSeconds = Value(rampSeconds),
       vibration = Value(vibration),
       snoozeMinutes = Value(snoozeMinutes),
       autoSilenceMinutes = Value(autoSilenceMinutes),
       allDayMinutes = Value(allDayMinutes),
       firstWeekday = Value(firstWeekday),
       onboarded = Value(onboarded);
  static Insertable<SettingsRow> custom({
    Expression<int>? id,
    Expression<String>? sound,
    Expression<int>? minVolume,
    Expression<int>? rampSeconds,
    Expression<String>? vibration,
    Expression<int>? snoozeMinutes,
    Expression<int>? autoSilenceMinutes,
    Expression<int>? allDayMinutes,
    Expression<int>? firstWeekday,
    Expression<bool>? onboarded,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sound != null) 'sound': sound,
      if (minVolume != null) 'min_volume': minVolume,
      if (rampSeconds != null) 'ramp_seconds': rampSeconds,
      if (vibration != null) 'vibration': vibration,
      if (snoozeMinutes != null) 'snooze_minutes': snoozeMinutes,
      if (autoSilenceMinutes != null)
        'auto_silence_minutes': autoSilenceMinutes,
      if (allDayMinutes != null) 'all_day_minutes': allDayMinutes,
      if (firstWeekday != null) 'first_weekday': firstWeekday,
      if (onboarded != null) 'onboarded': onboarded,
    });
  }

  SettingsTableCompanion copyWith({
    Value<int>? id,
    Value<SoundRef>? sound,
    Value<int?>? minVolume,
    Value<int>? rampSeconds,
    Value<VibrationPattern>? vibration,
    Value<int>? snoozeMinutes,
    Value<int>? autoSilenceMinutes,
    Value<int>? allDayMinutes,
    Value<int>? firstWeekday,
    Value<bool>? onboarded,
  }) {
    return SettingsTableCompanion(
      id: id ?? this.id,
      sound: sound ?? this.sound,
      minVolume: minVolume ?? this.minVolume,
      rampSeconds: rampSeconds ?? this.rampSeconds,
      vibration: vibration ?? this.vibration,
      snoozeMinutes: snoozeMinutes ?? this.snoozeMinutes,
      autoSilenceMinutes: autoSilenceMinutes ?? this.autoSilenceMinutes,
      allDayMinutes: allDayMinutes ?? this.allDayMinutes,
      firstWeekday: firstWeekday ?? this.firstWeekday,
      onboarded: onboarded ?? this.onboarded,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sound.present) {
      map['sound'] = Variable<String>(
        $SettingsTableTable.$convertersound.toSql(sound.value),
      );
    }
    if (minVolume.present) {
      map['min_volume'] = Variable<int>(minVolume.value);
    }
    if (rampSeconds.present) {
      map['ramp_seconds'] = Variable<int>(rampSeconds.value);
    }
    if (vibration.present) {
      map['vibration'] = Variable<String>(
        $SettingsTableTable.$convertervibration.toSql(vibration.value),
      );
    }
    if (snoozeMinutes.present) {
      map['snooze_minutes'] = Variable<int>(snoozeMinutes.value);
    }
    if (autoSilenceMinutes.present) {
      map['auto_silence_minutes'] = Variable<int>(autoSilenceMinutes.value);
    }
    if (allDayMinutes.present) {
      map['all_day_minutes'] = Variable<int>(allDayMinutes.value);
    }
    if (firstWeekday.present) {
      map['first_weekday'] = Variable<int>(firstWeekday.value);
    }
    if (onboarded.present) {
      map['onboarded'] = Variable<bool>(onboarded.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('sound: $sound, ')
          ..write('minVolume: $minVolume, ')
          ..write('rampSeconds: $rampSeconds, ')
          ..write('vibration: $vibration, ')
          ..write('snoozeMinutes: $snoozeMinutes, ')
          ..write('autoSilenceMinutes: $autoSilenceMinutes, ')
          ..write('allDayMinutes: $allDayMinutes, ')
          ..write('firstWeekday: $firstWeekday, ')
          ..write('onboarded: $onboarded')
          ..write(')'))
        .toString();
  }
}

abstract class _$KlarDb extends GeneratedDatabase {
  _$KlarDb(QueryExecutor e) : super(e);
  $KlarDbManager get managers => $KlarDbManager(this);
  late final $TaskListsTableTable taskListsTable = $TaskListsTableTable(this);
  late final $TasksTableTable tasksTable = $TasksTableTable(this);
  late final $SubtasksTableTable subtasksTable = $SubtasksTableTable(this);
  late final $RemindersTableTable remindersTable = $RemindersTableTable(this);
  late final $CompletionsTableTable completionsTable = $CompletionsTableTable(
    this,
  );
  late final $SettingsTableTable settingsTable = $SettingsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    taskListsTable,
    tasksTable,
    subtasksTable,
    remindersTable,
    completionsTable,
    settingsTable,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'task_lists',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('tasks', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tasks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('subtasks', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tasks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reminders', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tasks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('completions', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$TaskListsTableTableCreateCompanionBuilder =
    TaskListsTableCompanion Function({
      required String id,
      required String name,
      required String colorKey,
      required String iconKey,
      Value<int> sortOrder,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$TaskListsTableTableUpdateCompanionBuilder =
    TaskListsTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> colorKey,
      Value<String> iconKey,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$TaskListsTableTableReferences
    extends BaseReferences<_$KlarDb, $TaskListsTableTable, TaskListRow> {
  $$TaskListsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$TasksTableTable, List<TaskRow>>
  _tasksTableRefsTable(_$KlarDb db) => MultiTypedResultKey.fromTable(
    db.tasksTable,
    aliasName: 'task_lists__id__tasks__list_id',
  );

  $$TasksTableTableProcessedTableManager get tasksTableRefs {
    final manager = $$TasksTableTableTableManager(
      $_db,
      $_db.tasksTable,
    ).filter((f) => f.listId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tasksTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TaskListsTableTableFilterComposer
    extends Composer<_$KlarDb, $TaskListsTableTable> {
  $$TaskListsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorKey => $composableBuilder(
    column: $table.colorKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> tasksTableRefs(
    Expression<bool> Function($$TasksTableTableFilterComposer f) f,
  ) {
    final $$TasksTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasksTable,
      getReferencedColumn: (t) => t.listId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableTableFilterComposer(
            $db: $db,
            $table: $db.tasksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TaskListsTableTableOrderingComposer
    extends Composer<_$KlarDb, $TaskListsTableTable> {
  $$TaskListsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorKey => $composableBuilder(
    column: $table.colorKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TaskListsTableTableAnnotationComposer
    extends Composer<_$KlarDb, $TaskListsTableTable> {
  $$TaskListsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get colorKey =>
      $composableBuilder(column: $table.colorKey, builder: (column) => column);

  GeneratedColumn<String> get iconKey =>
      $composableBuilder(column: $table.iconKey, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> tasksTableRefs<T extends Object>(
    Expression<T> Function($$TasksTableTableAnnotationComposer a) f,
  ) {
    final $$TasksTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasksTable,
      getReferencedColumn: (t) => t.listId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableTableAnnotationComposer(
            $db: $db,
            $table: $db.tasksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TaskListsTableTableTableManager
    extends
        RootTableManager<
          _$KlarDb,
          $TaskListsTableTable,
          TaskListRow,
          $$TaskListsTableTableFilterComposer,
          $$TaskListsTableTableOrderingComposer,
          $$TaskListsTableTableAnnotationComposer,
          $$TaskListsTableTableCreateCompanionBuilder,
          $$TaskListsTableTableUpdateCompanionBuilder,
          (TaskListRow, $$TaskListsTableTableReferences),
          TaskListRow,
          PrefetchHooks Function({bool tasksTableRefs})
        > {
  $$TaskListsTableTableTableManager(_$KlarDb db, $TaskListsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskListsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskListsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskListsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> colorKey = const Value.absent(),
                Value<String> iconKey = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskListsTableCompanion(
                id: id,
                name: name,
                colorKey: colorKey,
                iconKey: iconKey,
                sortOrder: sortOrder,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String colorKey,
                required String iconKey,
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => TaskListsTableCompanion.insert(
                id: id,
                name: name,
                colorKey: colorKey,
                iconKey: iconKey,
                sortOrder: sortOrder,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TaskListsTableTable, TaskListRow>(table),
                  $$TaskListsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tasksTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (tasksTableRefs) db.tasksTable],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (tasksTableRefs)
                    await $_getPrefetchedData<
                      TaskListRow,
                      $TaskListsTableTable,
                      TaskRow
                    >(
                      currentTable: table,
                      referencedTable: $$TaskListsTableTableReferences
                          ._tasksTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TaskListsTableTableReferences(
                            db,
                            table,
                            p0,
                          ).tasksTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.listId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TaskListsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$KlarDb,
      $TaskListsTableTable,
      TaskListRow,
      $$TaskListsTableTableFilterComposer,
      $$TaskListsTableTableOrderingComposer,
      $$TaskListsTableTableAnnotationComposer,
      $$TaskListsTableTableCreateCompanionBuilder,
      $$TaskListsTableTableUpdateCompanionBuilder,
      (TaskListRow, $$TaskListsTableTableReferences),
      TaskListRow,
      PrefetchHooks Function({bool tasksTableRefs})
    >;
typedef $$TasksTableTableCreateCompanionBuilder = TasksTableCompanion Function({
  required String id,
  required String listId,
  required String title,
  Value<String> notes,
  Value<Priority> priority,
  Value<LocalDate?> dueDate,
  Value<int?> dueTime,
  Value<RecurrenceRule?> recurrence,
  Value<DateTime?> completedAt,
  required DateTime createdAt,
  Value<int> sortOrder,
  Value<SoundRef?> sound,
  Value<VibrationPattern?> vibration,
  Value<int> rowid,
});
typedef $$TasksTableTableUpdateCompanionBuilder = TasksTableCompanion Function({
  Value<String> id,
  Value<String> listId,
  Value<String> title,
  Value<String> notes,
  Value<Priority> priority,
  Value<LocalDate?> dueDate,
  Value<int?> dueTime,
  Value<RecurrenceRule?> recurrence,
  Value<DateTime?> completedAt,
  Value<DateTime> createdAt,
  Value<int> sortOrder,
  Value<SoundRef?> sound,
  Value<VibrationPattern?> vibration,
  Value<int> rowid,
});

final class $$TasksTableTableReferences
    extends BaseReferences<_$KlarDb, $TasksTableTable, TaskRow> {
  $$TasksTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TaskListsTableTable _listIdTable(_$KlarDb db) =>
      db.taskListsTable.createAlias('tasks__list_id__task_lists__id');

  $$TaskListsTableTableProcessedTableManager get listId {
    final $_column = $_itemColumn<String>('list_id')!;

    final manager = $$TaskListsTableTableTableManager(
      $_db,
      $_db.taskListsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_listIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SubtasksTableTable, List<SubtaskRow>>
  _subtasksTableRefsTable(_$KlarDb db) => MultiTypedResultKey.fromTable(
    db.subtasksTable,
    aliasName: 'tasks__id__subtasks__task_id',
  );

  $$SubtasksTableTableProcessedTableManager get subtasksTableRefs {
    final manager = $$SubtasksTableTableTableManager(
      $_db,
      $_db.subtasksTable,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_subtasksTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RemindersTableTable, List<ReminderRow>>
  _remindersTableRefsTable(_$KlarDb db) => MultiTypedResultKey.fromTable(
    db.remindersTable,
    aliasName: 'tasks__id__reminders__task_id',
  );

  $$RemindersTableTableProcessedTableManager get remindersTableRefs {
    final manager = $$RemindersTableTableTableManager(
      $_db,
      $_db.remindersTable,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_remindersTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CompletionsTableTable, List<CompletionRow>>
  _completionsTableRefsTable(_$KlarDb db) => MultiTypedResultKey.fromTable(
    db.completionsTable,
    aliasName: 'tasks__id__completions__task_id',
  );

  $$CompletionsTableTableProcessedTableManager get completionsTableRefs {
    final manager = $$CompletionsTableTableTableManager(
      $_db,
      $_db.completionsTable,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _completionsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TasksTableTableFilterComposer
    extends Composer<_$KlarDb, $TasksTableTable> {
  $$TasksTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Priority, Priority, int> get priority =>
      $composableBuilder(
        column: $table.priority,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<LocalDate?, LocalDate, String> get dueDate =>
      $composableBuilder(
        column: $table.dueDate,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get dueTime => $composableBuilder(
    column: $table.dueTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RecurrenceRule?, RecurrenceRule, String>
  get recurrence => $composableBuilder(
    column: $table.recurrence,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SoundRef?, SoundRef, String> get sound =>
      $composableBuilder(
        column: $table.sound,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<VibrationPattern?, VibrationPattern, String>
  get vibration => $composableBuilder(
    column: $table.vibration,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$TaskListsTableTableFilterComposer get listId {
    final $$TaskListsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listId,
      referencedTable: $db.taskListsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskListsTableTableFilterComposer(
            $db: $db,
            $table: $db.taskListsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> subtasksTableRefs(
    Expression<bool> Function($$SubtasksTableTableFilterComposer f) f,
  ) {
    final $$SubtasksTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subtasksTable,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubtasksTableTableFilterComposer(
            $db: $db,
            $table: $db.subtasksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> remindersTableRefs(
    Expression<bool> Function($$RemindersTableTableFilterComposer f) f,
  ) {
    final $$RemindersTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.remindersTable,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableTableFilterComposer(
            $db: $db,
            $table: $db.remindersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> completionsTableRefs(
    Expression<bool> Function($$CompletionsTableTableFilterComposer f) f,
  ) {
    final $$CompletionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.completionsTable,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompletionsTableTableFilterComposer(
            $db: $db,
            $table: $db.completionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TasksTableTableOrderingComposer
    extends Composer<_$KlarDb, $TasksTableTable> {
  $$TasksTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueTime => $composableBuilder(
    column: $table.dueTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recurrence => $composableBuilder(
    column: $table.recurrence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sound => $composableBuilder(
    column: $table.sound,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vibration => $composableBuilder(
    column: $table.vibration,
    builder: (column) => ColumnOrderings(column),
  );

  $$TaskListsTableTableOrderingComposer get listId {
    final $$TaskListsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listId,
      referencedTable: $db.taskListsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskListsTableTableOrderingComposer(
            $db: $db,
            $table: $db.taskListsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TasksTableTableAnnotationComposer
    extends Composer<_$KlarDb, $TasksTableTable> {
  $$TasksTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Priority, int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LocalDate?, String> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<int> get dueTime =>
      $composableBuilder(column: $table.dueTime, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RecurrenceRule?, String> get recurrence =>
      $composableBuilder(
        column: $table.recurrence,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SoundRef?, String> get sound =>
      $composableBuilder(column: $table.sound, builder: (column) => column);

  GeneratedColumnWithTypeConverter<VibrationPattern?, String> get vibration =>
      $composableBuilder(column: $table.vibration, builder: (column) => column);

  $$TaskListsTableTableAnnotationComposer get listId {
    final $$TaskListsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listId,
      referencedTable: $db.taskListsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskListsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.taskListsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> subtasksTableRefs<T extends Object>(
    Expression<T> Function($$SubtasksTableTableAnnotationComposer a) f,
  ) {
    final $$SubtasksTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subtasksTable,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubtasksTableTableAnnotationComposer(
            $db: $db,
            $table: $db.subtasksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> remindersTableRefs<T extends Object>(
    Expression<T> Function($$RemindersTableTableAnnotationComposer a) f,
  ) {
    final $$RemindersTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.remindersTable,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableTableAnnotationComposer(
            $db: $db,
            $table: $db.remindersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> completionsTableRefs<T extends Object>(
    Expression<T> Function($$CompletionsTableTableAnnotationComposer a) f,
  ) {
    final $$CompletionsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.completionsTable,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompletionsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.completionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TasksTableTableTableManager
    extends
        RootTableManager<
          _$KlarDb,
          $TasksTableTable,
          TaskRow,
          $$TasksTableTableFilterComposer,
          $$TasksTableTableOrderingComposer,
          $$TasksTableTableAnnotationComposer,
          $$TasksTableTableCreateCompanionBuilder,
          $$TasksTableTableUpdateCompanionBuilder,
          (TaskRow, $$TasksTableTableReferences),
          TaskRow,
          PrefetchHooks Function({
            bool listId,
            bool subtasksTableRefs,
            bool remindersTableRefs,
            bool completionsTableRefs,
          })
        > {
  $$TasksTableTableTableManager(_$KlarDb db, $TasksTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> listId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<Priority> priority = const Value.absent(),
                Value<LocalDate?> dueDate = const Value.absent(),
                Value<int?> dueTime = const Value.absent(),
                Value<RecurrenceRule?> recurrence = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<SoundRef?> sound = const Value.absent(),
                Value<VibrationPattern?> vibration = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksTableCompanion(
                id: id,
                listId: listId,
                title: title,
                notes: notes,
                priority: priority,
                dueDate: dueDate,
                dueTime: dueTime,
                recurrence: recurrence,
                completedAt: completedAt,
                createdAt: createdAt,
                sortOrder: sortOrder,
                sound: sound,
                vibration: vibration,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String listId,
                required String title,
                Value<String> notes = const Value.absent(),
                Value<Priority> priority = const Value.absent(),
                Value<LocalDate?> dueDate = const Value.absent(),
                Value<int?> dueTime = const Value.absent(),
                Value<RecurrenceRule?> recurrence = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                required DateTime createdAt,
                Value<int> sortOrder = const Value.absent(),
                Value<SoundRef?> sound = const Value.absent(),
                Value<VibrationPattern?> vibration = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksTableCompanion.insert(
                id: id,
                listId: listId,
                title: title,
                notes: notes,
                priority: priority,
                dueDate: dueDate,
                dueTime: dueTime,
                recurrence: recurrence,
                completedAt: completedAt,
                createdAt: createdAt,
                sortOrder: sortOrder,
                sound: sound,
                vibration: vibration,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TasksTableTable, TaskRow>(table),
                  $$TasksTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                listId = false,
                subtasksTableRefs = false,
                remindersTableRefs = false,
                completionsTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (subtasksTableRefs) db.subtasksTable,
                    if (remindersTableRefs) db.remindersTable,
                    if (completionsTableRefs) db.completionsTable,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (listId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.listId,
                            referencedTable: $$TasksTableTableReferences
                                ._listIdTable(db),
                            referencedColumn: $$TasksTableTableReferences
                                ._listIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (subtasksTableRefs)
                        await $_getPrefetchedData<
                          TaskRow,
                          $TasksTableTable,
                          SubtaskRow
                        >(
                          currentTable: table,
                          referencedTable: $$TasksTableTableReferences
                              ._subtasksTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TasksTableTableReferences(
                                db,
                                table,
                                p0,
                              ).subtasksTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (remindersTableRefs)
                        await $_getPrefetchedData<
                          TaskRow,
                          $TasksTableTable,
                          ReminderRow
                        >(
                          currentTable: table,
                          referencedTable: $$TasksTableTableReferences
                              ._remindersTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TasksTableTableReferences(
                                db,
                                table,
                                p0,
                              ).remindersTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (completionsTableRefs)
                        await $_getPrefetchedData<
                          TaskRow,
                          $TasksTableTable,
                          CompletionRow
                        >(
                          currentTable: table,
                          referencedTable: $$TasksTableTableReferences
                              ._completionsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TasksTableTableReferences(
                                db,
                                table,
                                p0,
                              ).completionsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TasksTableTableProcessedTableManager =
    ProcessedTableManager<
      _$KlarDb,
      $TasksTableTable,
      TaskRow,
      $$TasksTableTableFilterComposer,
      $$TasksTableTableOrderingComposer,
      $$TasksTableTableAnnotationComposer,
      $$TasksTableTableCreateCompanionBuilder,
      $$TasksTableTableUpdateCompanionBuilder,
      (TaskRow, $$TasksTableTableReferences),
      TaskRow,
      PrefetchHooks Function({
        bool listId,
        bool subtasksTableRefs,
        bool remindersTableRefs,
        bool completionsTableRefs,
      })
    >;
typedef $$SubtasksTableTableCreateCompanionBuilder =
    SubtasksTableCompanion Function({
      required String id,
      required String taskId,
      required String title,
      Value<bool> done,
      required int sortOrder,
      Value<int> rowid,
    });
typedef $$SubtasksTableTableUpdateCompanionBuilder =
    SubtasksTableCompanion Function({
      Value<String> id,
      Value<String> taskId,
      Value<String> title,
      Value<bool> done,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$SubtasksTableTableReferences
    extends BaseReferences<_$KlarDb, $SubtasksTableTable, SubtaskRow> {
  $$SubtasksTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TasksTableTable _taskIdTable(_$KlarDb db) =>
      db.tasksTable.createAlias('subtasks__task_id__tasks__id');

  $$TasksTableTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<String>('task_id')!;

    final manager = $$TasksTableTableTableManager(
      $_db,
      $_db.tasksTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SubtasksTableTableFilterComposer
    extends Composer<_$KlarDb, $SubtasksTableTable> {
  $$SubtasksTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$TasksTableTableFilterComposer get taskId {
    final $$TasksTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasksTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableTableFilterComposer(
            $db: $db,
            $table: $db.tasksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubtasksTableTableOrderingComposer
    extends Composer<_$KlarDb, $SubtasksTableTable> {
  $$SubtasksTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$TasksTableTableOrderingComposer get taskId {
    final $$TasksTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasksTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableTableOrderingComposer(
            $db: $db,
            $table: $db.tasksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubtasksTableTableAnnotationComposer
    extends Composer<_$KlarDb, $SubtasksTableTable> {
  $$SubtasksTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<bool> get done =>
      $composableBuilder(column: $table.done, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$TasksTableTableAnnotationComposer get taskId {
    final $$TasksTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasksTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableTableAnnotationComposer(
            $db: $db,
            $table: $db.tasksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubtasksTableTableTableManager
    extends
        RootTableManager<
          _$KlarDb,
          $SubtasksTableTable,
          SubtaskRow,
          $$SubtasksTableTableFilterComposer,
          $$SubtasksTableTableOrderingComposer,
          $$SubtasksTableTableAnnotationComposer,
          $$SubtasksTableTableCreateCompanionBuilder,
          $$SubtasksTableTableUpdateCompanionBuilder,
          (SubtaskRow, $$SubtasksTableTableReferences),
          SubtaskRow,
          PrefetchHooks Function({bool taskId})
        > {
  $$SubtasksTableTableTableManager(_$KlarDb db, $SubtasksTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubtasksTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubtasksTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubtasksTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> taskId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<bool> done = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubtasksTableCompanion(
                id: id,
                taskId: taskId,
                title: title,
                done: done,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String taskId,
                required String title,
                Value<bool> done = const Value.absent(),
                required int sortOrder,
                Value<int> rowid = const Value.absent(),
              }) => SubtasksTableCompanion.insert(
                id: id,
                taskId: taskId,
                title: title,
                done: done,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SubtasksTableTable, SubtaskRow>(table),
                  $$SubtasksTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (taskId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.taskId,
                        referencedTable: $$SubtasksTableTableReferences
                            ._taskIdTable(db),
                        referencedColumn: $$SubtasksTableTableReferences
                            ._taskIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SubtasksTableTableProcessedTableManager =
    ProcessedTableManager<
      _$KlarDb,
      $SubtasksTableTable,
      SubtaskRow,
      $$SubtasksTableTableFilterComposer,
      $$SubtasksTableTableOrderingComposer,
      $$SubtasksTableTableAnnotationComposer,
      $$SubtasksTableTableCreateCompanionBuilder,
      $$SubtasksTableTableUpdateCompanionBuilder,
      (SubtaskRow, $$SubtasksTableTableReferences),
      SubtaskRow,
      PrefetchHooks Function({bool taskId})
    >;
typedef $$RemindersTableTableCreateCompanionBuilder =
    RemindersTableCompanion Function({
      required String id,
      required String taskId,
      required int offsetMinutes,
      required ReminderKind kind,
      required int sortOrder,
      Value<int> rowid,
    });
typedef $$RemindersTableTableUpdateCompanionBuilder =
    RemindersTableCompanion Function({
      Value<String> id,
      Value<String> taskId,
      Value<int> offsetMinutes,
      Value<ReminderKind> kind,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$RemindersTableTableReferences
    extends BaseReferences<_$KlarDb, $RemindersTableTable, ReminderRow> {
  $$RemindersTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TasksTableTable _taskIdTable(_$KlarDb db) =>
      db.tasksTable.createAlias('reminders__task_id__tasks__id');

  $$TasksTableTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<String>('task_id')!;

    final manager = $$TasksTableTableTableManager(
      $_db,
      $_db.tasksTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RemindersTableTableFilterComposer
    extends Composer<_$KlarDb, $RemindersTableTable> {
  $$RemindersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get offsetMinutes => $composableBuilder(
    column: $table.offsetMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ReminderKind, ReminderKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$TasksTableTableFilterComposer get taskId {
    final $$TasksTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasksTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableTableFilterComposer(
            $db: $db,
            $table: $db.tasksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemindersTableTableOrderingComposer
    extends Composer<_$KlarDb, $RemindersTableTable> {
  $$RemindersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get offsetMinutes => $composableBuilder(
    column: $table.offsetMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$TasksTableTableOrderingComposer get taskId {
    final $$TasksTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasksTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableTableOrderingComposer(
            $db: $db,
            $table: $db.tasksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemindersTableTableAnnotationComposer
    extends Composer<_$KlarDb, $RemindersTableTable> {
  $$RemindersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get offsetMinutes => $composableBuilder(
    column: $table.offsetMinutes,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ReminderKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$TasksTableTableAnnotationComposer get taskId {
    final $$TasksTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasksTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableTableAnnotationComposer(
            $db: $db,
            $table: $db.tasksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemindersTableTableTableManager
    extends
        RootTableManager<
          _$KlarDb,
          $RemindersTableTable,
          ReminderRow,
          $$RemindersTableTableFilterComposer,
          $$RemindersTableTableOrderingComposer,
          $$RemindersTableTableAnnotationComposer,
          $$RemindersTableTableCreateCompanionBuilder,
          $$RemindersTableTableUpdateCompanionBuilder,
          (ReminderRow, $$RemindersTableTableReferences),
          ReminderRow,
          PrefetchHooks Function({bool taskId})
        > {
  $$RemindersTableTableTableManager(_$KlarDb db, $RemindersTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> taskId = const Value.absent(),
                Value<int> offsetMinutes = const Value.absent(),
                Value<ReminderKind> kind = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RemindersTableCompanion(
                id: id,
                taskId: taskId,
                offsetMinutes: offsetMinutes,
                kind: kind,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String taskId,
                required int offsetMinutes,
                required ReminderKind kind,
                required int sortOrder,
                Value<int> rowid = const Value.absent(),
              }) => RemindersTableCompanion.insert(
                id: id,
                taskId: taskId,
                offsetMinutes: offsetMinutes,
                kind: kind,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RemindersTableTable, ReminderRow>(table),
                  $$RemindersTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (taskId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.taskId,
                        referencedTable: $$RemindersTableTableReferences
                            ._taskIdTable(db),
                        referencedColumn: $$RemindersTableTableReferences
                            ._taskIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RemindersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$KlarDb,
      $RemindersTableTable,
      ReminderRow,
      $$RemindersTableTableFilterComposer,
      $$RemindersTableTableOrderingComposer,
      $$RemindersTableTableAnnotationComposer,
      $$RemindersTableTableCreateCompanionBuilder,
      $$RemindersTableTableUpdateCompanionBuilder,
      (ReminderRow, $$RemindersTableTableReferences),
      ReminderRow,
      PrefetchHooks Function({bool taskId})
    >;
typedef $$CompletionsTableTableCreateCompanionBuilder =
    CompletionsTableCompanion Function({
      required String taskId,
      required LocalDate occurrence,
      required DateTime completedAt,
      Value<int> rowid,
    });
typedef $$CompletionsTableTableUpdateCompanionBuilder =
    CompletionsTableCompanion Function({
      Value<String> taskId,
      Value<LocalDate> occurrence,
      Value<DateTime> completedAt,
      Value<int> rowid,
    });

final class $$CompletionsTableTableReferences
    extends BaseReferences<_$KlarDb, $CompletionsTableTable, CompletionRow> {
  $$CompletionsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TasksTableTable _taskIdTable(_$KlarDb db) =>
      db.tasksTable.createAlias('completions__task_id__tasks__id');

  $$TasksTableTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<String>('task_id')!;

    final manager = $$TasksTableTableTableManager(
      $_db,
      $_db.tasksTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CompletionsTableTableFilterComposer
    extends Composer<_$KlarDb, $CompletionsTableTable> {
  $$CompletionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<LocalDate, LocalDate, String> get occurrence =>
      $composableBuilder(
        column: $table.occurrence,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TasksTableTableFilterComposer get taskId {
    final $$TasksTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasksTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableTableFilterComposer(
            $db: $db,
            $table: $db.tasksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CompletionsTableTableOrderingComposer
    extends Composer<_$KlarDb, $CompletionsTableTable> {
  $$CompletionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get occurrence => $composableBuilder(
    column: $table.occurrence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TasksTableTableOrderingComposer get taskId {
    final $$TasksTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasksTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableTableOrderingComposer(
            $db: $db,
            $table: $db.tasksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CompletionsTableTableAnnotationComposer
    extends Composer<_$KlarDb, $CompletionsTableTable> {
  $$CompletionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<LocalDate, String> get occurrence =>
      $composableBuilder(
        column: $table.occurrence,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  $$TasksTableTableAnnotationComposer get taskId {
    final $$TasksTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasksTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableTableAnnotationComposer(
            $db: $db,
            $table: $db.tasksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CompletionsTableTableTableManager
    extends
        RootTableManager<
          _$KlarDb,
          $CompletionsTableTable,
          CompletionRow,
          $$CompletionsTableTableFilterComposer,
          $$CompletionsTableTableOrderingComposer,
          $$CompletionsTableTableAnnotationComposer,
          $$CompletionsTableTableCreateCompanionBuilder,
          $$CompletionsTableTableUpdateCompanionBuilder,
          (CompletionRow, $$CompletionsTableTableReferences),
          CompletionRow,
          PrefetchHooks Function({bool taskId})
        > {
  $$CompletionsTableTableTableManager(_$KlarDb db, $CompletionsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompletionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CompletionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CompletionsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> taskId = const Value.absent(),
                Value<LocalDate> occurrence = const Value.absent(),
                Value<DateTime> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CompletionsTableCompanion(
                taskId: taskId,
                occurrence: occurrence,
                completedAt: completedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String taskId,
                required LocalDate occurrence,
                required DateTime completedAt,
                Value<int> rowid = const Value.absent(),
              }) => CompletionsTableCompanion.insert(
                taskId: taskId,
                occurrence: occurrence,
                completedAt: completedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CompletionsTableTable, CompletionRow>(table),
                  $$CompletionsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (taskId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.taskId,
                        referencedTable: $$CompletionsTableTableReferences
                            ._taskIdTable(db),
                        referencedColumn: $$CompletionsTableTableReferences
                            ._taskIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CompletionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$KlarDb,
      $CompletionsTableTable,
      CompletionRow,
      $$CompletionsTableTableFilterComposer,
      $$CompletionsTableTableOrderingComposer,
      $$CompletionsTableTableAnnotationComposer,
      $$CompletionsTableTableCreateCompanionBuilder,
      $$CompletionsTableTableUpdateCompanionBuilder,
      (CompletionRow, $$CompletionsTableTableReferences),
      CompletionRow,
      PrefetchHooks Function({bool taskId})
    >;
typedef $$SettingsTableTableCreateCompanionBuilder =
    SettingsTableCompanion Function({
      Value<int> id,
      required SoundRef sound,
      Value<int?> minVolume,
      required int rampSeconds,
      required VibrationPattern vibration,
      required int snoozeMinutes,
      required int autoSilenceMinutes,
      required int allDayMinutes,
      required int firstWeekday,
      required bool onboarded,
    });
typedef $$SettingsTableTableUpdateCompanionBuilder =
    SettingsTableCompanion Function({
      Value<int> id,
      Value<SoundRef> sound,
      Value<int?> minVolume,
      Value<int> rampSeconds,
      Value<VibrationPattern> vibration,
      Value<int> snoozeMinutes,
      Value<int> autoSilenceMinutes,
      Value<int> allDayMinutes,
      Value<int> firstWeekday,
      Value<bool> onboarded,
    });

class $$SettingsTableTableFilterComposer
    extends Composer<_$KlarDb, $SettingsTableTable> {
  $$SettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SoundRef, SoundRef, String> get sound =>
      $composableBuilder(
        column: $table.sound,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get minVolume => $composableBuilder(
    column: $table.minVolume,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rampSeconds => $composableBuilder(
    column: $table.rampSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<VibrationPattern, VibrationPattern, String>
  get vibration => $composableBuilder(
    column: $table.vibration,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get snoozeMinutes => $composableBuilder(
    column: $table.snoozeMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get autoSilenceMinutes => $composableBuilder(
    column: $table.autoSilenceMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get allDayMinutes => $composableBuilder(
    column: $table.allDayMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get firstWeekday => $composableBuilder(
    column: $table.firstWeekday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboarded => $composableBuilder(
    column: $table.onboarded,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableTableOrderingComposer
    extends Composer<_$KlarDb, $SettingsTableTable> {
  $$SettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sound => $composableBuilder(
    column: $table.sound,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minVolume => $composableBuilder(
    column: $table.minVolume,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rampSeconds => $composableBuilder(
    column: $table.rampSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vibration => $composableBuilder(
    column: $table.vibration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get snoozeMinutes => $composableBuilder(
    column: $table.snoozeMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get autoSilenceMinutes => $composableBuilder(
    column: $table.autoSilenceMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get allDayMinutes => $composableBuilder(
    column: $table.allDayMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get firstWeekday => $composableBuilder(
    column: $table.firstWeekday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboarded => $composableBuilder(
    column: $table.onboarded,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableTableAnnotationComposer
    extends Composer<_$KlarDb, $SettingsTableTable> {
  $$SettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SoundRef, String> get sound =>
      $composableBuilder(column: $table.sound, builder: (column) => column);

  GeneratedColumn<int> get minVolume =>
      $composableBuilder(column: $table.minVolume, builder: (column) => column);

  GeneratedColumn<int> get rampSeconds => $composableBuilder(
    column: $table.rampSeconds,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<VibrationPattern, String> get vibration =>
      $composableBuilder(column: $table.vibration, builder: (column) => column);

  GeneratedColumn<int> get snoozeMinutes => $composableBuilder(
    column: $table.snoozeMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get autoSilenceMinutes => $composableBuilder(
    column: $table.autoSilenceMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get allDayMinutes => $composableBuilder(
    column: $table.allDayMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get firstWeekday => $composableBuilder(
    column: $table.firstWeekday,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get onboarded =>
      $composableBuilder(column: $table.onboarded, builder: (column) => column);
}

class $$SettingsTableTableTableManager
    extends
        RootTableManager<
          _$KlarDb,
          $SettingsTableTable,
          SettingsRow,
          $$SettingsTableTableFilterComposer,
          $$SettingsTableTableOrderingComposer,
          $$SettingsTableTableAnnotationComposer,
          $$SettingsTableTableCreateCompanionBuilder,
          $$SettingsTableTableUpdateCompanionBuilder,
          (
            SettingsRow,
            BaseReferences<_$KlarDb, $SettingsTableTable, SettingsRow>,
          ),
          SettingsRow,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableTableManager(_$KlarDb db, $SettingsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<SoundRef> sound = const Value.absent(),
                Value<int?> minVolume = const Value.absent(),
                Value<int> rampSeconds = const Value.absent(),
                Value<VibrationPattern> vibration = const Value.absent(),
                Value<int> snoozeMinutes = const Value.absent(),
                Value<int> autoSilenceMinutes = const Value.absent(),
                Value<int> allDayMinutes = const Value.absent(),
                Value<int> firstWeekday = const Value.absent(),
                Value<bool> onboarded = const Value.absent(),
              }) => SettingsTableCompanion(
                id: id,
                sound: sound,
                minVolume: minVolume,
                rampSeconds: rampSeconds,
                vibration: vibration,
                snoozeMinutes: snoozeMinutes,
                autoSilenceMinutes: autoSilenceMinutes,
                allDayMinutes: allDayMinutes,
                firstWeekday: firstWeekday,
                onboarded: onboarded,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required SoundRef sound,
                Value<int?> minVolume = const Value.absent(),
                required int rampSeconds,
                required VibrationPattern vibration,
                required int snoozeMinutes,
                required int autoSilenceMinutes,
                required int allDayMinutes,
                required int firstWeekday,
                required bool onboarded,
              }) => SettingsTableCompanion.insert(
                id: id,
                sound: sound,
                minVolume: minVolume,
                rampSeconds: rampSeconds,
                vibration: vibration,
                snoozeMinutes: snoozeMinutes,
                autoSilenceMinutes: autoSilenceMinutes,
                allDayMinutes: allDayMinutes,
                firstWeekday: firstWeekday,
                onboarded: onboarded,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTableTable, SettingsRow>(table),
                  BaseReferences<_$KlarDb, $SettingsTableTable, SettingsRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$KlarDb,
      $SettingsTableTable,
      SettingsRow,
      $$SettingsTableTableFilterComposer,
      $$SettingsTableTableOrderingComposer,
      $$SettingsTableTableAnnotationComposer,
      $$SettingsTableTableCreateCompanionBuilder,
      $$SettingsTableTableUpdateCompanionBuilder,
      (SettingsRow, BaseReferences<_$KlarDb, $SettingsTableTable, SettingsRow>),
      SettingsRow,
      PrefetchHooks Function()
    >;

class $KlarDbManager {
  final _$KlarDb _db;
  $KlarDbManager(this._db);
  $$TaskListsTableTableTableManager get taskListsTable =>
      $$TaskListsTableTableTableManager(_db, _db.taskListsTable);
  $$TasksTableTableTableManager get tasksTable =>
      $$TasksTableTableTableManager(_db, _db.tasksTable);
  $$SubtasksTableTableTableManager get subtasksTable =>
      $$SubtasksTableTableTableManager(_db, _db.subtasksTable);
  $$RemindersTableTableTableManager get remindersTable =>
      $$RemindersTableTableTableManager(_db, _db.remindersTable);
  $$CompletionsTableTableTableManager get completionsTable =>
      $$CompletionsTableTableTableManager(_db, _db.completionsTable);
  $$SettingsTableTableTableManager get settingsTable =>
      $$SettingsTableTableTableManager(_db, _db.settingsTable);
}
