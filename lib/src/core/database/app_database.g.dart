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

class $TandasTable extends Tandas with TableInfo<$TandasTable, Tanda> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TandasTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _contributionAmountMeta =
      const VerificationMeta('contributionAmount');
  @override
  late final GeneratedColumn<double> contributionAmount =
      GeneratedColumn<double>('contribution_amount', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _frequencyMeta =
      const VerificationMeta('frequency');
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
      'frequency', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _participantCountMeta =
      const VerificationMeta('participantCount');
  @override
  late final GeneratedColumn<int> participantCount = GeneratedColumn<int>(
      'participant_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _assignedTurnMeta =
      const VerificationMeta('assignedTurn');
  @override
  late final GeneratedColumn<int> assignedTurn = GeneratedColumn<int>(
      'assigned_turn', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _completedContributionsMeta =
      const VerificationMeta('completedContributions');
  @override
  late final GeneratedColumn<int> completedContributions = GeneratedColumn<int>(
      'completed_contributions', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        contributionAmount,
        frequency,
        startDate,
        participantCount,
        assignedTurn,
        completedContributions,
        status,
        notes,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tandas';
  @override
  VerificationContext validateIntegrity(Insertable<Tanda> instance,
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
    if (data.containsKey('contribution_amount')) {
      context.handle(
          _contributionAmountMeta,
          contributionAmount.isAcceptableOrUnknown(
              data['contribution_amount']!, _contributionAmountMeta));
    } else if (isInserting) {
      context.missing(_contributionAmountMeta);
    }
    if (data.containsKey('frequency')) {
      context.handle(_frequencyMeta,
          frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta));
    } else if (isInserting) {
      context.missing(_frequencyMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('participant_count')) {
      context.handle(
          _participantCountMeta,
          participantCount.isAcceptableOrUnknown(
              data['participant_count']!, _participantCountMeta));
    } else if (isInserting) {
      context.missing(_participantCountMeta);
    }
    if (data.containsKey('assigned_turn')) {
      context.handle(
          _assignedTurnMeta,
          assignedTurn.isAcceptableOrUnknown(
              data['assigned_turn']!, _assignedTurnMeta));
    } else if (isInserting) {
      context.missing(_assignedTurnMeta);
    }
    if (data.containsKey('completed_contributions')) {
      context.handle(
          _completedContributionsMeta,
          completedContributions.isAcceptableOrUnknown(
              data['completed_contributions']!, _completedContributionsMeta));
    } else if (isInserting) {
      context.missing(_completedContributionsMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tanda map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tanda(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      contributionAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}contribution_amount'])!,
      frequency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}frequency'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      participantCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}participant_count'])!,
      assignedTurn: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}assigned_turn'])!,
      completedContributions: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}completed_contributions'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $TandasTable createAlias(String alias) {
    return $TandasTable(attachedDatabase, alias);
  }
}

