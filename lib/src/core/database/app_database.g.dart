// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(Insertable<AppSetting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  const AppSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      key: Value(key),
      value: Value(value),
    );
  }

  factory AppSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSetting copyWith({String? key, String? value}) => AppSetting(
        key: key ?? this.key,
        value: value ?? this.value,
      );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith(
      {Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetCategoriesTable extends BudgetCategories
    with TableInfo<$BudgetCategoriesTable, BudgetCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _limitMeta = const VerificationMeta('limit');
  @override
  late final GeneratedColumn<double> limit = GeneratedColumn<double>(
      'limit', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _spentMeta = const VerificationMeta('spent');
  @override
  late final GeneratedColumn<double> spent = GeneratedColumn<double>(
      'spent', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _colorValueMeta =
      const VerificationMeta('colorValue');
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
      'color_value', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, title, limit, spent, colorValue];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budget_categories';
  @override
  VerificationContext validateIntegrity(Insertable<BudgetCategory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('limit')) {
      context.handle(
          _limitMeta, limit.isAcceptableOrUnknown(data['limit']!, _limitMeta));
    } else if (isInserting) {
      context.missing(_limitMeta);
    }
    if (data.containsKey('spent')) {
      context.handle(
          _spentMeta, spent.isAcceptableOrUnknown(data['spent']!, _spentMeta));
    } else if (isInserting) {
      context.missing(_spentMeta);
    }
    if (data.containsKey('color_value')) {
      context.handle(
          _colorValueMeta,
          colorValue.isAcceptableOrUnknown(
              data['color_value']!, _colorValueMeta));
    } else if (isInserting) {
      context.missing(_colorValueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BudgetCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetCategory(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      limit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}limit'])!,
      spent: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}spent'])!,
      colorValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color_value'])!,
    );
  }

  @override
  $BudgetCategoriesTable createAlias(String alias) {
    return $BudgetCategoriesTable(attachedDatabase, alias);
  }
}

class BudgetCategory extends DataClass implements Insertable<BudgetCategory> {
  final String id;
  final String title;
  final double limit;
  final double spent;
  final int colorValue;
  const BudgetCategory(
      {required this.id,
      required this.title,
      required this.limit,
      required this.spent,
      required this.colorValue});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['limit'] = Variable<double>(limit);
    map['spent'] = Variable<double>(spent);
    map['color_value'] = Variable<int>(colorValue);
    return map;
  }

  BudgetCategoriesCompanion toCompanion(bool nullToAbsent) {
    return BudgetCategoriesCompanion(
      id: Value(id),
      title: Value(title),
      limit: Value(limit),
      spent: Value(spent),
      colorValue: Value(colorValue),
    );
  }

  factory BudgetCategory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetCategory(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      limit: serializer.fromJson<double>(json['limit']),
      spent: serializer.fromJson<double>(json['spent']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'limit': serializer.toJson<double>(limit),
      'spent': serializer.toJson<double>(spent),
      'colorValue': serializer.toJson<int>(colorValue),
    };
  }

  BudgetCategory copyWith(
          {String? id,
          String? title,
          double? limit,
          double? spent,
          int? colorValue}) =>
      BudgetCategory(
        id: id ?? this.id,
        title: title ?? this.title,
        limit: limit ?? this.limit,
        spent: spent ?? this.spent,
        colorValue: colorValue ?? this.colorValue,
      );
  BudgetCategory copyWithCompanion(BudgetCategoriesCompanion data) {
    return BudgetCategory(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      limit: data.limit.present ? data.limit.value : this.limit,
      spent: data.spent.present ? data.spent.value : this.spent,
      colorValue:
          data.colorValue.present ? data.colorValue.value : this.colorValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetCategory(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('limit: $limit, ')
          ..write('spent: $spent, ')
          ..write('colorValue: $colorValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, limit, spent, colorValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetCategory &&
          other.id == this.id &&
          other.title == this.title &&
          other.limit == this.limit &&
          other.spent == this.spent &&
          other.colorValue == this.colorValue);
}

class BudgetCategoriesCompanion extends UpdateCompanion<BudgetCategory> {
  final Value<String> id;
  final Value<String> title;
  final Value<double> limit;
  final Value<double> spent;
  final Value<int> colorValue;
  final Value<int> rowid;
  const BudgetCategoriesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.limit = const Value.absent(),
    this.spent = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetCategoriesCompanion.insert({
    required String id,
    required String title,
    required double limit,
    required double spent,
    required int colorValue,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        limit = Value(limit),
        spent = Value(spent),
        colorValue = Value(colorValue);
  static Insertable<BudgetCategory> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<double>? limit,
    Expression<double>? spent,
    Expression<int>? colorValue,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (limit != null) 'limit': limit,
      if (spent != null) 'spent': spent,
      if (colorValue != null) 'color_value': colorValue,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetCategoriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<double>? limit,
      Value<double>? spent,
      Value<int>? colorValue,
      Value<int>? rowid}) {
    return BudgetCategoriesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      limit: limit ?? this.limit,
      spent: spent ?? this.spent,
      colorValue: colorValue ?? this.colorValue,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (limit.present) {
      map['limit'] = Variable<double>(limit.value);
    }
    if (spent.present) {
      map['spent'] = Variable<double>(spent.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('limit: $limit, ')
          ..write('spent: $spent, ')
          ..write('colorValue: $colorValue, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, amount, category, date, type];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(Insertable<Transaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String type;
  const Transaction(
      {required this.id,
      required this.title,
      required this.amount,
      required this.category,
      required this.date,
      required this.type});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['amount'] = Variable<double>(amount);
    map['category'] = Variable<String>(category);
    map['date'] = Variable<DateTime>(date);
    map['type'] = Variable<String>(type);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      title: Value(title),
      amount: Value(amount),
      category: Value(category),
      date: Value(date),
      type: Value(type),
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      amount: serializer.fromJson<double>(json['amount']),
      category: serializer.fromJson<String>(json['category']),
      date: serializer.fromJson<DateTime>(json['date']),
      type: serializer.fromJson<String>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'amount': serializer.toJson<double>(amount),
      'category': serializer.toJson<String>(category),
      'date': serializer.toJson<DateTime>(date),
      'type': serializer.toJson<String>(type),
    };
  }

  Transaction copyWith(
          {String? id,
          String? title,
          double? amount,
          String? category,
          DateTime? date,
          String? type}) =>
      Transaction(
        id: id ?? this.id,
        title: title ?? this.title,
        amount: amount ?? this.amount,
        category: category ?? this.category,
        date: date ?? this.date,
        type: type ?? this.type,
      );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      amount: data.amount.present ? data.amount.value : this.amount,
      category: data.category.present ? data.category.value : this.category,
      date: data.date.present ? data.date.value : this.date,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('date: $date, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, amount, category, date, type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.title == this.title &&
          other.amount == this.amount &&
          other.category == this.category &&
          other.date == this.date &&
          other.type == this.type);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<String> id;
  final Value<String> title;
  final Value<double> amount;
  final Value<String> category;
  final Value<DateTime> date;
  final Value<String> type;
  final Value<int> rowid;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.amount = const Value.absent(),
    this.category = const Value.absent(),
    this.date = const Value.absent(),
    this.type = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsCompanion.insert({
    required String id,
    required String title,
    required double amount,
    required String category,
    required DateTime date,
    required String type,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        amount = Value(amount),
        category = Value(category),
        date = Value(date),
        type = Value(type);
  static Insertable<Transaction> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<double>? amount,
    Expression<String>? category,
    Expression<DateTime>? date,
    Expression<String>? type,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (amount != null) 'amount': amount,
      if (category != null) 'category': category,
      if (date != null) 'date': date,
      if (type != null) 'type': type,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<double>? amount,
      Value<String>? category,
      Value<DateTime>? date,
      Value<String>? type,
      Value<int>? rowid}) {
    return TransactionsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      type: type ?? this.type,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlannedExpensesTable extends PlannedExpenses
    with TableInfo<$PlannedExpensesTable, PlannedExpense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlannedExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _groupMeta = const VerificationMeta('group');
  @override
  late final GeneratedColumn<String> group = GeneratedColumn<String>(
      'group', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _paymentSourceMeta =
      const VerificationMeta('paymentSource');
  @override
  late final GeneratedColumn<String> paymentSource = GeneratedColumn<String>(
      'payment_source', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, amount, group, status, paymentSource, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'planned_expenses';
  @override
  VerificationContext validateIntegrity(Insertable<PlannedExpense> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('group')) {
      context.handle(
          _groupMeta, group.isAcceptableOrUnknown(data['group']!, _groupMeta));
    } else if (isInserting) {
      context.missing(_groupMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('payment_source')) {
      context.handle(
          _paymentSourceMeta,
          paymentSource.isAcceptableOrUnknown(
              data['payment_source']!, _paymentSourceMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlannedExpense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlannedExpense(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      group: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}group'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      paymentSource: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_source']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
    );
  }

  @override
  $PlannedExpensesTable createAlias(String alias) {
    return $PlannedExpensesTable(attachedDatabase, alias);
  }
}

class PlannedExpense extends DataClass implements Insertable<PlannedExpense> {
  final String id;
  final String title;
  final double amount;
  final String group;
  final String status;
  final String? paymentSource;
  final String? note;
  const PlannedExpense(
      {required this.id,
      required this.title,
      required this.amount,
      required this.group,
      required this.status,
      this.paymentSource,
      this.note});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['amount'] = Variable<double>(amount);
    map['group'] = Variable<String>(group);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || paymentSource != null) {
      map['payment_source'] = Variable<String>(paymentSource);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  PlannedExpensesCompanion toCompanion(bool nullToAbsent) {
    return PlannedExpensesCompanion(
      id: Value(id),
      title: Value(title),
      amount: Value(amount),
      group: Value(group),
      status: Value(status),
      paymentSource: paymentSource == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentSource),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory PlannedExpense.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlannedExpense(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      amount: serializer.fromJson<double>(json['amount']),
      group: serializer.fromJson<String>(json['group']),
      status: serializer.fromJson<String>(json['status']),
      paymentSource: serializer.fromJson<String?>(json['paymentSource']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'amount': serializer.toJson<double>(amount),
      'group': serializer.toJson<String>(group),
      'status': serializer.toJson<String>(status),
      'paymentSource': serializer.toJson<String?>(paymentSource),
      'note': serializer.toJson<String?>(note),
    };
  }

  PlannedExpense copyWith(
          {String? id,
          String? title,
          double? amount,
          String? group,
          String? status,
          Value<String?> paymentSource = const Value.absent(),
          Value<String?> note = const Value.absent()}) =>
      PlannedExpense(
        id: id ?? this.id,
        title: title ?? this.title,
        amount: amount ?? this.amount,
        group: group ?? this.group,
        status: status ?? this.status,
        paymentSource:
            paymentSource.present ? paymentSource.value : this.paymentSource,
        note: note.present ? note.value : this.note,
      );
  PlannedExpense copyWithCompanion(PlannedExpensesCompanion data) {
    return PlannedExpense(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      amount: data.amount.present ? data.amount.value : this.amount,
      group: data.group.present ? data.group.value : this.group,
      status: data.status.present ? data.status.value : this.status,
      paymentSource: data.paymentSource.present
          ? data.paymentSource.value
          : this.paymentSource,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlannedExpense(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('group: $group, ')
          ..write('status: $status, ')
          ..write('paymentSource: $paymentSource, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, amount, group, status, paymentSource, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlannedExpense &&
          other.id == this.id &&
          other.title == this.title &&
          other.amount == this.amount &&
          other.group == this.group &&
          other.status == this.status &&
          other.paymentSource == this.paymentSource &&
          other.note == this.note);
}

class PlannedExpensesCompanion extends UpdateCompanion<PlannedExpense> {
  final Value<String> id;
  final Value<String> title;
  final Value<double> amount;
  final Value<String> group;
  final Value<String> status;
  final Value<String?> paymentSource;
  final Value<String?> note;
  final Value<int> rowid;
  const PlannedExpensesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.amount = const Value.absent(),
    this.group = const Value.absent(),
    this.status = const Value.absent(),
    this.paymentSource = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlannedExpensesCompanion.insert({
    required String id,
    required String title,
    required double amount,
    required String group,
    required String status,
    this.paymentSource = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        amount = Value(amount),
        group = Value(group),
        status = Value(status);
  static Insertable<PlannedExpense> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<double>? amount,
    Expression<String>? group,
    Expression<String>? status,
    Expression<String>? paymentSource,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (amount != null) 'amount': amount,
      if (group != null) 'group': group,
      if (status != null) 'status': status,
      if (paymentSource != null) 'payment_source': paymentSource,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlannedExpensesCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<double>? amount,
      Value<String>? group,
      Value<String>? status,
      Value<String?>? paymentSource,
      Value<String?>? note,
      Value<int>? rowid}) {
    return PlannedExpensesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      group: group ?? this.group,
      status: status ?? this.status,
      paymentSource: paymentSource ?? this.paymentSource,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (group.present) {
      map['group'] = Variable<String>(group.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (paymentSource.present) {
      map['payment_source'] = Variable<String>(paymentSource.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlannedExpensesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('group: $group, ')
          ..write('status: $status, ')
          ..write('paymentSource: $paymentSource, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CreditCardsTable extends CreditCards
    with TableInfo<$CreditCardsTable, CreditCard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CreditCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _creditLimitMeta =
      const VerificationMeta('creditLimit');
  @override
  late final GeneratedColumn<double> creditLimit = GeneratedColumn<double>(
      'credit_limit', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _usedBalanceMeta =
      const VerificationMeta('usedBalance');
  @override
  late final GeneratedColumn<double> usedBalance = GeneratedColumn<double>(
      'used_balance', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _statementCutDayMeta =
      const VerificationMeta('statementCutDay');
  @override
  late final GeneratedColumn<int> statementCutDay = GeneratedColumn<int>(
      'statement_cut_day', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, creditLimit, usedBalance, statementCutDay];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'credit_cards';
  @override
  VerificationContext validateIntegrity(Insertable<CreditCard> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('credit_limit')) {
      context.handle(
          _creditLimitMeta,
          creditLimit.isAcceptableOrUnknown(
              data['credit_limit']!, _creditLimitMeta));
    } else if (isInserting) {
      context.missing(_creditLimitMeta);
    }
    if (data.containsKey('used_balance')) {
      context.handle(
          _usedBalanceMeta,
          usedBalance.isAcceptableOrUnknown(
              data['used_balance']!, _usedBalanceMeta));
    } else if (isInserting) {
      context.missing(_usedBalanceMeta);
    }
    if (data.containsKey('statement_cut_day')) {
      context.handle(
          _statementCutDayMeta,
          statementCutDay.isAcceptableOrUnknown(
              data['statement_cut_day']!, _statementCutDayMeta));
    } else if (isInserting) {
      context.missing(_statementCutDayMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CreditCard map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CreditCard(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      creditLimit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}credit_limit'])!,
      usedBalance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}used_balance'])!,
      statementCutDay: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}statement_cut_day'])!,
    );
  }

  @override
  $CreditCardsTable createAlias(String alias) {
    return $CreditCardsTable(attachedDatabase, alias);
  }
}

class CreditCard extends DataClass implements Insertable<CreditCard> {
  final String id;
  final String name;
  final double creditLimit;
  final double usedBalance;
  final int statementCutDay;
  const CreditCard(
      {required this.id,
      required this.name,
      required this.creditLimit,
      required this.usedBalance,
      required this.statementCutDay});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['credit_limit'] = Variable<double>(creditLimit);
    map['used_balance'] = Variable<double>(usedBalance);
    map['statement_cut_day'] = Variable<int>(statementCutDay);
    return map;
  }

  CreditCardsCompanion toCompanion(bool nullToAbsent) {
    return CreditCardsCompanion(
      id: Value(id),
      name: Value(name),
      creditLimit: Value(creditLimit),
      usedBalance: Value(usedBalance),
      statementCutDay: Value(statementCutDay),
    );
  }

  factory CreditCard.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CreditCard(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      creditLimit: serializer.fromJson<double>(json['creditLimit']),
      usedBalance: serializer.fromJson<double>(json['usedBalance']),
      statementCutDay: serializer.fromJson<int>(json['statementCutDay']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'creditLimit': serializer.toJson<double>(creditLimit),
      'usedBalance': serializer.toJson<double>(usedBalance),
      'statementCutDay': serializer.toJson<int>(statementCutDay),
    };
  }

  CreditCard copyWith(
          {String? id,
          String? name,
          double? creditLimit,
          double? usedBalance,
          int? statementCutDay}) =>
      CreditCard(
        id: id ?? this.id,
        name: name ?? this.name,
        creditLimit: creditLimit ?? this.creditLimit,
        usedBalance: usedBalance ?? this.usedBalance,
        statementCutDay: statementCutDay ?? this.statementCutDay,
      );
  CreditCard copyWithCompanion(CreditCardsCompanion data) {
    return CreditCard(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      creditLimit:
          data.creditLimit.present ? data.creditLimit.value : this.creditLimit,
      usedBalance:
          data.usedBalance.present ? data.usedBalance.value : this.usedBalance,
      statementCutDay: data.statementCutDay.present
          ? data.statementCutDay.value
          : this.statementCutDay,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CreditCard(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('creditLimit: $creditLimit, ')
          ..write('usedBalance: $usedBalance, ')
          ..write('statementCutDay: $statementCutDay')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, creditLimit, usedBalance, statementCutDay);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CreditCard &&
          other.id == this.id &&
          other.name == this.name &&
          other.creditLimit == this.creditLimit &&
          other.usedBalance == this.usedBalance &&
          other.statementCutDay == this.statementCutDay);
}

class CreditCardsCompanion extends UpdateCompanion<CreditCard> {
  final Value<String> id;
  final Value<String> name;
  final Value<double> creditLimit;
  final Value<double> usedBalance;
  final Value<int> statementCutDay;
  final Value<int> rowid;
  const CreditCardsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.creditLimit = const Value.absent(),
    this.usedBalance = const Value.absent(),
    this.statementCutDay = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CreditCardsCompanion.insert({
    required String id,
    required String name,
    required double creditLimit,
    required double usedBalance,
    required int statementCutDay,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        creditLimit = Value(creditLimit),
        usedBalance = Value(usedBalance),
        statementCutDay = Value(statementCutDay);
  static Insertable<CreditCard> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<double>? creditLimit,
    Expression<double>? usedBalance,
    Expression<int>? statementCutDay,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (creditLimit != null) 'credit_limit': creditLimit,
      if (usedBalance != null) 'used_balance': usedBalance,
      if (statementCutDay != null) 'statement_cut_day': statementCutDay,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CreditCardsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<double>? creditLimit,
      Value<double>? usedBalance,
      Value<int>? statementCutDay,
      Value<int>? rowid}) {
    return CreditCardsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      creditLimit: creditLimit ?? this.creditLimit,
      usedBalance: usedBalance ?? this.usedBalance,
      statementCutDay: statementCutDay ?? this.statementCutDay,
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
    if (creditLimit.present) {
      map['credit_limit'] = Variable<double>(creditLimit.value);
    }
    if (usedBalance.present) {
      map['used_balance'] = Variable<double>(usedBalance.value);
    }
    if (statementCutDay.present) {
      map['statement_cut_day'] = Variable<int>(statementCutDay.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CreditCardsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('creditLimit: $creditLimit, ')
          ..write('usedBalance: $usedBalance, ')
          ..write('statementCutDay: $statementCutDay, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CreditCardPurchasesTable extends CreditCardPurchases
    with TableInfo<$CreditCardPurchasesTable, CreditCardPurchase> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CreditCardPurchasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
      'card_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _installmentsMeta =
      const VerificationMeta('installments');
  @override
  late final GeneratedColumn<int> installments = GeneratedColumn<int>(
      'installments', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _paidInstallmentsMeta =
      const VerificationMeta('paidInstallments');
  @override
  late final GeneratedColumn<int> paidInstallments = GeneratedColumn<int>(
      'paid_installments', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, cardId, title, amount, installments, paidInstallments, date, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'credit_card_purchases';
  @override
  VerificationContext validateIntegrity(Insertable<CreditCardPurchase> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('card_id')) {
      context.handle(_cardIdMeta,
          cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta));
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('installments')) {
      context.handle(
          _installmentsMeta,
          installments.isAcceptableOrUnknown(
              data['installments']!, _installmentsMeta));
    } else if (isInserting) {
      context.missing(_installmentsMeta);
    }
    if (data.containsKey('paid_installments')) {
      context.handle(
          _paidInstallmentsMeta,
          paidInstallments.isAcceptableOrUnknown(
              data['paid_installments']!, _paidInstallmentsMeta));
    } else if (isInserting) {
      context.missing(_paidInstallmentsMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CreditCardPurchase map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CreditCardPurchase(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      cardId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}card_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      installments: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}installments'])!,
      paidInstallments: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}paid_installments'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $CreditCardPurchasesTable createAlias(String alias) {
    return $CreditCardPurchasesTable(attachedDatabase, alias);
  }
}

class CreditCardPurchase extends DataClass
    implements Insertable<CreditCardPurchase> {
  final String id;
  final String cardId;
  final String title;
  final double amount;
  final int installments;
  final int paidInstallments;
  final DateTime? date;
  final String? notes;
  const CreditCardPurchase(
      {required this.id,
      required this.cardId,
      required this.title,
      required this.amount,
      required this.installments,
      required this.paidInstallments,
      this.date,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['card_id'] = Variable<String>(cardId);
    map['title'] = Variable<String>(title);
    map['amount'] = Variable<double>(amount);
    map['installments'] = Variable<int>(installments);
    map['paid_installments'] = Variable<int>(paidInstallments);
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime>(date);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  CreditCardPurchasesCompanion toCompanion(bool nullToAbsent) {
    return CreditCardPurchasesCompanion(
      id: Value(id),
      cardId: Value(cardId),
      title: Value(title),
      amount: Value(amount),
      installments: Value(installments),
      paidInstallments: Value(paidInstallments),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory CreditCardPurchase.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CreditCardPurchase(
      id: serializer.fromJson<String>(json['id']),
      cardId: serializer.fromJson<String>(json['cardId']),
      title: serializer.fromJson<String>(json['title']),
      amount: serializer.fromJson<double>(json['amount']),
      installments: serializer.fromJson<int>(json['installments']),
      paidInstallments: serializer.fromJson<int>(json['paidInstallments']),
      date: serializer.fromJson<DateTime?>(json['date']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cardId': serializer.toJson<String>(cardId),
      'title': serializer.toJson<String>(title),
      'amount': serializer.toJson<double>(amount),
      'installments': serializer.toJson<int>(installments),
      'paidInstallments': serializer.toJson<int>(paidInstallments),
      'date': serializer.toJson<DateTime?>(date),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  CreditCardPurchase copyWith(
          {String? id,
          String? cardId,
          String? title,
          double? amount,
          int? installments,
          int? paidInstallments,
          Value<DateTime?> date = const Value.absent(),
          Value<String?> notes = const Value.absent()}) =>
      CreditCardPurchase(
        id: id ?? this.id,
        cardId: cardId ?? this.cardId,
        title: title ?? this.title,
        amount: amount ?? this.amount,
        installments: installments ?? this.installments,
        paidInstallments: paidInstallments ?? this.paidInstallments,
        date: date.present ? date.value : this.date,
        notes: notes.present ? notes.value : this.notes,
      );
  CreditCardPurchase copyWithCompanion(CreditCardPurchasesCompanion data) {
    return CreditCardPurchase(
      id: data.id.present ? data.id.value : this.id,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      title: data.title.present ? data.title.value : this.title,
      amount: data.amount.present ? data.amount.value : this.amount,
      installments: data.installments.present
          ? data.installments.value
          : this.installments,
      paidInstallments: data.paidInstallments.present
          ? data.paidInstallments.value
          : this.paidInstallments,
      date: data.date.present ? data.date.value : this.date,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CreditCardPurchase(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('installments: $installments, ')
          ..write('paidInstallments: $paidInstallments, ')
          ..write('date: $date, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, cardId, title, amount, installments, paidInstallments, date, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CreditCardPurchase &&
          other.id == this.id &&
          other.cardId == this.cardId &&
          other.title == this.title &&
          other.amount == this.amount &&
          other.installments == this.installments &&
          other.paidInstallments == this.paidInstallments &&
          other.date == this.date &&
          other.notes == this.notes);
}

class CreditCardPurchasesCompanion extends UpdateCompanion<CreditCardPurchase> {
  final Value<String> id;
  final Value<String> cardId;
  final Value<String> title;
  final Value<double> amount;
  final Value<int> installments;
  final Value<int> paidInstallments;
  final Value<DateTime?> date;
  final Value<String?> notes;
  final Value<int> rowid;
  const CreditCardPurchasesCompanion({
    this.id = const Value.absent(),
    this.cardId = const Value.absent(),
    this.title = const Value.absent(),
    this.amount = const Value.absent(),
    this.installments = const Value.absent(),
    this.paidInstallments = const Value.absent(),
    this.date = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CreditCardPurchasesCompanion.insert({
    required String id,
    required String cardId,
    required String title,
    required double amount,
    required int installments,
    required int paidInstallments,
    this.date = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        cardId = Value(cardId),
        title = Value(title),
        amount = Value(amount),
        installments = Value(installments),
        paidInstallments = Value(paidInstallments);
  static Insertable<CreditCardPurchase> custom({
    Expression<String>? id,
    Expression<String>? cardId,
    Expression<String>? title,
    Expression<double>? amount,
    Expression<int>? installments,
    Expression<int>? paidInstallments,
    Expression<DateTime>? date,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardId != null) 'card_id': cardId,
      if (title != null) 'title': title,
      if (amount != null) 'amount': amount,
      if (installments != null) 'installments': installments,
      if (paidInstallments != null) 'paid_installments': paidInstallments,
      if (date != null) 'date': date,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CreditCardPurchasesCompanion copyWith(
      {Value<String>? id,
      Value<String>? cardId,
      Value<String>? title,
      Value<double>? amount,
      Value<int>? installments,
      Value<int>? paidInstallments,
      Value<DateTime?>? date,
      Value<String?>? notes,
      Value<int>? rowid}) {
    return CreditCardPurchasesCompanion(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      installments: installments ?? this.installments,
      paidInstallments: paidInstallments ?? this.paidInstallments,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (installments.present) {
      map['installments'] = Variable<int>(installments.value);
    }
    if (paidInstallments.present) {
      map['paid_installments'] = Variable<int>(paidInstallments.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CreditCardPurchasesCompanion(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('installments: $installments, ')
          ..write('paidInstallments: $paidInstallments, ')
          ..write('date: $date, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubscriptionsTable extends Subscriptions
    with TableInfo<$SubscriptionsTable, Subscription> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubscriptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
      'card_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, amount, cardId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subscriptions';
  @override
  VerificationContext validateIntegrity(Insertable<Subscription> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('card_id')) {
      context.handle(_cardIdMeta,
          cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta));
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Subscription map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Subscription(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      cardId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}card_id'])!,
    );
  }

  @override
  $SubscriptionsTable createAlias(String alias) {
    return $SubscriptionsTable(attachedDatabase, alias);
  }
}

class Subscription extends DataClass implements Insertable<Subscription> {
  final String id;
  final String name;
  final double amount;
  final String cardId;
  const Subscription(
      {required this.id,
      required this.name,
      required this.amount,
      required this.cardId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['amount'] = Variable<double>(amount);
    map['card_id'] = Variable<String>(cardId);
    return map;
  }

  SubscriptionsCompanion toCompanion(bool nullToAbsent) {
    return SubscriptionsCompanion(
      id: Value(id),
      name: Value(name),
      amount: Value(amount),
      cardId: Value(cardId),
    );
  }

  factory Subscription.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Subscription(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      amount: serializer.fromJson<double>(json['amount']),
      cardId: serializer.fromJson<String>(json['cardId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'amount': serializer.toJson<double>(amount),
      'cardId': serializer.toJson<String>(cardId),
    };
  }

  Subscription copyWith(
          {String? id, String? name, double? amount, String? cardId}) =>
      Subscription(
        id: id ?? this.id,
        name: name ?? this.name,
        amount: amount ?? this.amount,
        cardId: cardId ?? this.cardId,
      );
  Subscription copyWithCompanion(SubscriptionsCompanion data) {
    return Subscription(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      amount: data.amount.present ? data.amount.value : this.amount,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Subscription(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('cardId: $cardId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, amount, cardId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Subscription &&
          other.id == this.id &&
          other.name == this.name &&
          other.amount == this.amount &&
          other.cardId == this.cardId);
}

class SubscriptionsCompanion extends UpdateCompanion<Subscription> {
  final Value<String> id;
  final Value<String> name;
  final Value<double> amount;
  final Value<String> cardId;
  final Value<int> rowid;
  const SubscriptionsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.amount = const Value.absent(),
    this.cardId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubscriptionsCompanion.insert({
    required String id,
    required String name,
    required double amount,
    required String cardId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        amount = Value(amount),
        cardId = Value(cardId);
  static Insertable<Subscription> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<double>? amount,
    Expression<String>? cardId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (amount != null) 'amount': amount,
      if (cardId != null) 'card_id': cardId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubscriptionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<double>? amount,
      Value<String>? cardId,
      Value<int>? rowid}) {
    return SubscriptionsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      cardId: cardId ?? this.cardId,
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
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('cardId: $cardId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CreditCardMonthlyPaymentsTable extends CreditCardMonthlyPayments
    with TableInfo<$CreditCardMonthlyPaymentsTable, CreditCardMonthlyPayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CreditCardMonthlyPaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
      'card_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _manualAmountMeta =
      const VerificationMeta('manualAmount');
  @override
  late final GeneratedColumn<double> manualAmount = GeneratedColumn<double>(
      'manual_amount', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _confirmedAmountMeta =
      const VerificationMeta('confirmedAmount');
  @override
  late final GeneratedColumn<double> confirmedAmount = GeneratedColumn<double>(
      'confirmed_amount', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [cardId, manualAmount, confirmedAmount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'credit_card_monthly_payments';
  @override
  VerificationContext validateIntegrity(
      Insertable<CreditCardMonthlyPayment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('card_id')) {
      context.handle(_cardIdMeta,
          cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta));
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('manual_amount')) {
      context.handle(
          _manualAmountMeta,
          manualAmount.isAcceptableOrUnknown(
              data['manual_amount']!, _manualAmountMeta));
    }
    if (data.containsKey('confirmed_amount')) {
      context.handle(
          _confirmedAmountMeta,
          confirmedAmount.isAcceptableOrUnknown(
              data['confirmed_amount']!, _confirmedAmountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cardId};
  @override
  CreditCardMonthlyPayment map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CreditCardMonthlyPayment(
      cardId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}card_id'])!,
      manualAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}manual_amount']),
      confirmedAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}confirmed_amount']),
    );
  }

  @override
  $CreditCardMonthlyPaymentsTable createAlias(String alias) {
    return $CreditCardMonthlyPaymentsTable(attachedDatabase, alias);
  }
}

class CreditCardMonthlyPayment extends DataClass
    implements Insertable<CreditCardMonthlyPayment> {
  final String cardId;
  final double? manualAmount;
  final double? confirmedAmount;
  const CreditCardMonthlyPayment(
      {required this.cardId, this.manualAmount, this.confirmedAmount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['card_id'] = Variable<String>(cardId);
    if (!nullToAbsent || manualAmount != null) {
      map['manual_amount'] = Variable<double>(manualAmount);
    }
    if (!nullToAbsent || confirmedAmount != null) {
      map['confirmed_amount'] = Variable<double>(confirmedAmount);
    }
    return map;
  }

  CreditCardMonthlyPaymentsCompanion toCompanion(bool nullToAbsent) {
    return CreditCardMonthlyPaymentsCompanion(
      cardId: Value(cardId),
      manualAmount: manualAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(manualAmount),
      confirmedAmount: confirmedAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(confirmedAmount),
    );
  }

  factory CreditCardMonthlyPayment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CreditCardMonthlyPayment(
      cardId: serializer.fromJson<String>(json['cardId']),
      manualAmount: serializer.fromJson<double?>(json['manualAmount']),
      confirmedAmount: serializer.fromJson<double?>(json['confirmedAmount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cardId': serializer.toJson<String>(cardId),
      'manualAmount': serializer.toJson<double?>(manualAmount),
      'confirmedAmount': serializer.toJson<double?>(confirmedAmount),
    };
  }

  CreditCardMonthlyPayment copyWith(
          {String? cardId,
          Value<double?> manualAmount = const Value.absent(),
          Value<double?> confirmedAmount = const Value.absent()}) =>
      CreditCardMonthlyPayment(
        cardId: cardId ?? this.cardId,
        manualAmount:
            manualAmount.present ? manualAmount.value : this.manualAmount,
        confirmedAmount: confirmedAmount.present
            ? confirmedAmount.value
            : this.confirmedAmount,
      );
  CreditCardMonthlyPayment copyWithCompanion(
      CreditCardMonthlyPaymentsCompanion data) {
    return CreditCardMonthlyPayment(
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      manualAmount: data.manualAmount.present
          ? data.manualAmount.value
          : this.manualAmount,
      confirmedAmount: data.confirmedAmount.present
          ? data.confirmedAmount.value
          : this.confirmedAmount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CreditCardMonthlyPayment(')
          ..write('cardId: $cardId, ')
          ..write('manualAmount: $manualAmount, ')
          ..write('confirmedAmount: $confirmedAmount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(cardId, manualAmount, confirmedAmount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CreditCardMonthlyPayment &&
          other.cardId == this.cardId &&
          other.manualAmount == this.manualAmount &&
          other.confirmedAmount == this.confirmedAmount);
}

class CreditCardMonthlyPaymentsCompanion
    extends UpdateCompanion<CreditCardMonthlyPayment> {
  final Value<String> cardId;
  final Value<double?> manualAmount;
  final Value<double?> confirmedAmount;
  final Value<int> rowid;
  const CreditCardMonthlyPaymentsCompanion({
    this.cardId = const Value.absent(),
    this.manualAmount = const Value.absent(),
    this.confirmedAmount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CreditCardMonthlyPaymentsCompanion.insert({
    required String cardId,
    this.manualAmount = const Value.absent(),
    this.confirmedAmount = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : cardId = Value(cardId);
  static Insertable<CreditCardMonthlyPayment> custom({
    Expression<String>? cardId,
    Expression<double>? manualAmount,
    Expression<double>? confirmedAmount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (cardId != null) 'card_id': cardId,
      if (manualAmount != null) 'manual_amount': manualAmount,
      if (confirmedAmount != null) 'confirmed_amount': confirmedAmount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CreditCardMonthlyPaymentsCompanion copyWith(
      {Value<String>? cardId,
      Value<double?>? manualAmount,
      Value<double?>? confirmedAmount,
      Value<int>? rowid}) {
    return CreditCardMonthlyPaymentsCompanion(
      cardId: cardId ?? this.cardId,
      manualAmount: manualAmount ?? this.manualAmount,
      confirmedAmount: confirmedAmount ?? this.confirmedAmount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (manualAmount.present) {
      map['manual_amount'] = Variable<double>(manualAmount.value);
    }
    if (confirmedAmount.present) {
      map['confirmed_amount'] = Variable<double>(confirmedAmount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CreditCardMonthlyPaymentsCompanion(')
          ..write('cardId: $cardId, ')
          ..write('manualAmount: $manualAmount, ')
          ..write('confirmedAmount: $confirmedAmount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MonthlyExtrasTable extends MonthlyExtras
    with TableInfo<$MonthlyExtrasTable, MonthlyExtra> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MonthlyExtrasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _includedInPlanMeta =
      const VerificationMeta('includedInPlan');
  @override
  late final GeneratedColumn<bool> includedInPlan = GeneratedColumn<bool>(
      'included_in_plan', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("included_in_plan" IN (0, 1))'));
  static const VerificationMeta _personMeta = const VerificationMeta('person');
  @override
  late final GeneratedColumn<String> person = GeneratedColumn<String>(
      'person', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, amount, status, includedInPlan, person, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'monthly_extras';
  @override
  VerificationContext validateIntegrity(Insertable<MonthlyExtra> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('included_in_plan')) {
      context.handle(
          _includedInPlanMeta,
          includedInPlan.isAcceptableOrUnknown(
              data['included_in_plan']!, _includedInPlanMeta));
    } else if (isInserting) {
      context.missing(_includedInPlanMeta);
    }
    if (data.containsKey('person')) {
      context.handle(_personMeta,
          person.isAcceptableOrUnknown(data['person']!, _personMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MonthlyExtra map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MonthlyExtra(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      includedInPlan: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}included_in_plan'])!,
      person: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}person']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $MonthlyExtrasTable createAlias(String alias) {
    return $MonthlyExtrasTable(attachedDatabase, alias);
  }
}

class MonthlyExtra extends DataClass implements Insertable<MonthlyExtra> {
  final String id;
  final String name;
  final double amount;
  final String status;
  final bool includedInPlan;
  final String? person;
  final String? notes;
  const MonthlyExtra(
      {required this.id,
      required this.name,
      required this.amount,
      required this.status,
      required this.includedInPlan,
      this.person,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['amount'] = Variable<double>(amount);
    map['status'] = Variable<String>(status);
    map['included_in_plan'] = Variable<bool>(includedInPlan);
    if (!nullToAbsent || person != null) {
      map['person'] = Variable<String>(person);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  MonthlyExtrasCompanion toCompanion(bool nullToAbsent) {
    return MonthlyExtrasCompanion(
      id: Value(id),
      name: Value(name),
      amount: Value(amount),
      status: Value(status),
      includedInPlan: Value(includedInPlan),
      person:
          person == null && nullToAbsent ? const Value.absent() : Value(person),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory MonthlyExtra.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MonthlyExtra(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      amount: serializer.fromJson<double>(json['amount']),
      status: serializer.fromJson<String>(json['status']),
      includedInPlan: serializer.fromJson<bool>(json['includedInPlan']),
      person: serializer.fromJson<String?>(json['person']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'amount': serializer.toJson<double>(amount),
      'status': serializer.toJson<String>(status),
      'includedInPlan': serializer.toJson<bool>(includedInPlan),
      'person': serializer.toJson<String?>(person),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  MonthlyExtra copyWith(
          {String? id,
          String? name,
          double? amount,
          String? status,
          bool? includedInPlan,
          Value<String?> person = const Value.absent(),
          Value<String?> notes = const Value.absent()}) =>
      MonthlyExtra(
        id: id ?? this.id,
        name: name ?? this.name,
        amount: amount ?? this.amount,
        status: status ?? this.status,
        includedInPlan: includedInPlan ?? this.includedInPlan,
        person: person.present ? person.value : this.person,
        notes: notes.present ? notes.value : this.notes,
      );
  MonthlyExtra copyWithCompanion(MonthlyExtrasCompanion data) {
    return MonthlyExtra(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      amount: data.amount.present ? data.amount.value : this.amount,
      status: data.status.present ? data.status.value : this.status,
      includedInPlan: data.includedInPlan.present
          ? data.includedInPlan.value
          : this.includedInPlan,
      person: data.person.present ? data.person.value : this.person,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MonthlyExtra(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('status: $status, ')
          ..write('includedInPlan: $includedInPlan, ')
          ..write('person: $person, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, amount, status, includedInPlan, person, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MonthlyExtra &&
          other.id == this.id &&
          other.name == this.name &&
          other.amount == this.amount &&
          other.status == this.status &&
          other.includedInPlan == this.includedInPlan &&
          other.person == this.person &&
          other.notes == this.notes);
}

class MonthlyExtrasCompanion extends UpdateCompanion<MonthlyExtra> {
  final Value<String> id;
  final Value<String> name;
  final Value<double> amount;
  final Value<String> status;
  final Value<bool> includedInPlan;
  final Value<String?> person;
  final Value<String?> notes;
  final Value<int> rowid;
  const MonthlyExtrasCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.amount = const Value.absent(),
    this.status = const Value.absent(),
    this.includedInPlan = const Value.absent(),
    this.person = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MonthlyExtrasCompanion.insert({
    required String id,
    required String name,
    required double amount,
    required String status,
    required bool includedInPlan,
    this.person = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        amount = Value(amount),
        status = Value(status),
        includedInPlan = Value(includedInPlan);
  static Insertable<MonthlyExtra> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<double>? amount,
    Expression<String>? status,
    Expression<bool>? includedInPlan,
    Expression<String>? person,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (amount != null) 'amount': amount,
      if (status != null) 'status': status,
      if (includedInPlan != null) 'included_in_plan': includedInPlan,
      if (person != null) 'person': person,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MonthlyExtrasCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<double>? amount,
      Value<String>? status,
      Value<bool>? includedInPlan,
      Value<String?>? person,
      Value<String?>? notes,
      Value<int>? rowid}) {
    return MonthlyExtrasCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      includedInPlan: includedInPlan ?? this.includedInPlan,
      person: person ?? this.person,
      notes: notes ?? this.notes,
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
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (includedInPlan.present) {
      map['included_in_plan'] = Variable<bool>(includedInPlan.value);
    }
    if (person.present) {
      map['person'] = Variable<String>(person.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MonthlyExtrasCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('status: $status, ')
          ..write('includedInPlan: $includedInPlan, ')
          ..write('person: $person, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SurplusPlansTable extends SurplusPlans
    with TableInfo<$SurplusPlansTable, SurplusPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SurplusPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _manualSafetyNetMeta =
      const VerificationMeta('manualSafetyNet');
  @override
  late final GeneratedColumn<double> manualSafetyNet = GeneratedColumn<double>(
      'manual_safety_net', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _manualInvestmentMeta =
      const VerificationMeta('manualInvestment');
  @override
  late final GeneratedColumn<double> manualInvestment = GeneratedColumn<double>(
      'manual_investment', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _manualFreeUseMeta =
      const VerificationMeta('manualFreeUse');
  @override
  late final GeneratedColumn<double> manualFreeUse = GeneratedColumn<double>(
      'manual_free_use', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, type, manualSafetyNet, manualInvestment, manualFreeUse];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'surplus_plans';
  @override
  VerificationContext validateIntegrity(Insertable<SurplusPlan> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('manual_safety_net')) {
      context.handle(
          _manualSafetyNetMeta,
          manualSafetyNet.isAcceptableOrUnknown(
              data['manual_safety_net']!, _manualSafetyNetMeta));
    }
    if (data.containsKey('manual_investment')) {
      context.handle(
          _manualInvestmentMeta,
          manualInvestment.isAcceptableOrUnknown(
              data['manual_investment']!, _manualInvestmentMeta));
    }
    if (data.containsKey('manual_free_use')) {
      context.handle(
          _manualFreeUseMeta,
          manualFreeUse.isAcceptableOrUnknown(
              data['manual_free_use']!, _manualFreeUseMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SurplusPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SurplusPlan(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      manualSafetyNet: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}manual_safety_net']),
      manualInvestment: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}manual_investment']),
      manualFreeUse: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}manual_free_use']),
    );
  }

  @override
  $SurplusPlansTable createAlias(String alias) {
    return $SurplusPlansTable(attachedDatabase, alias);
  }
}

class SurplusPlan extends DataClass implements Insertable<SurplusPlan> {
  final String id;
  final String type;
  final double? manualSafetyNet;
  final double? manualInvestment;
  final double? manualFreeUse;
  const SurplusPlan(
      {required this.id,
      required this.type,
      this.manualSafetyNet,
      this.manualInvestment,
      this.manualFreeUse});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || manualSafetyNet != null) {
      map['manual_safety_net'] = Variable<double>(manualSafetyNet);
    }
    if (!nullToAbsent || manualInvestment != null) {
      map['manual_investment'] = Variable<double>(manualInvestment);
    }
    if (!nullToAbsent || manualFreeUse != null) {
      map['manual_free_use'] = Variable<double>(manualFreeUse);
    }
    return map;
  }

  SurplusPlansCompanion toCompanion(bool nullToAbsent) {
    return SurplusPlansCompanion(
      id: Value(id),
      type: Value(type),
      manualSafetyNet: manualSafetyNet == null && nullToAbsent
          ? const Value.absent()
          : Value(manualSafetyNet),
      manualInvestment: manualInvestment == null && nullToAbsent
          ? const Value.absent()
          : Value(manualInvestment),
      manualFreeUse: manualFreeUse == null && nullToAbsent
          ? const Value.absent()
          : Value(manualFreeUse),
    );
  }

  factory SurplusPlan.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SurplusPlan(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      manualSafetyNet: serializer.fromJson<double?>(json['manualSafetyNet']),
      manualInvestment: serializer.fromJson<double?>(json['manualInvestment']),
      manualFreeUse: serializer.fromJson<double?>(json['manualFreeUse']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'manualSafetyNet': serializer.toJson<double?>(manualSafetyNet),
      'manualInvestment': serializer.toJson<double?>(manualInvestment),
      'manualFreeUse': serializer.toJson<double?>(manualFreeUse),
    };
  }

  SurplusPlan copyWith(
          {String? id,
          String? type,
          Value<double?> manualSafetyNet = const Value.absent(),
          Value<double?> manualInvestment = const Value.absent(),
          Value<double?> manualFreeUse = const Value.absent()}) =>
      SurplusPlan(
        id: id ?? this.id,
        type: type ?? this.type,
        manualSafetyNet: manualSafetyNet.present
            ? manualSafetyNet.value
            : this.manualSafetyNet,
        manualInvestment: manualInvestment.present
            ? manualInvestment.value
            : this.manualInvestment,
        manualFreeUse:
            manualFreeUse.present ? manualFreeUse.value : this.manualFreeUse,
      );
  SurplusPlan copyWithCompanion(SurplusPlansCompanion data) {
    return SurplusPlan(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      manualSafetyNet: data.manualSafetyNet.present
          ? data.manualSafetyNet.value
          : this.manualSafetyNet,
      manualInvestment: data.manualInvestment.present
          ? data.manualInvestment.value
          : this.manualInvestment,
      manualFreeUse: data.manualFreeUse.present
          ? data.manualFreeUse.value
          : this.manualFreeUse,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SurplusPlan(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('manualSafetyNet: $manualSafetyNet, ')
          ..write('manualInvestment: $manualInvestment, ')
          ..write('manualFreeUse: $manualFreeUse')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, type, manualSafetyNet, manualInvestment, manualFreeUse);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SurplusPlan &&
          other.id == this.id &&
          other.type == this.type &&
          other.manualSafetyNet == this.manualSafetyNet &&
          other.manualInvestment == this.manualInvestment &&
          other.manualFreeUse == this.manualFreeUse);
}

class SurplusPlansCompanion extends UpdateCompanion<SurplusPlan> {
  final Value<String> id;
  final Value<String> type;
  final Value<double?> manualSafetyNet;
  final Value<double?> manualInvestment;
  final Value<double?> manualFreeUse;
  final Value<int> rowid;
  const SurplusPlansCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.manualSafetyNet = const Value.absent(),
    this.manualInvestment = const Value.absent(),
    this.manualFreeUse = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SurplusPlansCompanion.insert({
    required String id,
    required String type,
    this.manualSafetyNet = const Value.absent(),
    this.manualInvestment = const Value.absent(),
    this.manualFreeUse = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        type = Value(type);
  static Insertable<SurplusPlan> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<double>? manualSafetyNet,
    Expression<double>? manualInvestment,
    Expression<double>? manualFreeUse,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (manualSafetyNet != null) 'manual_safety_net': manualSafetyNet,
      if (manualInvestment != null) 'manual_investment': manualInvestment,
      if (manualFreeUse != null) 'manual_free_use': manualFreeUse,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SurplusPlansCompanion copyWith(
      {Value<String>? id,
      Value<String>? type,
      Value<double?>? manualSafetyNet,
      Value<double?>? manualInvestment,
      Value<double?>? manualFreeUse,
      Value<int>? rowid}) {
    return SurplusPlansCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      manualSafetyNet: manualSafetyNet ?? this.manualSafetyNet,
      manualInvestment: manualInvestment ?? this.manualInvestment,
      manualFreeUse: manualFreeUse ?? this.manualFreeUse,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (manualSafetyNet.present) {
      map['manual_safety_net'] = Variable<double>(manualSafetyNet.value);
    }
    if (manualInvestment.present) {
      map['manual_investment'] = Variable<double>(manualInvestment.value);
    }
    if (manualFreeUse.present) {
      map['manual_free_use'] = Variable<double>(manualFreeUse.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SurplusPlansCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('manualSafetyNet: $manualSafetyNet, ')
          ..write('manualInvestment: $manualInvestment, ')
          ..write('manualFreeUse: $manualFreeUse, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FinancialTasksTable extends FinancialTasks
    with TableInfo<$FinancialTasksTable, FinancialTask> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FinancialTasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _actualAmountMeta =
      const VerificationMeta('actualAmount');
  @override
  late final GeneratedColumn<double> actualAmount = GeneratedColumn<double>(
      'actual_amount', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
      'due_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _sourceIdMeta =
      const VerificationMeta('sourceId');
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
      'source_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sourceTypeMeta =
      const VerificationMeta('sourceType');
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
      'source_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        amount,
        type,
        status,
        createdAt,
        actualAmount,
        dueDate,
        sourceId,
        sourceType,
        notes,
        completedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'financial_tasks';
  @override
  VerificationContext validateIntegrity(Insertable<FinancialTask> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('actual_amount')) {
      context.handle(
          _actualAmountMeta,
          actualAmount.isAcceptableOrUnknown(
              data['actual_amount']!, _actualAmountMeta));
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    }
    if (data.containsKey('source_id')) {
      context.handle(_sourceIdMeta,
          sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta));
    }
    if (data.containsKey('source_type')) {
      context.handle(
          _sourceTypeMeta,
          sourceType.isAcceptableOrUnknown(
              data['source_type']!, _sourceTypeMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FinancialTask map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FinancialTask(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      actualAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}actual_amount']),
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_date']),
      sourceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_id']),
      sourceType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_type']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
    );
  }

  @override
  $FinancialTasksTable createAlias(String alias) {
    return $FinancialTasksTable(attachedDatabase, alias);
  }
}

class FinancialTask extends DataClass implements Insertable<FinancialTask> {
  final String id;
  final String title;
  final double amount;
  final String type;
  final String status;
  final DateTime createdAt;
  final double? actualAmount;
  final DateTime? dueDate;
  final String? sourceId;
  final String? sourceType;
  final String? notes;
  final DateTime? completedAt;
  const FinancialTask(
      {required this.id,
      required this.title,
      required this.amount,
      required this.type,
      required this.status,
      required this.createdAt,
      this.actualAmount,
      this.dueDate,
      this.sourceId,
      this.sourceType,
      this.notes,
      this.completedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['amount'] = Variable<double>(amount);
    map['type'] = Variable<String>(type);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || actualAmount != null) {
      map['actual_amount'] = Variable<double>(actualAmount);
    }
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    if (!nullToAbsent || sourceId != null) {
      map['source_id'] = Variable<String>(sourceId);
    }
    if (!nullToAbsent || sourceType != null) {
      map['source_type'] = Variable<String>(sourceType);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  FinancialTasksCompanion toCompanion(bool nullToAbsent) {
    return FinancialTasksCompanion(
      id: Value(id),
      title: Value(title),
      amount: Value(amount),
      type: Value(type),
      status: Value(status),
      createdAt: Value(createdAt),
      actualAmount: actualAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(actualAmount),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      sourceId: sourceId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceId),
      sourceType: sourceType == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceType),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory FinancialTask.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FinancialTask(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      amount: serializer.fromJson<double>(json['amount']),
      type: serializer.fromJson<String>(json['type']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      actualAmount: serializer.fromJson<double?>(json['actualAmount']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      sourceId: serializer.fromJson<String?>(json['sourceId']),
      sourceType: serializer.fromJson<String?>(json['sourceType']),
      notes: serializer.fromJson<String?>(json['notes']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'amount': serializer.toJson<double>(amount),
      'type': serializer.toJson<String>(type),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'actualAmount': serializer.toJson<double?>(actualAmount),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'sourceId': serializer.toJson<String?>(sourceId),
      'sourceType': serializer.toJson<String?>(sourceType),
      'notes': serializer.toJson<String?>(notes),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  FinancialTask copyWith(
          {String? id,
          String? title,
          double? amount,
          String? type,
          String? status,
          DateTime? createdAt,
          Value<double?> actualAmount = const Value.absent(),
          Value<DateTime?> dueDate = const Value.absent(),
          Value<String?> sourceId = const Value.absent(),
          Value<String?> sourceType = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          Value<DateTime?> completedAt = const Value.absent()}) =>
      FinancialTask(
        id: id ?? this.id,
        title: title ?? this.title,
        amount: amount ?? this.amount,
        type: type ?? this.type,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        actualAmount:
            actualAmount.present ? actualAmount.value : this.actualAmount,
        dueDate: dueDate.present ? dueDate.value : this.dueDate,
        sourceId: sourceId.present ? sourceId.value : this.sourceId,
        sourceType: sourceType.present ? sourceType.value : this.sourceType,
        notes: notes.present ? notes.value : this.notes,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
      );
  FinancialTask copyWithCompanion(FinancialTasksCompanion data) {
    return FinancialTask(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      amount: data.amount.present ? data.amount.value : this.amount,
      type: data.type.present ? data.type.value : this.type,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      actualAmount: data.actualAmount.present
          ? data.actualAmount.value
          : this.actualAmount,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      sourceType:
          data.sourceType.present ? data.sourceType.value : this.sourceType,
      notes: data.notes.present ? data.notes.value : this.notes,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FinancialTask(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('actualAmount: $actualAmount, ')
          ..write('dueDate: $dueDate, ')
          ..write('sourceId: $sourceId, ')
          ..write('sourceType: $sourceType, ')
          ..write('notes: $notes, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, amount, type, status, createdAt,
      actualAmount, dueDate, sourceId, sourceType, notes, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FinancialTask &&
          other.id == this.id &&
          other.title == this.title &&
          other.amount == this.amount &&
          other.type == this.type &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.actualAmount == this.actualAmount &&
          other.dueDate == this.dueDate &&
          other.sourceId == this.sourceId &&
          other.sourceType == this.sourceType &&
          other.notes == this.notes &&
          other.completedAt == this.completedAt);
}

class FinancialTasksCompanion extends UpdateCompanion<FinancialTask> {
  final Value<String> id;
  final Value<String> title;
  final Value<double> amount;
  final Value<String> type;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<double?> actualAmount;
  final Value<DateTime?> dueDate;
  final Value<String?> sourceId;
  final Value<String?> sourceType;
  final Value<String?> notes;
  final Value<DateTime?> completedAt;
  final Value<int> rowid;
  const FinancialTasksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.amount = const Value.absent(),
    this.type = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.actualAmount = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.notes = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FinancialTasksCompanion.insert({
    required String id,
    required String title,
    required double amount,
    required String type,
    required String status,
    required DateTime createdAt,
    this.actualAmount = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.notes = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        amount = Value(amount),
        type = Value(type),
        status = Value(status),
        createdAt = Value(createdAt);
  static Insertable<FinancialTask> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<double>? amount,
    Expression<String>? type,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<double>? actualAmount,
    Expression<DateTime>? dueDate,
    Expression<String>? sourceId,
    Expression<String>? sourceType,
    Expression<String>? notes,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (amount != null) 'amount': amount,
      if (type != null) 'type': type,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (actualAmount != null) 'actual_amount': actualAmount,
      if (dueDate != null) 'due_date': dueDate,
      if (sourceId != null) 'source_id': sourceId,
      if (sourceType != null) 'source_type': sourceType,
      if (notes != null) 'notes': notes,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FinancialTasksCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<double>? amount,
      Value<String>? type,
      Value<String>? status,
      Value<DateTime>? createdAt,
      Value<double?>? actualAmount,
      Value<DateTime?>? dueDate,
      Value<String?>? sourceId,
      Value<String?>? sourceType,
      Value<String?>? notes,
      Value<DateTime?>? completedAt,
      Value<int>? rowid}) {
    return FinancialTasksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      actualAmount: actualAmount ?? this.actualAmount,
      dueDate: dueDate ?? this.dueDate,
      sourceId: sourceId ?? this.sourceId,
      sourceType: sourceType ?? this.sourceType,
      notes: notes ?? this.notes,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (actualAmount.present) {
      map['actual_amount'] = Variable<double>(actualAmount.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
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
    return (StringBuffer('FinancialTasksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('actualAmount: $actualAmount, ')
          ..write('dueDate: $dueDate, ')
          ..write('sourceId: $sourceId, ')
          ..write('sourceType: $sourceType, ')
          ..write('notes: $notes, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FinancialTaskOverridesTable extends FinancialTaskOverrides
    with TableInfo<$FinancialTaskOverridesTable, FinancialTaskOverride> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FinancialTaskOverridesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
      'task_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _actualAmountMeta =
      const VerificationMeta('actualAmount');
  @override
  late final GeneratedColumn<double> actualAmount = GeneratedColumn<double>(
      'actual_amount', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
      'due_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        taskId,
        title,
        amount,
        status,
        actualAmount,
        dueDate,
        notes,
        completedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'financial_task_overrides';
  @override
  VerificationContext validateIntegrity(
      Insertable<FinancialTaskOverride> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('task_id')) {
      context.handle(_taskIdMeta,
          taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta));
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('actual_amount')) {
      context.handle(
          _actualAmountMeta,
          actualAmount.isAcceptableOrUnknown(
              data['actual_amount']!, _actualAmountMeta));
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {taskId};
  @override
  FinancialTaskOverride map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FinancialTaskOverride(
      taskId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}task_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title']),
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status']),
      actualAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}actual_amount']),
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_date']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
    );
  }

  @override
  $FinancialTaskOverridesTable createAlias(String alias) {
    return $FinancialTaskOverridesTable(attachedDatabase, alias);
  }
}

class FinancialTaskOverride extends DataClass
    implements Insertable<FinancialTaskOverride> {
  final String taskId;
  final String? title;
  final double? amount;
  final String? status;
  final double? actualAmount;
  final DateTime? dueDate;
  final String? notes;
  final DateTime? completedAt;
  const FinancialTaskOverride(
      {required this.taskId,
      this.title,
      this.amount,
      this.status,
      this.actualAmount,
      this.dueDate,
      this.notes,
      this.completedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['task_id'] = Variable<String>(taskId);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || amount != null) {
      map['amount'] = Variable<double>(amount);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || actualAmount != null) {
      map['actual_amount'] = Variable<double>(actualAmount);
    }
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  FinancialTaskOverridesCompanion toCompanion(bool nullToAbsent) {
    return FinancialTaskOverridesCompanion(
      taskId: Value(taskId),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      amount:
          amount == null && nullToAbsent ? const Value.absent() : Value(amount),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      actualAmount: actualAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(actualAmount),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory FinancialTaskOverride.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FinancialTaskOverride(
      taskId: serializer.fromJson<String>(json['taskId']),
      title: serializer.fromJson<String?>(json['title']),
      amount: serializer.fromJson<double?>(json['amount']),
      status: serializer.fromJson<String?>(json['status']),
      actualAmount: serializer.fromJson<double?>(json['actualAmount']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'taskId': serializer.toJson<String>(taskId),
      'title': serializer.toJson<String?>(title),
      'amount': serializer.toJson<double?>(amount),
      'status': serializer.toJson<String?>(status),
      'actualAmount': serializer.toJson<double?>(actualAmount),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'notes': serializer.toJson<String?>(notes),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  FinancialTaskOverride copyWith(
          {String? taskId,
          Value<String?> title = const Value.absent(),
          Value<double?> amount = const Value.absent(),
          Value<String?> status = const Value.absent(),
          Value<double?> actualAmount = const Value.absent(),
          Value<DateTime?> dueDate = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          Value<DateTime?> completedAt = const Value.absent()}) =>
      FinancialTaskOverride(
        taskId: taskId ?? this.taskId,
        title: title.present ? title.value : this.title,
        amount: amount.present ? amount.value : this.amount,
        status: status.present ? status.value : this.status,
        actualAmount:
            actualAmount.present ? actualAmount.value : this.actualAmount,
        dueDate: dueDate.present ? dueDate.value : this.dueDate,
        notes: notes.present ? notes.value : this.notes,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
      );
  FinancialTaskOverride copyWithCompanion(
      FinancialTaskOverridesCompanion data) {
    return FinancialTaskOverride(
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      title: data.title.present ? data.title.value : this.title,
      amount: data.amount.present ? data.amount.value : this.amount,
      status: data.status.present ? data.status.value : this.status,
      actualAmount: data.actualAmount.present
          ? data.actualAmount.value
          : this.actualAmount,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FinancialTaskOverride(')
          ..write('taskId: $taskId, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('status: $status, ')
          ..write('actualAmount: $actualAmount, ')
          ..write('dueDate: $dueDate, ')
          ..write('notes: $notes, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      taskId, title, amount, status, actualAmount, dueDate, notes, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FinancialTaskOverride &&
          other.taskId == this.taskId &&
          other.title == this.title &&
          other.amount == this.amount &&
          other.status == this.status &&
          other.actualAmount == this.actualAmount &&
          other.dueDate == this.dueDate &&
          other.notes == this.notes &&
          other.completedAt == this.completedAt);
}

class FinancialTaskOverridesCompanion
    extends UpdateCompanion<FinancialTaskOverride> {
  final Value<String> taskId;
  final Value<String?> title;
  final Value<double?> amount;
  final Value<String?> status;
  final Value<double?> actualAmount;
  final Value<DateTime?> dueDate;
  final Value<String?> notes;
  final Value<DateTime?> completedAt;
  final Value<int> rowid;
  const FinancialTaskOverridesCompanion({
    this.taskId = const Value.absent(),
    this.title = const Value.absent(),
    this.amount = const Value.absent(),
    this.status = const Value.absent(),
    this.actualAmount = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FinancialTaskOverridesCompanion.insert({
    required String taskId,
    this.title = const Value.absent(),
    this.amount = const Value.absent(),
    this.status = const Value.absent(),
    this.actualAmount = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : taskId = Value(taskId);
  static Insertable<FinancialTaskOverride> custom({
    Expression<String>? taskId,
    Expression<String>? title,
    Expression<double>? amount,
    Expression<String>? status,
    Expression<double>? actualAmount,
    Expression<DateTime>? dueDate,
    Expression<String>? notes,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (taskId != null) 'task_id': taskId,
      if (title != null) 'title': title,
      if (amount != null) 'amount': amount,
      if (status != null) 'status': status,
      if (actualAmount != null) 'actual_amount': actualAmount,
      if (dueDate != null) 'due_date': dueDate,
      if (notes != null) 'notes': notes,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FinancialTaskOverridesCompanion copyWith(
      {Value<String>? taskId,
      Value<String?>? title,
      Value<double?>? amount,
      Value<String?>? status,
      Value<double?>? actualAmount,
      Value<DateTime?>? dueDate,
      Value<String?>? notes,
      Value<DateTime?>? completedAt,
      Value<int>? rowid}) {
    return FinancialTaskOverridesCompanion(
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      actualAmount: actualAmount ?? this.actualAmount,
      dueDate: dueDate ?? this.dueDate,
      notes: notes ?? this.notes,
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
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (actualAmount.present) {
      map['actual_amount'] = Variable<double>(actualAmount.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
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
    return (StringBuffer('FinancialTaskOverridesCompanion(')
          ..write('taskId: $taskId, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('status: $status, ')
          ..write('actualAmount: $actualAmount, ')
          ..write('dueDate: $dueDate, ')
          ..write('notes: $notes, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $BudgetCategoriesTable budgetCategories =
      $BudgetCategoriesTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $PlannedExpensesTable plannedExpenses =
      $PlannedExpensesTable(this);
  late final $CreditCardsTable creditCards = $CreditCardsTable(this);
  late final $CreditCardPurchasesTable creditCardPurchases =
      $CreditCardPurchasesTable(this);
  late final $SubscriptionsTable subscriptions = $SubscriptionsTable(this);
  late final $CreditCardMonthlyPaymentsTable creditCardMonthlyPayments =
      $CreditCardMonthlyPaymentsTable(this);
  late final $MonthlyExtrasTable monthlyExtras = $MonthlyExtrasTable(this);
  late final $SurplusPlansTable surplusPlans = $SurplusPlansTable(this);
  late final $FinancialTasksTable financialTasks = $FinancialTasksTable(this);
  late final $FinancialTaskOverridesTable financialTaskOverrides =
      $FinancialTaskOverridesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        appSettings,
        budgetCategories,
        transactions,
        plannedExpenses,
        creditCards,
        creditCardPurchases,
        subscriptions,
        creditCardMonthlyPayments,
        monthlyExtras,
        surplusPlans,
        financialTasks,
        financialTaskOverrides
      ];
}

typedef $$AppSettingsTableCreateCompanionBuilder = AppSettingsCompanion
    Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$AppSettingsTableUpdateCompanionBuilder = AppSettingsCompanion
    Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSetting,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (AppSetting, BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>),
    AppSetting,
    PrefetchHooks Function()> {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsCompanion(
            key: key,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsCompanion.insert(
            key: key,
            value: value,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppSettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSetting,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (AppSetting, BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>),
    AppSetting,
    PrefetchHooks Function()>;
typedef $$BudgetCategoriesTableCreateCompanionBuilder
    = BudgetCategoriesCompanion Function({
  required String id,
  required String title,
  required double limit,
  required double spent,
  required int colorValue,
  Value<int> rowid,
});
typedef $$BudgetCategoriesTableUpdateCompanionBuilder
    = BudgetCategoriesCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<double> limit,
  Value<double> spent,
  Value<int> colorValue,
  Value<int> rowid,
});

class $$BudgetCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetCategoriesTable> {
  $$BudgetCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get limit => $composableBuilder(
      column: $table.limit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get spent => $composableBuilder(
      column: $table.spent, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => ColumnFilters(column));
}

class $$BudgetCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetCategoriesTable> {
  $$BudgetCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get limit => $composableBuilder(
      column: $table.limit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get spent => $composableBuilder(
      column: $table.spent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => ColumnOrderings(column));
}

class $$BudgetCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetCategoriesTable> {
  $$BudgetCategoriesTableAnnotationComposer({
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

  GeneratedColumn<double> get limit =>
      $composableBuilder(column: $table.limit, builder: (column) => column);

  GeneratedColumn<double> get spent =>
      $composableBuilder(column: $table.spent, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => column);
}

class $$BudgetCategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BudgetCategoriesTable,
    BudgetCategory,
    $$BudgetCategoriesTableFilterComposer,
    $$BudgetCategoriesTableOrderingComposer,
    $$BudgetCategoriesTableAnnotationComposer,
    $$BudgetCategoriesTableCreateCompanionBuilder,
    $$BudgetCategoriesTableUpdateCompanionBuilder,
    (
      BudgetCategory,
      BaseReferences<_$AppDatabase, $BudgetCategoriesTable, BudgetCategory>
    ),
    BudgetCategory,
    PrefetchHooks Function()> {
  $$BudgetCategoriesTableTableManager(
      _$AppDatabase db, $BudgetCategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<double> limit = const Value.absent(),
            Value<double> spent = const Value.absent(),
            Value<int> colorValue = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BudgetCategoriesCompanion(
            id: id,
            title: title,
            limit: limit,
            spent: spent,
            colorValue: colorValue,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required double limit,
            required double spent,
            required int colorValue,
            Value<int> rowid = const Value.absent(),
          }) =>
              BudgetCategoriesCompanion.insert(
            id: id,
            title: title,
            limit: limit,
            spent: spent,
            colorValue: colorValue,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BudgetCategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BudgetCategoriesTable,
    BudgetCategory,
    $$BudgetCategoriesTableFilterComposer,
    $$BudgetCategoriesTableOrderingComposer,
    $$BudgetCategoriesTableAnnotationComposer,
    $$BudgetCategoriesTableCreateCompanionBuilder,
    $$BudgetCategoriesTableUpdateCompanionBuilder,
    (
      BudgetCategory,
      BaseReferences<_$AppDatabase, $BudgetCategoriesTable, BudgetCategory>
    ),
    BudgetCategory,
    PrefetchHooks Function()>;
typedef $$TransactionsTableCreateCompanionBuilder = TransactionsCompanion
    Function({
  required String id,
  required String title,
  required double amount,
  required String category,
  required DateTime date,
  required String type,
  Value<int> rowid,
});
typedef $$TransactionsTableUpdateCompanionBuilder = TransactionsCompanion
    Function({
  Value<String> id,
  Value<String> title,
  Value<double> amount,
  Value<String> category,
  Value<DateTime> date,
  Value<String> type,
  Value<int> rowid,
});

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
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

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);
}

class $$TransactionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (
      Transaction,
      BaseReferences<_$AppDatabase, $TransactionsTable, Transaction>
    ),
    Transaction,
    PrefetchHooks Function()> {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsCompanion(
            id: id,
            title: title,
            amount: amount,
            category: category,
            date: date,
            type: type,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required double amount,
            required String category,
            required DateTime date,
            required String type,
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsCompanion.insert(
            id: id,
            title: title,
            amount: amount,
            category: category,
            date: date,
            type: type,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TransactionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (
      Transaction,
      BaseReferences<_$AppDatabase, $TransactionsTable, Transaction>
    ),
    Transaction,
    PrefetchHooks Function()>;
typedef $$PlannedExpensesTableCreateCompanionBuilder = PlannedExpensesCompanion
    Function({
  required String id,
  required String title,
  required double amount,
  required String group,
  required String status,
  Value<String?> paymentSource,
  Value<String?> note,
  Value<int> rowid,
});
typedef $$PlannedExpensesTableUpdateCompanionBuilder = PlannedExpensesCompanion
    Function({
  Value<String> id,
  Value<String> title,
  Value<double> amount,
  Value<String> group,
  Value<String> status,
  Value<String?> paymentSource,
  Value<String?> note,
  Value<int> rowid,
});

class $$PlannedExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $PlannedExpensesTable> {
  $$PlannedExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get group => $composableBuilder(
      column: $table.group, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentSource => $composableBuilder(
      column: $table.paymentSource, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));
}

class $$PlannedExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $PlannedExpensesTable> {
  $$PlannedExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get group => $composableBuilder(
      column: $table.group, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentSource => $composableBuilder(
      column: $table.paymentSource,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));
}

class $$PlannedExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlannedExpensesTable> {
  $$PlannedExpensesTableAnnotationComposer({
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

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get group =>
      $composableBuilder(column: $table.group, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get paymentSource => $composableBuilder(
      column: $table.paymentSource, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$PlannedExpensesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlannedExpensesTable,
    PlannedExpense,
    $$PlannedExpensesTableFilterComposer,
    $$PlannedExpensesTableOrderingComposer,
    $$PlannedExpensesTableAnnotationComposer,
    $$PlannedExpensesTableCreateCompanionBuilder,
    $$PlannedExpensesTableUpdateCompanionBuilder,
    (
      PlannedExpense,
      BaseReferences<_$AppDatabase, $PlannedExpensesTable, PlannedExpense>
    ),
    PlannedExpense,
    PrefetchHooks Function()> {
  $$PlannedExpensesTableTableManager(
      _$AppDatabase db, $PlannedExpensesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlannedExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlannedExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlannedExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> group = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> paymentSource = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlannedExpensesCompanion(
            id: id,
            title: title,
            amount: amount,
            group: group,
            status: status,
            paymentSource: paymentSource,
            note: note,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required double amount,
            required String group,
            required String status,
            Value<String?> paymentSource = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlannedExpensesCompanion.insert(
            id: id,
            title: title,
            amount: amount,
            group: group,
            status: status,
            paymentSource: paymentSource,
            note: note,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PlannedExpensesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PlannedExpensesTable,
    PlannedExpense,
    $$PlannedExpensesTableFilterComposer,
    $$PlannedExpensesTableOrderingComposer,
    $$PlannedExpensesTableAnnotationComposer,
    $$PlannedExpensesTableCreateCompanionBuilder,
    $$PlannedExpensesTableUpdateCompanionBuilder,
    (
      PlannedExpense,
      BaseReferences<_$AppDatabase, $PlannedExpensesTable, PlannedExpense>
    ),
    PlannedExpense,
    PrefetchHooks Function()>;
typedef $$CreditCardsTableCreateCompanionBuilder = CreditCardsCompanion
    Function({
  required String id,
  required String name,
  required double creditLimit,
  required double usedBalance,
  required int statementCutDay,
  Value<int> rowid,
});
typedef $$CreditCardsTableUpdateCompanionBuilder = CreditCardsCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<double> creditLimit,
  Value<double> usedBalance,
  Value<int> statementCutDay,
  Value<int> rowid,
});

class $$CreditCardsTableFilterComposer
    extends Composer<_$AppDatabase, $CreditCardsTable> {
  $$CreditCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get creditLimit => $composableBuilder(
      column: $table.creditLimit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get usedBalance => $composableBuilder(
      column: $table.usedBalance, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get statementCutDay => $composableBuilder(
      column: $table.statementCutDay,
      builder: (column) => ColumnFilters(column));
}

class $$CreditCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $CreditCardsTable> {
  $$CreditCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get creditLimit => $composableBuilder(
      column: $table.creditLimit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get usedBalance => $composableBuilder(
      column: $table.usedBalance, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get statementCutDay => $composableBuilder(
      column: $table.statementCutDay,
      builder: (column) => ColumnOrderings(column));
}

class $$CreditCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CreditCardsTable> {
  $$CreditCardsTableAnnotationComposer({
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

  GeneratedColumn<double> get creditLimit => $composableBuilder(
      column: $table.creditLimit, builder: (column) => column);

  GeneratedColumn<double> get usedBalance => $composableBuilder(
      column: $table.usedBalance, builder: (column) => column);

  GeneratedColumn<int> get statementCutDay => $composableBuilder(
      column: $table.statementCutDay, builder: (column) => column);
}

class $$CreditCardsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CreditCardsTable,
    CreditCard,
    $$CreditCardsTableFilterComposer,
    $$CreditCardsTableOrderingComposer,
    $$CreditCardsTableAnnotationComposer,
    $$CreditCardsTableCreateCompanionBuilder,
    $$CreditCardsTableUpdateCompanionBuilder,
    (CreditCard, BaseReferences<_$AppDatabase, $CreditCardsTable, CreditCard>),
    CreditCard,
    PrefetchHooks Function()> {
  $$CreditCardsTableTableManager(_$AppDatabase db, $CreditCardsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CreditCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CreditCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CreditCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> creditLimit = const Value.absent(),
            Value<double> usedBalance = const Value.absent(),
            Value<int> statementCutDay = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CreditCardsCompanion(
            id: id,
            name: name,
            creditLimit: creditLimit,
            usedBalance: usedBalance,
            statementCutDay: statementCutDay,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required double creditLimit,
            required double usedBalance,
            required int statementCutDay,
            Value<int> rowid = const Value.absent(),
          }) =>
              CreditCardsCompanion.insert(
            id: id,
            name: name,
            creditLimit: creditLimit,
            usedBalance: usedBalance,
            statementCutDay: statementCutDay,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CreditCardsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CreditCardsTable,
    CreditCard,
    $$CreditCardsTableFilterComposer,
    $$CreditCardsTableOrderingComposer,
    $$CreditCardsTableAnnotationComposer,
    $$CreditCardsTableCreateCompanionBuilder,
    $$CreditCardsTableUpdateCompanionBuilder,
    (CreditCard, BaseReferences<_$AppDatabase, $CreditCardsTable, CreditCard>),
    CreditCard,
    PrefetchHooks Function()>;
typedef $$CreditCardPurchasesTableCreateCompanionBuilder
    = CreditCardPurchasesCompanion Function({
  required String id,
  required String cardId,
  required String title,
  required double amount,
  required int installments,
  required int paidInstallments,
  Value<DateTime?> date,
  Value<String?> notes,
  Value<int> rowid,
});
typedef $$CreditCardPurchasesTableUpdateCompanionBuilder
    = CreditCardPurchasesCompanion Function({
  Value<String> id,
  Value<String> cardId,
  Value<String> title,
  Value<double> amount,
  Value<int> installments,
  Value<int> paidInstallments,
  Value<DateTime?> date,
  Value<String?> notes,
  Value<int> rowid,
});

class $$CreditCardPurchasesTableFilterComposer
    extends Composer<_$AppDatabase, $CreditCardPurchasesTable> {
  $$CreditCardPurchasesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cardId => $composableBuilder(
      column: $table.cardId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get installments => $composableBuilder(
      column: $table.installments, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get paidInstallments => $composableBuilder(
      column: $table.paidInstallments,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));
}

class $$CreditCardPurchasesTableOrderingComposer
    extends Composer<_$AppDatabase, $CreditCardPurchasesTable> {
  $$CreditCardPurchasesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cardId => $composableBuilder(
      column: $table.cardId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get installments => $composableBuilder(
      column: $table.installments,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get paidInstallments => $composableBuilder(
      column: $table.paidInstallments,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));
}

class $$CreditCardPurchasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CreditCardPurchasesTable> {
  $$CreditCardPurchasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get cardId =>
      $composableBuilder(column: $table.cardId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<int> get installments => $composableBuilder(
      column: $table.installments, builder: (column) => column);

  GeneratedColumn<int> get paidInstallments => $composableBuilder(
      column: $table.paidInstallments, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$CreditCardPurchasesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CreditCardPurchasesTable,
    CreditCardPurchase,
    $$CreditCardPurchasesTableFilterComposer,
    $$CreditCardPurchasesTableOrderingComposer,
    $$CreditCardPurchasesTableAnnotationComposer,
    $$CreditCardPurchasesTableCreateCompanionBuilder,
    $$CreditCardPurchasesTableUpdateCompanionBuilder,
    (
      CreditCardPurchase,
      BaseReferences<_$AppDatabase, $CreditCardPurchasesTable,
          CreditCardPurchase>
    ),
    CreditCardPurchase,
    PrefetchHooks Function()> {
  $$CreditCardPurchasesTableTableManager(
      _$AppDatabase db, $CreditCardPurchasesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CreditCardPurchasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CreditCardPurchasesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CreditCardPurchasesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> cardId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<int> installments = const Value.absent(),
            Value<int> paidInstallments = const Value.absent(),
            Value<DateTime?> date = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CreditCardPurchasesCompanion(
            id: id,
            cardId: cardId,
            title: title,
            amount: amount,
            installments: installments,
            paidInstallments: paidInstallments,
            date: date,
            notes: notes,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String cardId,
            required String title,
            required double amount,
            required int installments,
            required int paidInstallments,
            Value<DateTime?> date = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CreditCardPurchasesCompanion.insert(
            id: id,
            cardId: cardId,
            title: title,
            amount: amount,
            installments: installments,
            paidInstallments: paidInstallments,
            date: date,
            notes: notes,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CreditCardPurchasesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CreditCardPurchasesTable,
    CreditCardPurchase,
    $$CreditCardPurchasesTableFilterComposer,
    $$CreditCardPurchasesTableOrderingComposer,
    $$CreditCardPurchasesTableAnnotationComposer,
    $$CreditCardPurchasesTableCreateCompanionBuilder,
    $$CreditCardPurchasesTableUpdateCompanionBuilder,
    (
      CreditCardPurchase,
      BaseReferences<_$AppDatabase, $CreditCardPurchasesTable,
          CreditCardPurchase>
    ),
    CreditCardPurchase,
    PrefetchHooks Function()>;
typedef $$SubscriptionsTableCreateCompanionBuilder = SubscriptionsCompanion
    Function({
  required String id,
  required String name,
  required double amount,
  required String cardId,
  Value<int> rowid,
});
typedef $$SubscriptionsTableUpdateCompanionBuilder = SubscriptionsCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<double> amount,
  Value<String> cardId,
  Value<int> rowid,
});

class $$SubscriptionsTableFilterComposer
    extends Composer<_$AppDatabase, $SubscriptionsTable> {
  $$SubscriptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cardId => $composableBuilder(
      column: $table.cardId, builder: (column) => ColumnFilters(column));
}

class $$SubscriptionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubscriptionsTable> {
  $$SubscriptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cardId => $composableBuilder(
      column: $table.cardId, builder: (column) => ColumnOrderings(column));
}

class $$SubscriptionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubscriptionsTable> {
  $$SubscriptionsTableAnnotationComposer({
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

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get cardId =>
      $composableBuilder(column: $table.cardId, builder: (column) => column);
}

class $$SubscriptionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SubscriptionsTable,
    Subscription,
    $$SubscriptionsTableFilterComposer,
    $$SubscriptionsTableOrderingComposer,
    $$SubscriptionsTableAnnotationComposer,
    $$SubscriptionsTableCreateCompanionBuilder,
    $$SubscriptionsTableUpdateCompanionBuilder,
    (
      Subscription,
      BaseReferences<_$AppDatabase, $SubscriptionsTable, Subscription>
    ),
    Subscription,
    PrefetchHooks Function()> {
  $$SubscriptionsTableTableManager(_$AppDatabase db, $SubscriptionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubscriptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubscriptionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubscriptionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> cardId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SubscriptionsCompanion(
            id: id,
            name: name,
            amount: amount,
            cardId: cardId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required double amount,
            required String cardId,
            Value<int> rowid = const Value.absent(),
          }) =>
              SubscriptionsCompanion.insert(
            id: id,
            name: name,
            amount: amount,
            cardId: cardId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SubscriptionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SubscriptionsTable,
    Subscription,
    $$SubscriptionsTableFilterComposer,
    $$SubscriptionsTableOrderingComposer,
    $$SubscriptionsTableAnnotationComposer,
    $$SubscriptionsTableCreateCompanionBuilder,
    $$SubscriptionsTableUpdateCompanionBuilder,
    (
      Subscription,
      BaseReferences<_$AppDatabase, $SubscriptionsTable, Subscription>
    ),
    Subscription,
    PrefetchHooks Function()>;
typedef $$CreditCardMonthlyPaymentsTableCreateCompanionBuilder
    = CreditCardMonthlyPaymentsCompanion Function({
  required String cardId,
  Value<double?> manualAmount,
  Value<double?> confirmedAmount,
  Value<int> rowid,
});
typedef $$CreditCardMonthlyPaymentsTableUpdateCompanionBuilder
    = CreditCardMonthlyPaymentsCompanion Function({
  Value<String> cardId,
  Value<double?> manualAmount,
  Value<double?> confirmedAmount,
  Value<int> rowid,
});

class $$CreditCardMonthlyPaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $CreditCardMonthlyPaymentsTable> {
  $$CreditCardMonthlyPaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get cardId => $composableBuilder(
      column: $table.cardId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get manualAmount => $composableBuilder(
      column: $table.manualAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get confirmedAmount => $composableBuilder(
      column: $table.confirmedAmount,
      builder: (column) => ColumnFilters(column));
}

class $$CreditCardMonthlyPaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $CreditCardMonthlyPaymentsTable> {
  $$CreditCardMonthlyPaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get cardId => $composableBuilder(
      column: $table.cardId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get manualAmount => $composableBuilder(
      column: $table.manualAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get confirmedAmount => $composableBuilder(
      column: $table.confirmedAmount,
      builder: (column) => ColumnOrderings(column));
}

class $$CreditCardMonthlyPaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CreditCardMonthlyPaymentsTable> {
  $$CreditCardMonthlyPaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get cardId =>
      $composableBuilder(column: $table.cardId, builder: (column) => column);

  GeneratedColumn<double> get manualAmount => $composableBuilder(
      column: $table.manualAmount, builder: (column) => column);

  GeneratedColumn<double> get confirmedAmount => $composableBuilder(
      column: $table.confirmedAmount, builder: (column) => column);
}

class $$CreditCardMonthlyPaymentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CreditCardMonthlyPaymentsTable,
    CreditCardMonthlyPayment,
    $$CreditCardMonthlyPaymentsTableFilterComposer,
    $$CreditCardMonthlyPaymentsTableOrderingComposer,
    $$CreditCardMonthlyPaymentsTableAnnotationComposer,
    $$CreditCardMonthlyPaymentsTableCreateCompanionBuilder,
    $$CreditCardMonthlyPaymentsTableUpdateCompanionBuilder,
    (
      CreditCardMonthlyPayment,
      BaseReferences<_$AppDatabase, $CreditCardMonthlyPaymentsTable,
          CreditCardMonthlyPayment>
    ),
    CreditCardMonthlyPayment,
    PrefetchHooks Function()> {
  $$CreditCardMonthlyPaymentsTableTableManager(
      _$AppDatabase db, $CreditCardMonthlyPaymentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CreditCardMonthlyPaymentsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$CreditCardMonthlyPaymentsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CreditCardMonthlyPaymentsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> cardId = const Value.absent(),
            Value<double?> manualAmount = const Value.absent(),
            Value<double?> confirmedAmount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CreditCardMonthlyPaymentsCompanion(
            cardId: cardId,
            manualAmount: manualAmount,
            confirmedAmount: confirmedAmount,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String cardId,
            Value<double?> manualAmount = const Value.absent(),
            Value<double?> confirmedAmount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CreditCardMonthlyPaymentsCompanion.insert(
            cardId: cardId,
            manualAmount: manualAmount,
            confirmedAmount: confirmedAmount,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CreditCardMonthlyPaymentsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $CreditCardMonthlyPaymentsTable,
        CreditCardMonthlyPayment,
        $$CreditCardMonthlyPaymentsTableFilterComposer,
        $$CreditCardMonthlyPaymentsTableOrderingComposer,
        $$CreditCardMonthlyPaymentsTableAnnotationComposer,
        $$CreditCardMonthlyPaymentsTableCreateCompanionBuilder,
        $$CreditCardMonthlyPaymentsTableUpdateCompanionBuilder,
        (
          CreditCardMonthlyPayment,
          BaseReferences<_$AppDatabase, $CreditCardMonthlyPaymentsTable,
              CreditCardMonthlyPayment>
        ),
        CreditCardMonthlyPayment,
        PrefetchHooks Function()>;
typedef $$MonthlyExtrasTableCreateCompanionBuilder = MonthlyExtrasCompanion
    Function({
  required String id,
  required String name,
  required double amount,
  required String status,
  required bool includedInPlan,
  Value<String?> person,
  Value<String?> notes,
  Value<int> rowid,
});
typedef $$MonthlyExtrasTableUpdateCompanionBuilder = MonthlyExtrasCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<double> amount,
  Value<String> status,
  Value<bool> includedInPlan,
  Value<String?> person,
  Value<String?> notes,
  Value<int> rowid,
});

class $$MonthlyExtrasTableFilterComposer
    extends Composer<_$AppDatabase, $MonthlyExtrasTable> {
  $$MonthlyExtrasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get includedInPlan => $composableBuilder(
      column: $table.includedInPlan,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get person => $composableBuilder(
      column: $table.person, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));
}

class $$MonthlyExtrasTableOrderingComposer
    extends Composer<_$AppDatabase, $MonthlyExtrasTable> {
  $$MonthlyExtrasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get includedInPlan => $composableBuilder(
      column: $table.includedInPlan,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get person => $composableBuilder(
      column: $table.person, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));
}

class $$MonthlyExtrasTableAnnotationComposer
    extends Composer<_$AppDatabase, $MonthlyExtrasTable> {
  $$MonthlyExtrasTableAnnotationComposer({
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

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get includedInPlan => $composableBuilder(
      column: $table.includedInPlan, builder: (column) => column);

  GeneratedColumn<String> get person =>
      $composableBuilder(column: $table.person, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$MonthlyExtrasTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MonthlyExtrasTable,
    MonthlyExtra,
    $$MonthlyExtrasTableFilterComposer,
    $$MonthlyExtrasTableOrderingComposer,
    $$MonthlyExtrasTableAnnotationComposer,
    $$MonthlyExtrasTableCreateCompanionBuilder,
    $$MonthlyExtrasTableUpdateCompanionBuilder,
    (
      MonthlyExtra,
      BaseReferences<_$AppDatabase, $MonthlyExtrasTable, MonthlyExtra>
    ),
    MonthlyExtra,
    PrefetchHooks Function()> {
  $$MonthlyExtrasTableTableManager(_$AppDatabase db, $MonthlyExtrasTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MonthlyExtrasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MonthlyExtrasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MonthlyExtrasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<bool> includedInPlan = const Value.absent(),
            Value<String?> person = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MonthlyExtrasCompanion(
            id: id,
            name: name,
            amount: amount,
            status: status,
            includedInPlan: includedInPlan,
            person: person,
            notes: notes,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required double amount,
            required String status,
            required bool includedInPlan,
            Value<String?> person = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MonthlyExtrasCompanion.insert(
            id: id,
            name: name,
            amount: amount,
            status: status,
            includedInPlan: includedInPlan,
            person: person,
            notes: notes,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MonthlyExtrasTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MonthlyExtrasTable,
    MonthlyExtra,
    $$MonthlyExtrasTableFilterComposer,
    $$MonthlyExtrasTableOrderingComposer,
    $$MonthlyExtrasTableAnnotationComposer,
    $$MonthlyExtrasTableCreateCompanionBuilder,
    $$MonthlyExtrasTableUpdateCompanionBuilder,
    (
      MonthlyExtra,
      BaseReferences<_$AppDatabase, $MonthlyExtrasTable, MonthlyExtra>
    ),
    MonthlyExtra,
    PrefetchHooks Function()>;
typedef $$SurplusPlansTableCreateCompanionBuilder = SurplusPlansCompanion
    Function({
  required String id,
  required String type,
  Value<double?> manualSafetyNet,
  Value<double?> manualInvestment,
  Value<double?> manualFreeUse,
  Value<int> rowid,
});
typedef $$SurplusPlansTableUpdateCompanionBuilder = SurplusPlansCompanion
    Function({
  Value<String> id,
  Value<String> type,
  Value<double?> manualSafetyNet,
  Value<double?> manualInvestment,
  Value<double?> manualFreeUse,
  Value<int> rowid,
});

class $$SurplusPlansTableFilterComposer
    extends Composer<_$AppDatabase, $SurplusPlansTable> {
  $$SurplusPlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get manualSafetyNet => $composableBuilder(
      column: $table.manualSafetyNet,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get manualInvestment => $composableBuilder(
      column: $table.manualInvestment,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get manualFreeUse => $composableBuilder(
      column: $table.manualFreeUse, builder: (column) => ColumnFilters(column));
}

class $$SurplusPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $SurplusPlansTable> {
  $$SurplusPlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get manualSafetyNet => $composableBuilder(
      column: $table.manualSafetyNet,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get manualInvestment => $composableBuilder(
      column: $table.manualInvestment,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get manualFreeUse => $composableBuilder(
      column: $table.manualFreeUse,
      builder: (column) => ColumnOrderings(column));
}

class $$SurplusPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $SurplusPlansTable> {
  $$SurplusPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get manualSafetyNet => $composableBuilder(
      column: $table.manualSafetyNet, builder: (column) => column);

  GeneratedColumn<double> get manualInvestment => $composableBuilder(
      column: $table.manualInvestment, builder: (column) => column);

  GeneratedColumn<double> get manualFreeUse => $composableBuilder(
      column: $table.manualFreeUse, builder: (column) => column);
}

class $$SurplusPlansTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SurplusPlansTable,
    SurplusPlan,
    $$SurplusPlansTableFilterComposer,
    $$SurplusPlansTableOrderingComposer,
    $$SurplusPlansTableAnnotationComposer,
    $$SurplusPlansTableCreateCompanionBuilder,
    $$SurplusPlansTableUpdateCompanionBuilder,
    (
      SurplusPlan,
      BaseReferences<_$AppDatabase, $SurplusPlansTable, SurplusPlan>
    ),
    SurplusPlan,
    PrefetchHooks Function()> {
  $$SurplusPlansTableTableManager(_$AppDatabase db, $SurplusPlansTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SurplusPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SurplusPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SurplusPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<double?> manualSafetyNet = const Value.absent(),
            Value<double?> manualInvestment = const Value.absent(),
            Value<double?> manualFreeUse = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SurplusPlansCompanion(
            id: id,
            type: type,
            manualSafetyNet: manualSafetyNet,
            manualInvestment: manualInvestment,
            manualFreeUse: manualFreeUse,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String type,
            Value<double?> manualSafetyNet = const Value.absent(),
            Value<double?> manualInvestment = const Value.absent(),
            Value<double?> manualFreeUse = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SurplusPlansCompanion.insert(
            id: id,
            type: type,
            manualSafetyNet: manualSafetyNet,
            manualInvestment: manualInvestment,
            manualFreeUse: manualFreeUse,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SurplusPlansTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SurplusPlansTable,
    SurplusPlan,
    $$SurplusPlansTableFilterComposer,
    $$SurplusPlansTableOrderingComposer,
    $$SurplusPlansTableAnnotationComposer,
    $$SurplusPlansTableCreateCompanionBuilder,
    $$SurplusPlansTableUpdateCompanionBuilder,
    (
      SurplusPlan,
      BaseReferences<_$AppDatabase, $SurplusPlansTable, SurplusPlan>
    ),
    SurplusPlan,
    PrefetchHooks Function()>;
typedef $$FinancialTasksTableCreateCompanionBuilder = FinancialTasksCompanion
    Function({
  required String id,
  required String title,
  required double amount,
  required String type,
  required String status,
  required DateTime createdAt,
  Value<double?> actualAmount,
  Value<DateTime?> dueDate,
  Value<String?> sourceId,
  Value<String?> sourceType,
  Value<String?> notes,
  Value<DateTime?> completedAt,
  Value<int> rowid,
});
typedef $$FinancialTasksTableUpdateCompanionBuilder = FinancialTasksCompanion
    Function({
  Value<String> id,
  Value<String> title,
  Value<double> amount,
  Value<String> type,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<double?> actualAmount,
  Value<DateTime?> dueDate,
  Value<String?> sourceId,
  Value<String?> sourceType,
  Value<String?> notes,
  Value<DateTime?> completedAt,
  Value<int> rowid,
});

class $$FinancialTasksTableFilterComposer
    extends Composer<_$AppDatabase, $FinancialTasksTable> {
  $$FinancialTasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get actualAmount => $composableBuilder(
      column: $table.actualAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceId => $composableBuilder(
      column: $table.sourceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceType => $composableBuilder(
      column: $table.sourceType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));
}

class $$FinancialTasksTableOrderingComposer
    extends Composer<_$AppDatabase, $FinancialTasksTable> {
  $$FinancialTasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get actualAmount => $composableBuilder(
      column: $table.actualAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceId => $composableBuilder(
      column: $table.sourceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceType => $composableBuilder(
      column: $table.sourceType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));
}

class $$FinancialTasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $FinancialTasksTable> {
  $$FinancialTasksTableAnnotationComposer({
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

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<double> get actualAmount => $composableBuilder(
      column: $table.actualAmount, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<String> get sourceType => $composableBuilder(
      column: $table.sourceType, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);
}

class $$FinancialTasksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FinancialTasksTable,
    FinancialTask,
    $$FinancialTasksTableFilterComposer,
    $$FinancialTasksTableOrderingComposer,
    $$FinancialTasksTableAnnotationComposer,
    $$FinancialTasksTableCreateCompanionBuilder,
    $$FinancialTasksTableUpdateCompanionBuilder,
    (
      FinancialTask,
      BaseReferences<_$AppDatabase, $FinancialTasksTable, FinancialTask>
    ),
    FinancialTask,
    PrefetchHooks Function()> {
  $$FinancialTasksTableTableManager(
      _$AppDatabase db, $FinancialTasksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FinancialTasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FinancialTasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FinancialTasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<double?> actualAmount = const Value.absent(),
            Value<DateTime?> dueDate = const Value.absent(),
            Value<String?> sourceId = const Value.absent(),
            Value<String?> sourceType = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FinancialTasksCompanion(
            id: id,
            title: title,
            amount: amount,
            type: type,
            status: status,
            createdAt: createdAt,
            actualAmount: actualAmount,
            dueDate: dueDate,
            sourceId: sourceId,
            sourceType: sourceType,
            notes: notes,
            completedAt: completedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required double amount,
            required String type,
            required String status,
            required DateTime createdAt,
            Value<double?> actualAmount = const Value.absent(),
            Value<DateTime?> dueDate = const Value.absent(),
            Value<String?> sourceId = const Value.absent(),
            Value<String?> sourceType = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FinancialTasksCompanion.insert(
            id: id,
            title: title,
            amount: amount,
            type: type,
            status: status,
            createdAt: createdAt,
            actualAmount: actualAmount,
            dueDate: dueDate,
            sourceId: sourceId,
            sourceType: sourceType,
            notes: notes,
            completedAt: completedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FinancialTasksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FinancialTasksTable,
    FinancialTask,
    $$FinancialTasksTableFilterComposer,
    $$FinancialTasksTableOrderingComposer,
    $$FinancialTasksTableAnnotationComposer,
    $$FinancialTasksTableCreateCompanionBuilder,
    $$FinancialTasksTableUpdateCompanionBuilder,
    (
      FinancialTask,
      BaseReferences<_$AppDatabase, $FinancialTasksTable, FinancialTask>
    ),
    FinancialTask,
    PrefetchHooks Function()>;
typedef $$FinancialTaskOverridesTableCreateCompanionBuilder
    = FinancialTaskOverridesCompanion Function({
  required String taskId,
  Value<String?> title,
  Value<double?> amount,
  Value<String?> status,
  Value<double?> actualAmount,
  Value<DateTime?> dueDate,
  Value<String?> notes,
  Value<DateTime?> completedAt,
  Value<int> rowid,
});
typedef $$FinancialTaskOverridesTableUpdateCompanionBuilder
    = FinancialTaskOverridesCompanion Function({
  Value<String> taskId,
  Value<String?> title,
  Value<double?> amount,
  Value<String?> status,
  Value<double?> actualAmount,
  Value<DateTime?> dueDate,
  Value<String?> notes,
  Value<DateTime?> completedAt,
  Value<int> rowid,
});

class $$FinancialTaskOverridesTableFilterComposer
    extends Composer<_$AppDatabase, $FinancialTaskOverridesTable> {
  $$FinancialTaskOverridesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get actualAmount => $composableBuilder(
      column: $table.actualAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));
}

class $$FinancialTaskOverridesTableOrderingComposer
    extends Composer<_$AppDatabase, $FinancialTaskOverridesTable> {
  $$FinancialTaskOverridesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get actualAmount => $composableBuilder(
      column: $table.actualAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));
}

class $$FinancialTaskOverridesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FinancialTaskOverridesTable> {
  $$FinancialTaskOverridesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get actualAmount => $composableBuilder(
      column: $table.actualAmount, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);
}

class $$FinancialTaskOverridesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FinancialTaskOverridesTable,
    FinancialTaskOverride,
    $$FinancialTaskOverridesTableFilterComposer,
    $$FinancialTaskOverridesTableOrderingComposer,
    $$FinancialTaskOverridesTableAnnotationComposer,
    $$FinancialTaskOverridesTableCreateCompanionBuilder,
    $$FinancialTaskOverridesTableUpdateCompanionBuilder,
    (
      FinancialTaskOverride,
      BaseReferences<_$AppDatabase, $FinancialTaskOverridesTable,
          FinancialTaskOverride>
    ),
    FinancialTaskOverride,
    PrefetchHooks Function()> {
  $$FinancialTaskOverridesTableTableManager(
      _$AppDatabase db, $FinancialTaskOverridesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FinancialTaskOverridesTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$FinancialTaskOverridesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FinancialTaskOverridesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> taskId = const Value.absent(),
            Value<String?> title = const Value.absent(),
            Value<double?> amount = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<double?> actualAmount = const Value.absent(),
            Value<DateTime?> dueDate = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FinancialTaskOverridesCompanion(
            taskId: taskId,
            title: title,
            amount: amount,
            status: status,
            actualAmount: actualAmount,
            dueDate: dueDate,
            notes: notes,
            completedAt: completedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String taskId,
            Value<String?> title = const Value.absent(),
            Value<double?> amount = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<double?> actualAmount = const Value.absent(),
            Value<DateTime?> dueDate = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FinancialTaskOverridesCompanion.insert(
            taskId: taskId,
            title: title,
            amount: amount,
            status: status,
            actualAmount: actualAmount,
            dueDate: dueDate,
            notes: notes,
            completedAt: completedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FinancialTaskOverridesTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $FinancialTaskOverridesTable,
        FinancialTaskOverride,
        $$FinancialTaskOverridesTableFilterComposer,
        $$FinancialTaskOverridesTableOrderingComposer,
        $$FinancialTaskOverridesTableAnnotationComposer,
        $$FinancialTaskOverridesTableCreateCompanionBuilder,
        $$FinancialTaskOverridesTableUpdateCompanionBuilder,
        (
          FinancialTaskOverride,
          BaseReferences<_$AppDatabase, $FinancialTaskOverridesTable,
              FinancialTaskOverride>
        ),
        FinancialTaskOverride,
        PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$BudgetCategoriesTableTableManager get budgetCategories =>
      $$BudgetCategoriesTableTableManager(_db, _db.budgetCategories);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$PlannedExpensesTableTableManager get plannedExpenses =>
      $$PlannedExpensesTableTableManager(_db, _db.plannedExpenses);
  $$CreditCardsTableTableManager get creditCards =>
      $$CreditCardsTableTableManager(_db, _db.creditCards);
  $$CreditCardPurchasesTableTableManager get creditCardPurchases =>
      $$CreditCardPurchasesTableTableManager(_db, _db.creditCardPurchases);
  $$SubscriptionsTableTableManager get subscriptions =>
      $$SubscriptionsTableTableManager(_db, _db.subscriptions);
  $$CreditCardMonthlyPaymentsTableTableManager get creditCardMonthlyPayments =>
      $$CreditCardMonthlyPaymentsTableTableManager(
          _db, _db.creditCardMonthlyPayments);
  $$MonthlyExtrasTableTableManager get monthlyExtras =>
      $$MonthlyExtrasTableTableManager(_db, _db.monthlyExtras);
  $$SurplusPlansTableTableManager get surplusPlans =>
      $$SurplusPlansTableTableManager(_db, _db.surplusPlans);
  $$FinancialTasksTableTableManager get financialTasks =>
      $$FinancialTasksTableTableManager(_db, _db.financialTasks);
  $$FinancialTaskOverridesTableTableManager get financialTaskOverrides =>
      $$FinancialTaskOverridesTableTableManager(
          _db, _db.financialTaskOverrides);
}