class Tanda extends DataClass implements Insertable<Tanda> {
  final String id;
  final String name;
  final double contributionAmount;
  final String frequency;
  final DateTime startDate;
  final int participantCount;
  final int assignedTurn;
  final int completedContributions;
  final String status;
  final String? notes;
  final DateTime createdAt;
  const Tanda(
      {required this.id,
      required this.name,
      required this.contributionAmount,
      required this.frequency,
      required this.startDate,
      required this.participantCount,
      required this.assignedTurn,
      required this.completedContributions,
      required this.status,
      this.notes,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['contribution_amount'] = Variable<double>(contributionAmount);
    map['frequency'] = Variable<String>(frequency);
    map['start_date'] = Variable<DateTime>(startDate);
    map['participant_count'] = Variable<int>(participantCount);
    map['assigned_turn'] = Variable<int>(assignedTurn);
    map['completed_contributions'] = Variable<int>(completedContributions);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TandasCompanion toCompanion(bool nullToAbsent) {
    return TandasCompanion(
      id: Value(id),
      name: Value(name),
      contributionAmount: Value(contributionAmount),
      frequency: Value(frequency),
      startDate: Value(startDate),
      participantCount: Value(participantCount),
      assignedTurn: Value(assignedTurn),
      completedContributions: Value(completedContributions),
      status: Value(status),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory Tanda.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tanda(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      contributionAmount:
          serializer.fromJson<double>(json['contributionAmount']),
      frequency: serializer.fromJson<String>(json['frequency']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      participantCount: serializer.fromJson<int>(json['participantCount']),
      assignedTurn: serializer.fromJson<int>(json['assignedTurn']),
      completedContributions:
          serializer.fromJson<int>(json['completedContributions']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'contributionAmount': serializer.toJson<double>(contributionAmount),
      'frequency': serializer.toJson<String>(frequency),
      'startDate': serializer.toJson<DateTime>(startDate),
      'participantCount': serializer.toJson<int>(participantCount),
      'assignedTurn': serializer.toJson<int>(assignedTurn),
      'completedContributions': serializer.toJson<int>(completedContributions),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Tanda copyWith(
          {String? id,
          String? name,
          double? contributionAmount,
          String? frequency,
          DateTime? startDate,
          int? participantCount,
          int? assignedTurn,
          int? completedContributions,
          String? status,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt}) =>
      Tanda(
        id: id ?? this.id,
        name: name ?? this.name,
        contributionAmount: contributionAmount ?? this.contributionAmount,
        frequency: frequency ?? this.frequency,
        startDate: startDate ?? this.startDate,
        participantCount: participantCount ?? this.participantCount,
        assignedTurn: assignedTurn ?? this.assignedTurn,
        completedContributions:
            completedContributions ?? this.completedContributions,
        status: status ?? this.status,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
      );
  Tanda copyWithCompanion(TandasCompanion data) {
    return Tanda(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      contributionAmount: data.contributionAmount.present
          ? data.contributionAmount.value
          : this.contributionAmount,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      participantCount: data.participantCount.present
          ? data.participantCount.value
          : this.participantCount,
      assignedTurn: data.assignedTurn.present
          ? data.assignedTurn.value
          : this.assignedTurn,
      completedContributions: data.completedContributions.present
          ? data.completedContributions.value
          : this.completedContributions,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tanda(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('contributionAmount: $contributionAmount, ')
          ..write('frequency: $frequency, ')
          ..write('startDate: $startDate, ')
          ..write('participantCount: $participantCount, ')
          ..write('assignedTurn: $assignedTurn, ')
          ..write('completedContributions: $completedContributions, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      contributionAmount,
      frequency,
      startDate,
      participantCount,
      assignedTurn,
      completedContributions,
      status,
      notes,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tanda &&
          other.id == this.id &&
          other.name == this.name &&
          other.contributionAmount == this.contributionAmount &&
          other.frequency == this.frequency &&
          other.startDate == this.startDate &&
          other.participantCount == this.participantCount &&
          other.assignedTurn == this.assignedTurn &&
          other.completedContributions == this.completedContributions &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class TandasCompanion extends UpdateCompanion<Tanda> {
  final Value<String> id;
  final Value<String> name;
  final Value<double> contributionAmount;
  final Value<String> frequency;
  final Value<DateTime> startDate;
  final Value<int> participantCount;
  final Value<int> assignedTurn;
  final Value<int> completedContributions;
  final Value<String> status;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TandasCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.contributionAmount = const Value.absent(),
    this.frequency = const Value.absent(),
    this.startDate = const Value.absent(),
    this.participantCount = const Value.absent(),
    this.assignedTurn = const Value.absent(),
    this.completedContributions = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TandasCompanion.insert({
    required String id,
    required String name,
    required double contributionAmount,
    required String frequency,
    required DateTime startDate,
    required int participantCount,
    required int assignedTurn,
    required int completedContributions,
    required String status,
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        contributionAmount = Value(contributionAmount),
        frequency = Value(frequency),
        startDate = Value(startDate),
        participantCount = Value(participantCount),
        assignedTurn = Value(assignedTurn),
        completedContributions = Value(completedContributions),
        status = Value(status),
        createdAt = Value(createdAt);
  static Insertable<Tanda> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<double>? contributionAmount,
    Expression<String>? frequency,
    Expression<DateTime>? startDate,
    Expression<int>? participantCount,
    Expression<int>? assignedTurn,
    Expression<int>? completedContributions,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (contributionAmount != null) 'contribution_amount': contributionAmount,
      if (frequency != null) 'frequency': frequency,
      if (startDate != null) 'start_date': startDate,
      if (participantCount != null) 'participant_count': participantCount,
      if (assignedTurn != null) 'assigned_turn': assignedTurn,
      if (completedContributions != null)
        'completed_contributions': completedContributions,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TandasCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<double>? contributionAmount,
      Value<String>? frequency,
      Value<DateTime>? startDate,
      Value<int>? participantCount,
      Value<int>? assignedTurn,
      Value<int>? completedContributions,
      Value<String>? status,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return TandasCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      contributionAmount: contributionAmount ?? this.contributionAmount,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      participantCount: participantCount ?? this.participantCount,
      assignedTurn: assignedTurn ?? this.assignedTurn,
      completedContributions:
          completedContributions ?? this.completedContributions,
      status: status ?? this.status,
      notes: notes ?? this.notes,
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
    if (contributionAmount.present) {
      map['contribution_amount'] = Variable<double>(contributionAmount.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (participantCount.present) {
      map['participant_count'] = Variable<int>(participantCount.value);
    }
    if (assignedTurn.present) {
      map['assigned_turn'] = Variable<int>(assignedTurn.value);
    }
    if (completedContributions.present) {
      map['completed_contributions'] =
          Variable<int>(completedContributions.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
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
    return (StringBuffer('TandasCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('contributionAmount: $contributionAmount, ')
          ..write('frequency: $frequency, ')
          ..write('startDate: $startDate, ')
          ..write('participantCount: $participantCount, ')
          ..write('assignedTurn: $assignedTurn, ')
          ..write('completedContributions: $completedContributions, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TandaContributionsTable extends TandaContributions
    with TableInfo<$TandaContributionsTable, TandaContribution> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TandaContributionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tandaIdMeta =
      const VerificationMeta('tandaId');
  @override
  late final GeneratedColumn<String> tandaId = GeneratedColumn<String>(
      'tanda_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES tandas (id) ON DELETE CASCADE'));
  static const VerificationMeta _sequenceNumberMeta =
      const VerificationMeta('sequenceNumber');
  @override
  late final GeneratedColumn<int> sequenceNumber = GeneratedColumn<int>(
      'sequence_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _scheduledDateMeta =
      const VerificationMeta('scheduledDate');
  @override
  late final GeneratedColumn<DateTime> scheduledDate =
      GeneratedColumn<DateTime>('scheduled_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _paidAtMeta = const VerificationMeta('paidAt');
  @override
  late final GeneratedColumn<DateTime> paidAt = GeneratedColumn<DateTime>(
      'paid_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _migratedFromLegacyCounterMeta =
      const VerificationMeta('migratedFromLegacyCounter');
  @override
  late final GeneratedColumn<bool> migratedFromLegacyCounter =
      GeneratedColumn<bool>('migrated_from_legacy_counter', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'CHECK ("migrated_from_legacy_counter" IN (0, 1))'),
          defaultValue: const Constant(false));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _linkedTransactionIdMeta =
      const VerificationMeta('linkedTransactionId');
  @override
  late final GeneratedColumn<String> linkedTransactionId =
      GeneratedColumn<String>('linked_transaction_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tandaId,
        sequenceNumber,
        amount,
        scheduledDate,
        status,
        paidAt,
        createdAt,
        migratedFromLegacyCounter,
        notes,
        linkedTransactionId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tanda_contributions';
  @override
  VerificationContext validateIntegrity(Insertable<TandaContribution> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tanda_id')) {
      context.handle(_tandaIdMeta,
          tandaId.isAcceptableOrUnknown(data['tanda_id']!, _tandaIdMeta));
    } else if (isInserting) {
      context.missing(_tandaIdMeta);
    }
    if (data.containsKey('sequence_number')) {
      context.handle(
          _sequenceNumberMeta,
          sequenceNumber.isAcceptableOrUnknown(
              data['sequence_number']!, _sequenceNumberMeta));
    } else if (isInserting) {
      context.missing(_sequenceNumberMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('scheduled_date')) {
      context.handle(
          _scheduledDateMeta,
          scheduledDate.isAcceptableOrUnknown(
              data['scheduled_date']!, _scheduledDateMeta));
    } else if (isInserting) {
      context.missing(_scheduledDateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('paid_at')) {
      context.handle(_paidAtMeta,
          paidAt.isAcceptableOrUnknown(data['paid_at']!, _paidAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('migrated_from_legacy_counter')) {
      context.handle(
          _migratedFromLegacyCounterMeta,
          migratedFromLegacyCounter.isAcceptableOrUnknown(
              data['migrated_from_legacy_counter']!,
              _migratedFromLegacyCounterMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('linked_transaction_id')) {
      context.handle(
          _linkedTransactionIdMeta,
          linkedTransactionId.isAcceptableOrUnknown(
              data['linked_transaction_id']!, _linkedTransactionIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {tandaId, sequenceNumber},
      ];
  @override
  TandaContribution map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TandaContribution(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      tandaId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tanda_id'])!,
      sequenceNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sequence_number'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      scheduledDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}scheduled_date'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      paidAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}paid_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      migratedFromLegacyCounter: attachedDatabase.typeMapping.read(
          DriftSqlType.bool,
          data['${effectivePrefix}migrated_from_legacy_counter'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      linkedTransactionId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}linked_transaction_id']),
    );
  }

  @override
  $TandaContributionsTable createAlias(String alias) {
    return $TandaContributionsTable(attachedDatabase, alias);
  }
}

class TandaContribution extends DataClass
    implements Insertable<TandaContribution> {
  final String id;
  final String tandaId;
  final int sequenceNumber;
  final double amount;
  final DateTime scheduledDate;
  final String status;
  final DateTime? paidAt;
  final DateTime createdAt;
  final bool migratedFromLegacyCounter;
  final String? notes;
  final String? linkedTransactionId;
  const TandaContribution(
      {required this.id,
      required this.tandaId,
      required this.sequenceNumber,
      required this.amount,
      required this.scheduledDate,
      required this.status,
      this.paidAt,
      required this.createdAt,
      required this.migratedFromLegacyCounter,
      this.notes,
      this.linkedTransactionId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tanda_id'] = Variable<String>(tandaId);
    map['sequence_number'] = Variable<int>(sequenceNumber);
    map['amount'] = Variable<double>(amount);
    map['scheduled_date'] = Variable<DateTime>(scheduledDate);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || paidAt != null) {
      map['paid_at'] = Variable<DateTime>(paidAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['migrated_from_legacy_counter'] =
        Variable<bool>(migratedFromLegacyCounter);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || linkedTransactionId != null) {
      map['linked_transaction_id'] = Variable<String>(linkedTransactionId);
    }
    return map;
  }

  TandaContributionsCompanion toCompanion(bool nullToAbsent) {
    return TandaContributionsCompanion(
      id: Value(id),
      tandaId: Value(tandaId),
      sequenceNumber: Value(sequenceNumber),
      amount: Value(amount),
      scheduledDate: Value(scheduledDate),
      status: Value(status),
      paidAt:
          paidAt == null && nullToAbsent ? const Value.absent() : Value(paidAt),
      createdAt: Value(createdAt),
      migratedFromLegacyCounter: Value(migratedFromLegacyCounter),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      linkedTransactionId: linkedTransactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedTransactionId),
    );
  }

  factory TandaContribution.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TandaContribution(
      id: serializer.fromJson<String>(json['id']),
      tandaId: serializer.fromJson<String>(json['tandaId']),
      sequenceNumber: serializer.fromJson<int>(json['sequenceNumber']),
      amount: serializer.fromJson<double>(json['amount']),
      scheduledDate: serializer.fromJson<DateTime>(json['scheduledDate']),
      status: serializer.fromJson<String>(json['status']),
      paidAt: serializer.fromJson<DateTime?>(json['paidAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      migratedFromLegacyCounter:
          serializer.fromJson<bool>(json['migratedFromLegacyCounter']),
      notes: serializer.fromJson<String?>(json['notes']),
      linkedTransactionId:
          serializer.fromJson<String?>(json['linkedTransactionId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tandaId': serializer.toJson<String>(tandaId),
      'sequenceNumber': serializer.toJson<int>(sequenceNumber),
      'amount': serializer.toJson<double>(amount),
      'scheduledDate': serializer.toJson<DateTime>(scheduledDate),
      'status': serializer.toJson<String>(status),
      'paidAt': serializer.toJson<DateTime?>(paidAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'migratedFromLegacyCounter':
          serializer.toJson<bool>(migratedFromLegacyCounter),
      'notes': serializer.toJson<String?>(notes),
      'linkedTransactionId': serializer.toJson<String?>(linkedTransactionId),
    };
  }

  TandaContribution copyWith(
          {String? id,
          String? tandaId,
          int? sequenceNumber,
          double? amount,
          DateTime? scheduledDate,
          String? status,
          Value<DateTime?> paidAt = const Value.absent(),
          DateTime? createdAt,
          bool? migratedFromLegacyCounter,
          Value<String?> notes = const Value.absent(),
          Value<String?> linkedTransactionId = const Value.absent()}) =>
      TandaContribution(
        id: id ?? this.id,
        tandaId: tandaId ?? this.tandaId,
        sequenceNumber: sequenceNumber ?? this.sequenceNumber,
        amount: amount ?? this.amount,
        scheduledDate: scheduledDate ?? this.scheduledDate,
        status: status ?? this.status,
        paidAt: paidAt.present ? paidAt.value : this.paidAt,
        createdAt: createdAt ?? this.createdAt,
        migratedFromLegacyCounter:
            migratedFromLegacyCounter ?? this.migratedFromLegacyCounter,
        notes: notes.present ? notes.value : this.notes,
        linkedTransactionId: linkedTransactionId.present
            ? linkedTransactionId.value
            : this.linkedTransactionId,
      );
  TandaContribution copyWithCompanion(TandaContributionsCompanion data) {
    return TandaContribution(
      id: data.id.present ? data.id.value : this.id,
      tandaId: data.tandaId.present ? data.tandaId.value : this.tandaId,
      sequenceNumber: data.sequenceNumber.present
          ? data.sequenceNumber.value
          : this.sequenceNumber,
      amount: data.amount.present ? data.amount.value : this.amount,
      scheduledDate: data.scheduledDate.present
          ? data.scheduledDate.value
          : this.scheduledDate,
      status: data.status.present ? data.status.value : this.status,
      paidAt: data.paidAt.present ? data.paidAt.value : this.paidAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      migratedFromLegacyCounter: data.migratedFromLegacyCounter.present
          ? data.migratedFromLegacyCounter.value
          : this.migratedFromLegacyCounter,
      notes: data.notes.present ? data.notes.value : this.notes,
      linkedTransactionId: data.linkedTransactionId.present
          ? data.linkedTransactionId.value
          : this.linkedTransactionId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TandaContribution(')
          ..write('id: $id, ')
          ..write('tandaId: $tandaId, ')
          ..write('sequenceNumber: $sequenceNumber, ')
          ..write('amount: $amount, ')
          ..write('scheduledDate: $scheduledDate, ')
          ..write('status: $status, ')
          ..write('paidAt: $paidAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('migratedFromLegacyCounter: $migratedFromLegacyCounter, ')
          ..write('notes: $notes, ')
          ..write('linkedTransactionId: $linkedTransactionId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      tandaId,
      sequenceNumber,
      amount,
      scheduledDate,
      status,
      paidAt,
      createdAt,
      migratedFromLegacyCounter,
      notes,
      linkedTransactionId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TandaContribution &&
          other.id == this.id &&
          other.tandaId == this.tandaId &&
          other.sequenceNumber == this.sequenceNumber &&
          other.amount == this.amount &&
          other.scheduledDate == this.scheduledDate &&
          other.status == this.status &&
          other.paidAt == this.paidAt &&
          other.createdAt == this.createdAt &&
          other.migratedFromLegacyCounter == this.migratedFromLegacyCounter &&
          other.notes == this.notes &&
          other.linkedTransactionId == this.linkedTransactionId);
}

class TandaContributionsCompanion extends UpdateCompanion<TandaContribution> {
  final Value<String> id;
  final Value<String> tandaId;
  final Value<int> sequenceNumber;
  final Value<double> amount;
  final Value<DateTime> scheduledDate;
  final Value<String> status;
  final Value<DateTime?> paidAt;
  final Value<DateTime> createdAt;
  final Value<bool> migratedFromLegacyCounter;
  final Value<String?> notes;
  final Value<String?> linkedTransactionId;
  final Value<int> rowid;
  const TandaContributionsCompanion({
    this.id = const Value.absent(),
    this.tandaId = const Value.absent(),
    this.sequenceNumber = const Value.absent(),
    this.amount = const Value.absent(),
    this.scheduledDate = const Value.absent(),
    this.status = const Value.absent(),
    this.paidAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.migratedFromLegacyCounter = const Value.absent(),
    this.notes = const Value.absent(),
    this.linkedTransactionId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TandaContributionsCompanion.insert({
    required String id,
    required String tandaId,
    required int sequenceNumber,
    required double amount,
    required DateTime scheduledDate,
    required String status,
    this.paidAt = const Value.absent(),
    required DateTime createdAt,
    this.migratedFromLegacyCounter = const Value.absent(),
    this.notes = const Value.absent(),
    this.linkedTransactionId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        tandaId = Value(tandaId),
        sequenceNumber = Value(sequenceNumber),
        amount = Value(amount),
        scheduledDate = Value(scheduledDate),
        status = Value(status),
        createdAt = Value(createdAt);
  static Insertable<TandaContribution> custom({
    Expression<String>? id,
    Expression<String>? tandaId,
    Expression<int>? sequenceNumber,
    Expression<double>? amount,
    Expression<DateTime>? scheduledDate,
    Expression<String>? status,
    Expression<DateTime>? paidAt,
    Expression<DateTime>? createdAt,
    Expression<bool>? migratedFromLegacyCounter,
    Expression<String>? notes,
    Expression<String>? linkedTransactionId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tandaId != null) 'tanda_id': tandaId,
      if (sequenceNumber != null) 'sequence_number': sequenceNumber,
      if (amount != null) 'amount': amount,
      if (scheduledDate != null) 'scheduled_date': scheduledDate,
      if (status != null) 'status': status,
      if (paidAt != null) 'paid_at': paidAt,
      if (createdAt != null) 'created_at': createdAt,
      if (migratedFromLegacyCounter != null)
        'migrated_from_legacy_counter': migratedFromLegacyCounter,
      if (notes != null) 'notes': notes,
      if (linkedTransactionId != null)
        'linked_transaction_id': linkedTransactionId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TandaContributionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? tandaId,
      Value<int>? sequenceNumber,
      Value<double>? amount,
      Value<DateTime>? scheduledDate,
      Value<String>? status,
      Value<DateTime?>? paidAt,
      Value<DateTime>? createdAt,
      Value<bool>? migratedFromLegacyCounter,
      Value<String?>? notes,
      Value<String?>? linkedTransactionId,
      Value<int>? rowid}) {
    return TandaContributionsCompanion(
      id: id ?? this.id,
      tandaId: tandaId ?? this.tandaId,
      sequenceNumber: sequenceNumber ?? this.sequenceNumber,
      amount: amount ?? this.amount,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      status: status ?? this.status,
      paidAt: paidAt ?? this.paidAt,
      createdAt: createdAt ?? this.createdAt,
      migratedFromLegacyCounter:
          migratedFromLegacyCounter ?? this.migratedFromLegacyCounter,
      notes: notes ?? this.notes,
      linkedTransactionId: linkedTransactionId ?? this.linkedTransactionId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tandaId.present) {
      map['tanda_id'] = Variable<String>(tandaId.value);
    }
    if (sequenceNumber.present) {
      map['sequence_number'] = Variable<int>(sequenceNumber.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (scheduledDate.present) {
      map['scheduled_date'] = Variable<DateTime>(scheduledDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (paidAt.present) {
      map['paid_at'] = Variable<DateTime>(paidAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (migratedFromLegacyCounter.present) {
      map['migrated_from_legacy_counter'] =
          Variable<bool>(migratedFromLegacyCounter.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (linkedTransactionId.present) {
      map['linked_transaction_id'] =
          Variable<String>(linkedTransactionId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TandaContributionsCompanion(')
          ..write('id: $id, ')
          ..write('tandaId: $tandaId, ')
          ..write('sequenceNumber: $sequenceNumber, ')
          ..write('amount: $amount, ')
          ..write('scheduledDate: $scheduledDate, ')
          ..write('status: $status, ')
          ..write('paidAt: $paidAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('migratedFromLegacyCounter: $migratedFromLegacyCounter, ')
          ..write('notes: $notes, ')
          ..write('linkedTransactionId: $linkedTransactionId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TandaReceiptsTable extends TandaReceipts
    with TableInfo<$TandaReceiptsTable, TandaReceipt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TandaReceiptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tandaIdMeta =
      const VerificationMeta('tandaId');
  @override
  late final GeneratedColumn<String> tandaId = GeneratedColumn<String>(
      'tanda_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'UNIQUE REFERENCES tandas (id) ON DELETE CASCADE'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _scheduledDateMeta =
      const VerificationMeta('scheduledDate');
  @override
  late final GeneratedColumn<DateTime> scheduledDate =
      GeneratedColumn<DateTime>('scheduled_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _receivedAtMeta =
      const VerificationMeta('receivedAt');
  @override
  late final GeneratedColumn<DateTime> receivedAt = GeneratedColumn<DateTime>(
      'received_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _linkedTransactionIdMeta =
      const VerificationMeta('linkedTransactionId');
  @override
  late final GeneratedColumn<String> linkedTransactionId =
      GeneratedColumn<String>('linked_transaction_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tandaId,
        amount,
        scheduledDate,
        status,
        receivedAt,
        linkedTransactionId,
        createdAt,
        notes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tanda_receipts';
  @override
  VerificationContext validateIntegrity(Insertable<TandaReceipt> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tanda_id')) {
      context.handle(_tandaIdMeta,
          tandaId.isAcceptableOrUnknown(data['tanda_id']!, _tandaIdMeta));
    } else if (isInserting) {
      context.missing(_tandaIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('scheduled_date')) {
      context.handle(
          _scheduledDateMeta,
          scheduledDate.isAcceptableOrUnknown(
              data['scheduled_date']!, _scheduledDateMeta));
    } else if (isInserting) {
      context.missing(_scheduledDateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('received_at')) {
      context.handle(
          _receivedAtMeta,
          receivedAt.isAcceptableOrUnknown(
              data['received_at']!, _receivedAtMeta));
    }
    if (data.containsKey('linked_transaction_id')) {
      context.handle(
          _linkedTransactionIdMeta,
          linkedTransactionId.isAcceptableOrUnknown(
              data['linked_transaction_id']!, _linkedTransactionIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
  TandaReceipt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TandaReceipt(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      tandaId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tanda_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      scheduledDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}scheduled_date'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      receivedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}received_at']),
      linkedTransactionId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}linked_transaction_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $TandaReceiptsTable createAlias(String alias) {
    return $TandaReceiptsTable(attachedDatabase, alias);
  }
}

class TandaReceipt extends DataClass implements Insertable<TandaReceipt> {
  final String id;
  final String tandaId;
  final double amount;
  final DateTime scheduledDate;
  final String status;
  final DateTime? receivedAt;
  final String? linkedTransactionId;
  final DateTime createdAt;
  final String? notes;
  const TandaReceipt(
      {required this.id,
      required this.tandaId,
      required this.amount,
      required this.scheduledDate,
      required this.status,
      this.receivedAt,
      this.linkedTransactionId,
      required this.createdAt,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tanda_id'] = Variable<String>(tandaId);
    map['amount'] = Variable<double>(amount);
    map['scheduled_date'] = Variable<DateTime>(scheduledDate);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || receivedAt != null) {
      map['received_at'] = Variable<DateTime>(receivedAt);
    }
    if (!nullToAbsent || linkedTransactionId != null) {
      map['linked_transaction_id'] = Variable<String>(linkedTransactionId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  TandaReceiptsCompanion toCompanion(bool nullToAbsent) {
    return TandaReceiptsCompanion(
      id: Value(id),
      tandaId: Value(tandaId),
      amount: Value(amount),
      scheduledDate: Value(scheduledDate),
      status: Value(status),
      receivedAt: receivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(receivedAt),
      linkedTransactionId: linkedTransactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedTransactionId),
      createdAt: Value(createdAt),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory TandaReceipt.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TandaReceipt(
      id: serializer.fromJson<String>(json['id']),
      tandaId: serializer.fromJson<String>(json['tandaId']),
      amount: serializer.fromJson<double>(json['amount']),
      scheduledDate: serializer.fromJson<DateTime>(json['scheduledDate']),
      status: serializer.fromJson<String>(json['status']),
      receivedAt: serializer.fromJson<DateTime?>(json['receivedAt']),
      linkedTransactionId:
          serializer.fromJson<String?>(json['linkedTransactionId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tandaId': serializer.toJson<String>(tandaId),
      'amount': serializer.toJson<double>(amount),
      'scheduledDate': serializer.toJson<DateTime>(scheduledDate),
      'status': serializer.toJson<String>(status),
      'receivedAt': serializer.toJson<DateTime?>(receivedAt),
      'linkedTransactionId': serializer.toJson<String?>(linkedTransactionId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  TandaReceipt copyWith(
          {String? id,
          String? tandaId,
          double? amount,
          DateTime? scheduledDate,
          String? status,
          Value<DateTime?> receivedAt = const Value.absent(),
          Value<String?> linkedTransactionId = const Value.absent(),
          DateTime? createdAt,
          Value<String?> notes = const Value.absent()}) =>
      TandaReceipt(
        id: id ?? this.id,
        tandaId: tandaId ?? this.tandaId,
        amount: amount ?? this.amount,
        scheduledDate: scheduledDate ?? this.scheduledDate,
        status: status ?? this.status,
        receivedAt: receivedAt.present ? receivedAt.value : this.receivedAt,
        linkedTransactionId: linkedTransactionId.present
            ? linkedTransactionId.value
            : this.linkedTransactionId,
        createdAt: createdAt ?? this.createdAt,
        notes: notes.present ? notes.value : this.notes,
      );
  TandaReceipt copyWithCompanion(TandaReceiptsCompanion data) {
    return TandaReceipt(
      id: data.id.present ? data.id.value : this.id,
      tandaId: data.tandaId.present ? data.tandaId.value : this.tandaId,
      amount: data.amount.present ? data.amount.value : this.amount,
      scheduledDate: data.scheduledDate.present
          ? data.scheduledDate.value
          : this.scheduledDate,
      status: data.status.present ? data.status.value : this.status,
      receivedAt:
          data.receivedAt.present ? data.receivedAt.value : this.receivedAt,
      linkedTransactionId: data.linkedTransactionId.present
          ? data.linkedTransactionId.value
          : this.linkedTransactionId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TandaReceipt(')
          ..write('id: $id, ')
          ..write('tandaId: $tandaId, ')
          ..write('amount: $amount, ')
          ..write('scheduledDate: $scheduledDate, ')
          ..write('status: $status, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('linkedTransactionId: $linkedTransactionId, ')
          ..write('createdAt: $createdAt, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tandaId, amount, scheduledDate, status,
      receivedAt, linkedTransactionId, createdAt, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TandaReceipt &&
          other.id == this.id &&
          other.tandaId == this.tandaId &&
          other.amount == this.amount &&
          other.scheduledDate == this.scheduledDate &&
          other.status == this.status &&
          other.receivedAt == this.receivedAt &&
          other.linkedTransactionId == this.linkedTransactionId &&
          other.createdAt == this.createdAt &&
          other.notes == this.notes);
}

class TandaReceiptsCompanion extends UpdateCompanion<TandaReceipt> {
  final Value<String> id;
  final Value<String> tandaId;
  final Value<double> amount;
  final Value<DateTime> scheduledDate;
  final Value<String> status;
  final Value<DateTime?> receivedAt;
  final Value<String?> linkedTransactionId;
  final Value<DateTime> createdAt;
  final Value<String?> notes;
  final Value<int> rowid;
  const TandaReceiptsCompanion({
    this.id = const Value.absent(),
    this.tandaId = const Value.absent(),
    this.amount = const Value.absent(),
    this.scheduledDate = const Value.absent(),
    this.status = const Value.absent(),
    this.receivedAt = const Value.absent(),
    this.linkedTransactionId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TandaReceiptsCompanion.insert({
    required String id,
    required String tandaId,
    required double amount,
    required DateTime scheduledDate,
    required String status,
    this.receivedAt = const Value.absent(),
    this.linkedTransactionId = const Value.absent(),
    required DateTime createdAt,
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        tandaId = Value(tandaId),
        amount = Value(amount),
        scheduledDate = Value(scheduledDate),
        status = Value(status),
        createdAt = Value(createdAt);
  static Insertable<TandaReceipt> custom({
    Expression<String>? id,
    Expression<String>? tandaId,
    Expression<double>? amount,
    Expression<DateTime>? scheduledDate,
    Expression<String>? status,
    Expression<DateTime>? receivedAt,
    Expression<String>? linkedTransactionId,
    Expression<DateTime>? createdAt,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tandaId != null) 'tanda_id': tandaId,
      if (amount != null) 'amount': amount,
      if (scheduledDate != null) 'scheduled_date': scheduledDate,
      if (status != null) 'status': status,
      if (receivedAt != null) 'received_at': receivedAt,
      if (linkedTransactionId != null)
        'linked_transaction_id': linkedTransactionId,
      if (createdAt != null) 'created_at': createdAt,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TandaReceiptsCompanion copyWith(
      {Value<String>? id,
      Value<String>? tandaId,
      Value<double>? amount,
      Value<DateTime>? scheduledDate,
      Value<String>? status,
      Value<DateTime?>? receivedAt,
      Value<String?>? linkedTransactionId,
      Value<DateTime>? createdAt,
      Value<String?>? notes,
      Value<int>? rowid}) {
    return TandaReceiptsCompanion(
      id: id ?? this.id,
      tandaId: tandaId ?? this.tandaId,
      amount: amount ?? this.amount,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      status: status ?? this.status,
      receivedAt: receivedAt ?? this.receivedAt,
      linkedTransactionId: linkedTransactionId ?? this.linkedTransactionId,
      createdAt: createdAt ?? this.createdAt,
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
    if (tandaId.present) {
      map['tanda_id'] = Variable<String>(tandaId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (scheduledDate.present) {
      map['scheduled_date'] = Variable<DateTime>(scheduledDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (receivedAt.present) {
      map['received_at'] = Variable<DateTime>(receivedAt.value);
    }
    if (linkedTransactionId.present) {
      map['linked_transaction_id'] =
          Variable<String>(linkedTransactionId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
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
    return (StringBuffer('TandaReceiptsCompanion(')
          ..write('id: $id, ')
          ..write('tandaId: $tandaId, ')
          ..write('amount: $amount, ')
          ..write('scheduledDate: $scheduledDate, ')
          ..write('status: $status, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('linkedTransactionId: $linkedTransactionId, ')
          ..write('createdAt: $createdAt, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskRemindersTable extends TaskReminders
    with TableInfo<$TaskRemindersTable, TaskReminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskRemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
      'task_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notificationIdMeta =
      const VerificationMeta('notificationId');
  @override
  late final GeneratedColumn<int> notificationId = GeneratedColumn<int>(
      'notification_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _enabledMeta =
      const VerificationMeta('enabled');
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
      'enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("enabled" IN (0, 1))'));
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
      'mode', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hourMeta = const VerificationMeta('hour');
  @override
  late final GeneratedColumn<int> hour = GeneratedColumn<int>(
      'hour', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _minuteMeta = const VerificationMeta('minute');
  @override
  late final GeneratedColumn<int> minute = GeneratedColumn<int>(
      'minute', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _customScheduledAtMeta =
      const VerificationMeta('customScheduledAt');
  @override
  late final GeneratedColumn<DateTime> customScheduledAt =
      GeneratedColumn<DateTime>('custom_scheduled_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        taskId,
        notificationId,
        enabled,
        mode,
        hour,
        minute,
        customScheduledAt,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_reminders';
  @override
  VerificationContext validateIntegrity(Insertable<TaskReminder> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('task_id')) {
      context.handle(_taskIdMeta,
          taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta));
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('notification_id')) {
      context.handle(
          _notificationIdMeta,
          notificationId.isAcceptableOrUnknown(
              data['notification_id']!, _notificationIdMeta));
    } else if (isInserting) {
      context.missing(_notificationIdMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(_enabledMeta,
          enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta));
    } else if (isInserting) {
      context.missing(_enabledMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
          _modeMeta, mode.isAcceptableOrUnknown(data['mode']!, _modeMeta));
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('hour')) {
      context.handle(
          _hourMeta, hour.isAcceptableOrUnknown(data['hour']!, _hourMeta));
    } else if (isInserting) {
      context.missing(_hourMeta);
    }
    if (data.containsKey('minute')) {
      context.handle(_minuteMeta,
          minute.isAcceptableOrUnknown(data['minute']!, _minuteMeta));
    } else if (isInserting) {
      context.missing(_minuteMeta);
    }
    if (data.containsKey('custom_scheduled_at')) {
      context.handle(
          _customScheduledAtMeta,
          customScheduledAt.isAcceptableOrUnknown(
              data['custom_scheduled_at']!, _customScheduledAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {taskId};
  @override
  TaskReminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskReminder(
      taskId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}task_id'])!,
      notificationId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}notification_id'])!,
      enabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}enabled'])!,
      mode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mode'])!,
      hour: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hour'])!,
      minute: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}minute'])!,
      customScheduledAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}custom_scheduled_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $TaskRemindersTable createAlias(String alias) {
    return $TaskRemindersTable(attachedDatabase, alias);
  }
}

class TaskReminder extends DataClass implements Insertable<TaskReminder> {
  final String taskId;
  final int notificationId;
  final bool enabled;
  final String mode;
  final int hour;
  final int minute;
  final DateTime? customScheduledAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TaskReminder(
      {required this.taskId,
      required this.notificationId,
      required this.enabled,
      required this.mode,
      required this.hour,
      required this.minute,
      this.customScheduledAt,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['task_id'] = Variable<String>(taskId);
    map['notification_id'] = Variable<int>(notificationId);
    map['enabled'] = Variable<bool>(enabled);
    map['mode'] = Variable<String>(mode);
    map['hour'] = Variable<int>(hour);
    map['minute'] = Variable<int>(minute);
    if (!nullToAbsent || customScheduledAt != null) {
      map['custom_scheduled_at'] = Variable<DateTime>(customScheduledAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TaskRemindersCompanion toCompanion(bool nullToAbsent) {
    return TaskRemindersCompanion(
      taskId: Value(taskId),
      notificationId: Value(notificationId),
      enabled: Value(enabled),
      mode: Value(mode),
      hour: Value(hour),
      minute: Value(minute),
      customScheduledAt: customScheduledAt == null && nullToAbsent
          ? const Value.absent()
          : Value(customScheduledAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TaskReminder.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskReminder(
      taskId: serializer.fromJson<String>(json['taskId']),
      notificationId: serializer.fromJson<int>(json['notificationId']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      mode: serializer.fromJson<String>(json['mode']),
      hour: serializer.fromJson<int>(json['hour']),
      minute: serializer.fromJson<int>(json['minute']),
      customScheduledAt:
          serializer.fromJson<DateTime?>(json['customScheduledAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'taskId': serializer.toJson<String>(taskId),
      'notificationId': serializer.toJson<int>(notificationId),
      'enabled': serializer.toJson<bool>(enabled),
      'mode': serializer.toJson<String>(mode),
      'hour': serializer.toJson<int>(hour),
      'minute': serializer.toJson<int>(minute),
      'customScheduledAt': serializer.toJson<DateTime?>(customScheduledAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TaskReminder copyWith(
          {String? taskId,
          int? notificationId,
          bool? enabled,
          String? mode,
          int? hour,
          int? minute,
          Value<DateTime?> customScheduledAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      TaskReminder(
        taskId: taskId ?? this.taskId,
        notificationId: notificationId ?? this.notificationId,
        enabled: enabled ?? this.enabled,
        mode: mode ?? this.mode,
        hour: hour ?? this.hour,
        minute: minute ?? this.minute,
        customScheduledAt: customScheduledAt.present
            ? customScheduledAt.value
            : this.customScheduledAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  TaskReminder copyWithCompanion(TaskRemindersCompanion data) {
    return TaskReminder(
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      notificationId: data.notificationId.present
          ? data.notificationId.value
          : this.notificationId,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      mode: data.mode.present ? data.mode.value : this.mode,
      hour: data.hour.present ? data.hour.value : this.hour,
      minute: data.minute.present ? data.minute.value : this.minute,
      customScheduledAt: data.customScheduledAt.present
          ? data.customScheduledAt.value
          : this.customScheduledAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskReminder(')
          ..write('taskId: $taskId, ')
          ..write('notificationId: $notificationId, ')
          ..write('enabled: $enabled, ')
          ..write('mode: $mode, ')
          ..write('hour: $hour, ')
          ..write('minute: $minute, ')
          ..write('customScheduledAt: $customScheduledAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(taskId, notificationId, enabled, mode, hour,
      minute, customScheduledAt, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskReminder &&
          other.taskId == this.taskId &&
          other.notificationId == this.notificationId &&
          other.enabled == this.enabled &&
          other.mode == this.mode &&
          other.hour == this.hour &&
          other.minute == this.minute &&
          other.customScheduledAt == this.customScheduledAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TaskRemindersCompanion extends UpdateCompanion<TaskReminder> {
  final Value<String> taskId;
  final Value<int> notificationId;
  final Value<bool> enabled;
  final Value<String> mode;
  final Value<int> hour;
  final Value<int> minute;
  final Value<DateTime?> customScheduledAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TaskRemindersCompanion({
    this.taskId = const Value.absent(),
    this.notificationId = const Value.absent(),
    this.enabled = const Value.absent(),
    this.mode = const Value.absent(),
    this.hour = const Value.absent(),
    this.minute = const Value.absent(),
    this.customScheduledAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskRemindersCompanion.insert({
    required String taskId,
    required int notificationId,
    required bool enabled,
    required String mode,
    required int hour,
    required int minute,
    this.customScheduledAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : taskId = Value(taskId),
        notificationId = Value(notificationId),
        enabled = Value(enabled),
        mode = Value(mode),
        hour = Value(hour),
        minute = Value(minute),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<TaskReminder> custom({
    Expression<String>? taskId,
    Expression<int>? notificationId,
    Expression<bool>? enabled,
    Expression<String>? mode,
    Expression<int>? hour,
    Expression<int>? minute,
    Expression<DateTime>? customScheduledAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (taskId != null) 'task_id': taskId,
      if (notificationId != null) 'notification_id': notificationId,
      if (enabled != null) 'enabled': enabled,
      if (mode != null) 'mode': mode,
      if (hour != null) 'hour': hour,
      if (minute != null) 'minute': minute,
      if (customScheduledAt != null) 'custom_scheduled_at': customScheduledAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskRemindersCompanion copyWith(
      {Value<String>? taskId,
      Value<int>? notificationId,
      Value<bool>? enabled,
      Value<String>? mode,
      Value<int>? hour,
      Value<int>? minute,
      Value<DateTime?>? customScheduledAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return TaskRemindersCompanion(
      taskId: taskId ?? this.taskId,
      notificationId: notificationId ?? this.notificationId,
      enabled: enabled ?? this.enabled,
      mode: mode ?? this.mode,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      customScheduledAt: customScheduledAt ?? this.customScheduledAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (notificationId.present) {
      map['notification_id'] = Variable<int>(notificationId.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (hour.present) {
      map['hour'] = Variable<int>(hour.value);
    }
    if (minute.present) {
      map['minute'] = Variable<int>(minute.value);
    }
    if (customScheduledAt.present) {
      map['custom_scheduled_at'] = Variable<DateTime>(customScheduledAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskRemindersCompanion(')
          ..write('taskId: $taskId, ')
          ..write('notificationId: $notificationId, ')
          ..write('enabled: $enabled, ')
          ..write('mode: $mode, ')
          ..write('hour: $hour, ')
          ..write('minute: $minute, ')
          ..write('customScheduledAt: $customScheduledAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
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
  late final $TandasTable tandas = $TandasTable(this);
  late final $TandaContributionsTable tandaContributions =
      $TandaContributionsTable(this);
  late final $TandaReceiptsTable tandaReceipts = $TandaReceiptsTable(this);
  late final $TaskRemindersTable taskReminders = $TaskRemindersTable(this);
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
        financialTaskOverrides,
        tandas,
        tandaContributions,
        tandaReceipts,
        taskReminders
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('tandas',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('tanda_contributions', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('tandas',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('tanda_receipts', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
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
typedef $$TandasTableCreateCompanionBuilder = TandasCompanion Function({
  required String id,
  required String name,
  required double contributionAmount,
  required String frequency,
  required DateTime startDate,
  required int participantCount,
  required int assignedTurn,
  required int completedContributions,
  required String status,
  Value<String?> notes,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$TandasTableUpdateCompanionBuilder = TandasCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<double> contributionAmount,
  Value<String> frequency,
  Value<DateTime> startDate,
  Value<int> participantCount,
  Value<int> assignedTurn,
  Value<int> completedContributions,
  Value<String> status,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$TandasTableReferences
    extends BaseReferences<_$AppDatabase, $TandasTable, Tanda> {
  $$TandasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TandaContributionsTable, List<TandaContribution>>
      _tandaContributionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.tandaContributions,
              aliasName: $_aliasNameGenerator(
                  db.tandas.id, db.tandaContributions.tandaId));

  $$TandaContributionsTableProcessedTableManager get tandaContributionsRefs {
    final manager =
        $$TandaContributionsTableTableManager($_db, $_db.tandaContributions)
            .filter((f) => f.tandaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_tandaContributionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TandaReceiptsTable, List<TandaReceipt>>
      _tandaReceiptsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.tandaReceipts,
              aliasName:
                  $_aliasNameGenerator(db.tandas.id, db.tandaReceipts.tandaId));

  $$TandaReceiptsTableProcessedTableManager get tandaReceiptsRefs {
    final manager = $$TandaReceiptsTableTableManager($_db, $_db.tandaReceipts)
        .filter((f) => f.tandaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tandaReceiptsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$TandasTableFilterComposer
    extends Composer<_$AppDatabase, $TandasTable> {
  $$TandasTableFilterComposer({
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

  ColumnFilters<double> get contributionAmount => $composableBuilder(
      column: $table.contributionAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get frequency => $composableBuilder(
      column: $table.frequency, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get participantCount => $composableBuilder(
      column: $table.participantCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get assignedTurn => $composableBuilder(
      column: $table.assignedTurn, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get completedContributions => $composableBuilder(
      column: $table.completedContributions,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> tandaContributionsRefs(
      Expression<bool> Function($$TandaContributionsTableFilterComposer f) f) {
    final $$TandaContributionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.tandaContributions,
        getReferencedColumn: (t) => t.tandaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TandaContributionsTableFilterComposer(
              $db: $db,
              $table: $db.tandaContributions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> tandaReceiptsRefs(
      Expression<bool> Function($$TandaReceiptsTableFilterComposer f) f) {
    final $$TandaReceiptsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.tandaReceipts,
        getReferencedColumn: (t) => t.tandaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TandaReceiptsTableFilterComposer(
              $db: $db,
              $table: $db.tandaReceipts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TandasTableOrderingComposer
    extends Composer<_$AppDatabase, $TandasTable> {
  $$TandasTableOrderingComposer({
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

  ColumnOrderings<double> get contributionAmount => $composableBuilder(
      column: $table.contributionAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get frequency => $composableBuilder(
      column: $table.frequency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get participantCount => $composableBuilder(
      column: $table.participantCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get assignedTurn => $composableBuilder(
      column: $table.assignedTurn,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get completedContributions => $composableBuilder(
      column: $table.completedContributions,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$TandasTableAnnotationComposer
    extends Composer<_$AppDatabase, $TandasTable> {
  $$TandasTableAnnotationComposer({
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

  GeneratedColumn<double> get contributionAmount => $composableBuilder(
      column: $table.contributionAmount, builder: (column) => column);

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<int> get participantCount => $composableBuilder(
      column: $table.participantCount, builder: (column) => column);

  GeneratedColumn<int> get assignedTurn => $composableBuilder(
      column: $table.assignedTurn, builder: (column) => column);

  GeneratedColumn<int> get completedContributions => $composableBuilder(
      column: $table.completedContributions, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> tandaContributionsRefs<T extends Object>(
      Expression<T> Function($$TandaContributionsTableAnnotationComposer a) f) {
    final $$TandaContributionsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.tandaContributions,
            getReferencedColumn: (t) => t.tandaId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$TandaContributionsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.tandaContributions,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> tandaReceiptsRefs<T extends Object>(
      Expression<T> Function($$TandaReceiptsTableAnnotationComposer a) f) {
    final $$TandaReceiptsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.tandaReceipts,
        getReferencedColumn: (t) => t.tandaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TandaReceiptsTableAnnotationComposer(
              $db: $db,
              $table: $db.tandaReceipts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TandasTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TandasTable,
    Tanda,
    $$TandasTableFilterComposer,
    $$TandasTableOrderingComposer,
    $$TandasTableAnnotationComposer,
    $$TandasTableCreateCompanionBuilder,
    $$TandasTableUpdateCompanionBuilder,
    (Tanda, $$TandasTableReferences),
    Tanda,
    PrefetchHooks Function(
        {bool tandaContributionsRefs, bool tandaReceiptsRefs})> {
  $$TandasTableTableManager(_$AppDatabase db, $TandasTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TandasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TandasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TandasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> contributionAmount = const Value.absent(),
            Value<String> frequency = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<int> participantCount = const Value.absent(),
            Value<int> assignedTurn = const Value.absent(),
            Value<int> completedContributions = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TandasCompanion(
            id: id,
            name: name,
            contributionAmount: contributionAmount,
            frequency: frequency,
            startDate: startDate,
            participantCount: participantCount,
            assignedTurn: assignedTurn,
            completedContributions: completedContributions,
            status: status,
            notes: notes,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required double contributionAmount,
            required String frequency,
            required DateTime startDate,
            required int participantCount,
            required int assignedTurn,
            required int completedContributions,
            required String status,
            Value<String?> notes = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              TandasCompanion.insert(
            id: id,
            name: name,
            contributionAmount: contributionAmount,
            frequency: frequency,
            startDate: startDate,
            participantCount: participantCount,
            assignedTurn: assignedTurn,
            completedContributions: completedContributions,
            status: status,
            notes: notes,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$TandasTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {tandaContributionsRefs = false, tandaReceiptsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (tandaContributionsRefs) db.tandaContributions,
                if (tandaReceiptsRefs) db.tandaReceipts
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (tandaContributionsRefs)
                    await $_getPrefetchedData<Tanda, $TandasTable,
                            TandaContribution>(
                        currentTable: table,
                        referencedTable: $$TandasTableReferences
                            ._tandaContributionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TandasTableReferences(db, table, p0)
                                .tandaContributionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.tandaId == item.id),
                        typedResults: items),
                  if (tandaReceiptsRefs)
                    await $_getPrefetchedData<Tanda, $TandasTable,
                            TandaReceipt>(
                        currentTable: table,
                        referencedTable:
                            $$TandasTableReferences._tandaReceiptsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TandasTableReferences(db, table, p0)
                                .tandaReceiptsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.tandaId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$TandasTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TandasTable,
    Tanda,
    $$TandasTableFilterComposer,
    $$TandasTableOrderingComposer,
    $$TandasTableAnnotationComposer,
    $$TandasTableCreateCompanionBuilder,
    $$TandasTableUpdateCompanionBuilder,
    (Tanda, $$TandasTableReferences),
    Tanda,
    PrefetchHooks Function(
        {bool tandaContributionsRefs, bool tandaReceiptsRefs})>;
typedef $$TandaContributionsTableCreateCompanionBuilder
    = TandaContributionsCompanion Function({
  required String id,
  required String tandaId,
  required int sequenceNumber,
  required double amount,
  required DateTime scheduledDate,
  required String status,
  Value<DateTime?> paidAt,
  required DateTime createdAt,
  Value<bool> migratedFromLegacyCounter,
  Value<String?> notes,
  Value<String?> linkedTransactionId,
  Value<int> rowid,
});
typedef $$TandaContributionsTableUpdateCompanionBuilder
    = TandaContributionsCompanion Function({
  Value<String> id,
  Value<String> tandaId,
  Value<int> sequenceNumber,
  Value<double> amount,
  Value<DateTime> scheduledDate,
  Value<String> status,
  Value<DateTime?> paidAt,
  Value<DateTime> createdAt,
  Value<bool> migratedFromLegacyCounter,
  Value<String?> notes,
  Value<String?> linkedTransactionId,
  Value<int> rowid,
});

final class $$TandaContributionsTableReferences extends BaseReferences<
    _$AppDatabase, $TandaContributionsTable, TandaContribution> {
  $$TandaContributionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $TandasTable _tandaIdTable(_$AppDatabase db) => db.tandas.createAlias(
      $_aliasNameGenerator(db.tandaContributions.tandaId, db.tandas.id));

  $$TandasTableProcessedTableManager get tandaId {
    final $_column = $_itemColumn<String>('tanda_id')!;

    final manager = $$TandasTableTableManager($_db, $_db.tandas)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tandaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TandaContributionsTableFilterComposer
    extends Composer<_$AppDatabase, $TandaContributionsTable> {
  $$TandaContributionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sequenceNumber => $composableBuilder(
      column: $table.sequenceNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get scheduledDate => $composableBuilder(
      column: $table.scheduledDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get paidAt => $composableBuilder(
      column: $table.paidAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get migratedFromLegacyCounter => $composableBuilder(
      column: $table.migratedFromLegacyCounter,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get linkedTransactionId => $composableBuilder(
      column: $table.linkedTransactionId,
      builder: (column) => ColumnFilters(column));

  $$TandasTableFilterComposer get tandaId {
    final $$TandasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tandaId,
        referencedTable: $db.tandas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TandasTableFilterComposer(
              $db: $db,
              $table: $db.tandas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TandaContributionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TandaContributionsTable> {
  $$TandaContributionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sequenceNumber => $composableBuilder(
      column: $table.sequenceNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get scheduledDate => $composableBuilder(
      column: $table.scheduledDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get paidAt => $composableBuilder(
      column: $table.paidAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get migratedFromLegacyCounter => $composableBuilder(
      column: $table.migratedFromLegacyCounter,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get linkedTransactionId => $composableBuilder(
      column: $table.linkedTransactionId,
      builder: (column) => ColumnOrderings(column));

  $$TandasTableOrderingComposer get tandaId {
    final $$TandasTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tandaId,
        referencedTable: $db.tandas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TandasTableOrderingComposer(
              $db: $db,
              $table: $db.tandas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TandaContributionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TandaContributionsTable> {
  $$TandaContributionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sequenceNumber => $composableBuilder(
      column: $table.sequenceNumber, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledDate => $composableBuilder(
      column: $table.scheduledDate, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get paidAt =>
      $composableBuilder(column: $table.paidAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get migratedFromLegacyCounter => $composableBuilder(
      column: $table.migratedFromLegacyCounter, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get linkedTransactionId => $composableBuilder(
      column: $table.linkedTransactionId, builder: (column) => column);

  $$TandasTableAnnotationComposer get tandaId {
    final $$TandasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tandaId,
        referencedTable: $db.tandas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TandasTableAnnotationComposer(
              $db: $db,
              $table: $db.tandas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TandaContributionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TandaContributionsTable,
    TandaContribution,
    $$TandaContributionsTableFilterComposer,
    $$TandaContributionsTableOrderingComposer,
    $$TandaContributionsTableAnnotationComposer,
    $$TandaContributionsTableCreateCompanionBuilder,
    $$TandaContributionsTableUpdateCompanionBuilder,
    (TandaContribution, $$TandaContributionsTableReferences),
    TandaContribution,
    PrefetchHooks Function({bool tandaId})> {
  $$TandaContributionsTableTableManager(
      _$AppDatabase db, $TandaContributionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TandaContributionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TandaContributionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TandaContributionsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> tandaId = const Value.absent(),
            Value<int> sequenceNumber = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<DateTime> scheduledDate = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime?> paidAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> migratedFromLegacyCounter = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> linkedTransactionId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TandaContributionsCompanion(
            id: id,
            tandaId: tandaId,
            sequenceNumber: sequenceNumber,
            amount: amount,
            scheduledDate: scheduledDate,
            status: status,
            paidAt: paidAt,
            createdAt: createdAt,
            migratedFromLegacyCounter: migratedFromLegacyCounter,
            notes: notes,
            linkedTransactionId: linkedTransactionId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String tandaId,
            required int sequenceNumber,
            required double amount,
            required DateTime scheduledDate,
            required String status,
            Value<DateTime?> paidAt = const Value.absent(),
            required DateTime createdAt,
            Value<bool> migratedFromLegacyCounter = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> linkedTransactionId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TandaContributionsCompanion.insert(
            id: id,
            tandaId: tandaId,
            sequenceNumber: sequenceNumber,
            amount: amount,
            scheduledDate: scheduledDate,
            status: status,
            paidAt: paidAt,
            createdAt: createdAt,
            migratedFromLegacyCounter: migratedFromLegacyCounter,
            notes: notes,
            linkedTransactionId: linkedTransactionId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TandaContributionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({tandaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (tandaId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.tandaId,
                    referencedTable:
                        $$TandaContributionsTableReferences._tandaIdTable(db),
                    referencedColumn: $$TandaContributionsTableReferences
                        ._tandaIdTable(db)
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
        ));
}

typedef $$TandaContributionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TandaContributionsTable,
    TandaContribution,
    $$TandaContributionsTableFilterComposer,
    $$TandaContributionsTableOrderingComposer,
    $$TandaContributionsTableAnnotationComposer,
    $$TandaContributionsTableCreateCompanionBuilder,
    $$TandaContributionsTableUpdateCompanionBuilder,
    (TandaContribution, $$TandaContributionsTableReferences),
    TandaContribution,
    PrefetchHooks Function({bool tandaId})>;
typedef $$TandaReceiptsTableCreateCompanionBuilder = TandaReceiptsCompanion
    Function({
  required String id,
  required String tandaId,
  required double amount,
  required DateTime scheduledDate,
  required String status,
  Value<DateTime?> receivedAt,
  Value<String?> linkedTransactionId,
  required DateTime createdAt,
  Value<String?> notes,
  Value<int> rowid,
});
typedef $$TandaReceiptsTableUpdateCompanionBuilder = TandaReceiptsCompanion
    Function({
  Value<String> id,
  Value<String> tandaId,
  Value<double> amount,
  Value<DateTime> scheduledDate,
  Value<String> status,
  Value<DateTime?> receivedAt,
  Value<String?> linkedTransactionId,
  Value<DateTime> createdAt,
  Value<String?> notes,
  Value<int> rowid,
});

final class $$TandaReceiptsTableReferences
    extends BaseReferences<_$AppDatabase, $TandaReceiptsTable, TandaReceipt> {
  $$TandaReceiptsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $TandasTable _tandaIdTable(_$AppDatabase db) => db.tandas.createAlias(
      $_aliasNameGenerator(db.tandaReceipts.tandaId, db.tandas.id));

  $$TandasTableProcessedTableManager get tandaId {
    final $_column = $_itemColumn<String>('tanda_id')!;

    final manager = $$TandasTableTableManager($_db, $_db.tandas)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tandaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TandaReceiptsTableFilterComposer
    extends Composer<_$AppDatabase, $TandaReceiptsTable> {
  $$TandaReceiptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get scheduledDate => $composableBuilder(
      column: $table.scheduledDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get receivedAt => $composableBuilder(
      column: $table.receivedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get linkedTransactionId => $composableBuilder(
      column: $table.linkedTransactionId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  $$TandasTableFilterComposer get tandaId {
    final $$TandasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tandaId,
        referencedTable: $db.tandas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TandasTableFilterComposer(
              $db: $db,
              $table: $db.tandas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TandaReceiptsTableOrderingComposer
    extends Composer<_$AppDatabase, $TandaReceiptsTable> {
  $$TandaReceiptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get scheduledDate => $composableBuilder(
      column: $table.scheduledDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get receivedAt => $composableBuilder(
      column: $table.receivedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get linkedTransactionId => $composableBuilder(
      column: $table.linkedTransactionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  $$TandasTableOrderingComposer get tandaId {
    final $$TandasTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tandaId,
        referencedTable: $db.tandas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TandasTableOrderingComposer(
              $db: $db,
              $table: $db.tandas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TandaReceiptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TandaReceiptsTable> {
  $$TandaReceiptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledDate => $composableBuilder(
      column: $table.scheduledDate, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get receivedAt => $composableBuilder(
      column: $table.receivedAt, builder: (column) => column);

  GeneratedColumn<String> get linkedTransactionId => $composableBuilder(
      column: $table.linkedTransactionId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$TandasTableAnnotationComposer get tandaId {
    final $$TandasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tandaId,
        referencedTable: $db.tandas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TandasTableAnnotationComposer(
              $db: $db,
              $table: $db.tandas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TandaReceiptsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TandaReceiptsTable,
    TandaReceipt,
    $$TandaReceiptsTableFilterComposer,
    $$TandaReceiptsTableOrderingComposer,
    $$TandaReceiptsTableAnnotationComposer,
    $$TandaReceiptsTableCreateCompanionBuilder,
    $$TandaReceiptsTableUpdateCompanionBuilder,
    (TandaReceipt, $$TandaReceiptsTableReferences),
    TandaReceipt,
    PrefetchHooks Function({bool tandaId})> {
  $$TandaReceiptsTableTableManager(_$AppDatabase db, $TandaReceiptsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TandaReceiptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TandaReceiptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TandaReceiptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> tandaId = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<DateTime> scheduledDate = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime?> receivedAt = const Value.absent(),
            Value<String?> linkedTransactionId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TandaReceiptsCompanion(
            id: id,
            tandaId: tandaId,
            amount: amount,
            scheduledDate: scheduledDate,
            status: status,
            receivedAt: receivedAt,
            linkedTransactionId: linkedTransactionId,
            createdAt: createdAt,
            notes: notes,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String tandaId,
            required double amount,
            required DateTime scheduledDate,
            required String status,
            Value<DateTime?> receivedAt = const Value.absent(),
            Value<String?> linkedTransactionId = const Value.absent(),
            required DateTime createdAt,
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TandaReceiptsCompanion.insert(
            id: id,
            tandaId: tandaId,
            amount: amount,
            scheduledDate: scheduledDate,
            status: status,
            receivedAt: receivedAt,
            linkedTransactionId: linkedTransactionId,
            createdAt: createdAt,
            notes: notes,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TandaReceiptsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({tandaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (tandaId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.tandaId,
                    referencedTable:
                        $$TandaReceiptsTableReferences._tandaIdTable(db),
                    referencedColumn:
                        $$TandaReceiptsTableReferences._tandaIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TandaReceiptsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TandaReceiptsTable,
    TandaReceipt,
    $$TandaReceiptsTableFilterComposer,
    $$TandaReceiptsTableOrderingComposer,
    $$TandaReceiptsTableAnnotationComposer,
    $$TandaReceiptsTableCreateCompanionBuilder,
    $$TandaReceiptsTableUpdateCompanionBuilder,
    (TandaReceipt, $$TandaReceiptsTableReferences),
    TandaReceipt,
    PrefetchHooks Function({bool tandaId})>;
typedef $$TaskRemindersTableCreateCompanionBuilder = TaskRemindersCompanion
    Function({
  required String taskId,
  required int notificationId,
  required bool enabled,
  required String mode,
  required int hour,
  required int minute,
  Value<DateTime?> customScheduledAt,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$TaskRemindersTableUpdateCompanionBuilder = TaskRemindersCompanion
    Function({
  Value<String> taskId,
  Value<int> notificationId,
  Value<bool> enabled,
  Value<String> mode,
  Value<int> hour,
  Value<int> minute,
  Value<DateTime?> customScheduledAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$TaskRemindersTableFilterComposer
    extends Composer<_$AppDatabase, $TaskRemindersTable> {
  $$TaskRemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get notificationId => $composableBuilder(
      column: $table.notificationId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mode => $composableBuilder(
      column: $table.mode, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hour => $composableBuilder(
      column: $table.hour, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get minute => $composableBuilder(
      column: $table.minute, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get customScheduledAt => $composableBuilder(
      column: $table.customScheduledAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$TaskRemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskRemindersTable> {
  $$TaskRemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get notificationId => $composableBuilder(
      column: $table.notificationId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mode => $composableBuilder(
      column: $table.mode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hour => $composableBuilder(
      column: $table.hour, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get minute => $composableBuilder(
      column: $table.minute, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get customScheduledAt => $composableBuilder(
      column: $table.customScheduledAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$TaskRemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskRemindersTable> {
  $$TaskRemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<int> get notificationId => $composableBuilder(
      column: $table.notificationId, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<int> get hour =>
      $composableBuilder(column: $table.hour, builder: (column) => column);

  GeneratedColumn<int> get minute =>
      $composableBuilder(column: $table.minute, builder: (column) => column);

  GeneratedColumn<DateTime> get customScheduledAt => $composableBuilder(
      column: $table.customScheduledAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TaskRemindersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TaskRemindersTable,
    TaskReminder,
    $$TaskRemindersTableFilterComposer,
    $$TaskRemindersTableOrderingComposer,
    $$TaskRemindersTableAnnotationComposer,
    $$TaskRemindersTableCreateCompanionBuilder,
    $$TaskRemindersTableUpdateCompanionBuilder,
    (
      TaskReminder,
      BaseReferences<_$AppDatabase, $TaskRemindersTable, TaskReminder>
    ),
    TaskReminder,
    PrefetchHooks Function()> {
  $$TaskRemindersTableTableManager(_$AppDatabase db, $TaskRemindersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskRemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskRemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskRemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> taskId = const Value.absent(),
            Value<int> notificationId = const Value.absent(),
            Value<bool> enabled = const Value.absent(),
            Value<String> mode = const Value.absent(),
            Value<int> hour = const Value.absent(),
            Value<int> minute = const Value.absent(),
            Value<DateTime?> customScheduledAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TaskRemindersCompanion(
            taskId: taskId,
            notificationId: notificationId,
            enabled: enabled,
            mode: mode,
            hour: hour,
            minute: minute,
            customScheduledAt: customScheduledAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String taskId,
            required int notificationId,
            required bool enabled,
            required String mode,
            required int hour,
            required int minute,
            Value<DateTime?> customScheduledAt = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              TaskRemindersCompanion.insert(
            taskId: taskId,
            notificationId: notificationId,
            enabled: enabled,
            mode: mode,
            hour: hour,
            minute: minute,
            customScheduledAt: customScheduledAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TaskRemindersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TaskRemindersTable,
    TaskReminder,
    $$TaskRemindersTableFilterComposer,
    $$TaskRemindersTableOrderingComposer,
    $$TaskRemindersTableAnnotationComposer,
    $$TaskRemindersTableCreateCompanionBuilder,
    $$TaskRemindersTableUpdateCompanionBuilder,
    (
      TaskReminder,
      BaseReferences<_$AppDatabase, $TaskRemindersTable, TaskReminder>
    ),
    TaskReminder,
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
  $$TandasTableTableManager get tandas =>
      $$TandasTableTableManager(_db, _db.tandas);
  $$TandaContributionsTableTableManager get tandaContributions =>
      $$TandaContributionsTableTableManager(_db, _db.tandaContributions);
  $$TandaReceiptsTableTableManager get tandaReceipts =>
      $$TandaReceiptsTableTableManager(_db, _db.tandaReceipts);
  $$TaskRemindersTableTableManager get taskReminders =>
      $$TaskRemindersTableTableManager(_db, _db.taskReminders);
}
