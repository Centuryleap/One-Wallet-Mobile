// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class CardData extends DataClass implements Insertable<CardData> {
  final int id;
  final String bankName;
  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;
  final String? cardType;
  CardData(
      {required this.id,
      required this.bankName,
      required this.cardNumber,
      required this.expiryDate,
      required this.cardHolderName,
      required this.cvvCode,
      this.cardType});
  factory CardData.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return CardData(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      bankName: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}bank_name'])!,
      cardNumber: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}card_number'])!,
      expiryDate: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}expiry_date'])!,
      cardHolderName: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}card_holder_name'])!,
      cvvCode: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cvv_code'])!,
      cardType: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}card_type']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['bank_name'] = Variable<String>(bankName);
    map['card_number'] = Variable<String>(cardNumber);
    map['expiry_date'] = Variable<String>(expiryDate);
    map['card_holder_name'] = Variable<String>(cardHolderName);
    map['cvv_code'] = Variable<String>(cvvCode);
    if (!nullToAbsent || cardType != null) {
      map['card_type'] = Variable<String?>(cardType);
    }
    return map;
  }

  CardCompanion toCompanion(bool nullToAbsent) {
    return CardCompanion(
      id: Value(id),
      bankName: Value(bankName),
      cardNumber: Value(cardNumber),
      expiryDate: Value(expiryDate),
      cardHolderName: Value(cardHolderName),
      cvvCode: Value(cvvCode),
      cardType: cardType == null && nullToAbsent
          ? const Value.absent()
          : Value(cardType),
    );
  }

  factory CardData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardData(
      id: serializer.fromJson<int>(json['id']),
      bankName: serializer.fromJson<String>(json['bankName']),
      cardNumber: serializer.fromJson<String>(json['cardNumber']),
      expiryDate: serializer.fromJson<String>(json['expiryDate']),
      cardHolderName: serializer.fromJson<String>(json['cardHolderName']),
      cvvCode: serializer.fromJson<String>(json['cvvCode']),
      cardType: serializer.fromJson<String?>(json['cardType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bankName': serializer.toJson<String>(bankName),
      'cardNumber': serializer.toJson<String>(cardNumber),
      'expiryDate': serializer.toJson<String>(expiryDate),
      'cardHolderName': serializer.toJson<String>(cardHolderName),
      'cvvCode': serializer.toJson<String>(cvvCode),
      'cardType': serializer.toJson<String?>(cardType),
    };
  }

  CardData copyWith(
          {int? id,
          String? bankName,
          String? cardNumber,
          String? expiryDate,
          String? cardHolderName,
          String? cvvCode,
          String? cardType}) =>
      CardData(
        id: id ?? this.id,
        bankName: bankName ?? this.bankName,
        cardNumber: cardNumber ?? this.cardNumber,
        expiryDate: expiryDate ?? this.expiryDate,
        cardHolderName: cardHolderName ?? this.cardHolderName,
        cvvCode: cvvCode ?? this.cvvCode,
        cardType: cardType ?? this.cardType,
      );
  @override
  String toString() {
    return (StringBuffer('CardData(')
          ..write('id: $id, ')
          ..write('bankName: $bankName, ')
          ..write('cardNumber: $cardNumber, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('cardHolderName: $cardHolderName, ')
          ..write('cvvCode: $cvvCode, ')
          ..write('cardType: $cardType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, bankName, cardNumber, expiryDate, cardHolderName, cvvCode, cardType);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardData &&
          other.id == this.id &&
          other.bankName == this.bankName &&
          other.cardNumber == this.cardNumber &&
          other.expiryDate == this.expiryDate &&
          other.cardHolderName == this.cardHolderName &&
          other.cvvCode == this.cvvCode &&
          other.cardType == this.cardType);
}

class CardCompanion extends UpdateCompanion<CardData> {
  final Value<int> id;
  final Value<String> bankName;
  final Value<String> cardNumber;
  final Value<String> expiryDate;
  final Value<String> cardHolderName;
  final Value<String> cvvCode;
  final Value<String?> cardType;
  const CardCompanion({
    this.id = const Value.absent(),
    this.bankName = const Value.absent(),
    this.cardNumber = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.cardHolderName = const Value.absent(),
    this.cvvCode = const Value.absent(),
    this.cardType = const Value.absent(),
  });
  CardCompanion.insert({
    this.id = const Value.absent(),
    required String bankName,
    required String cardNumber,
    required String expiryDate,
    required String cardHolderName,
    required String cvvCode,
    this.cardType = const Value.absent(),
  })  : bankName = Value(bankName),
        cardNumber = Value(cardNumber),
        expiryDate = Value(expiryDate),
        cardHolderName = Value(cardHolderName),
        cvvCode = Value(cvvCode);
  static Insertable<CardData> custom({
    Expression<int>? id,
    Expression<String>? bankName,
    Expression<String>? cardNumber,
    Expression<String>? expiryDate,
    Expression<String>? cardHolderName,
    Expression<String>? cvvCode,
    Expression<String?>? cardType,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bankName != null) 'bank_name': bankName,
      if (cardNumber != null) 'card_number': cardNumber,
      if (expiryDate != null) 'expiry_date': expiryDate,
      if (cardHolderName != null) 'card_holder_name': cardHolderName,
      if (cvvCode != null) 'cvv_code': cvvCode,
      if (cardType != null) 'card_type': cardType,
    });
  }

  CardCompanion copyWith(
      {Value<int>? id,
      Value<String>? bankName,
      Value<String>? cardNumber,
      Value<String>? expiryDate,
      Value<String>? cardHolderName,
      Value<String>? cvvCode,
      Value<String?>? cardType}) {
    return CardCompanion(
      id: id ?? this.id,
      bankName: bankName ?? this.bankName,
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      cvvCode: cvvCode ?? this.cvvCode,
      cardType: cardType ?? this.cardType,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bankName.present) {
      map['bank_name'] = Variable<String>(bankName.value);
    }
    if (cardNumber.present) {
      map['card_number'] = Variable<String>(cardNumber.value);
    }
    if (expiryDate.present) {
      map['expiry_date'] = Variable<String>(expiryDate.value);
    }
    if (cardHolderName.present) {
      map['card_holder_name'] = Variable<String>(cardHolderName.value);
    }
    if (cvvCode.present) {
      map['cvv_code'] = Variable<String>(cvvCode.value);
    }
    if (cardType.present) {
      map['card_type'] = Variable<String?>(cardType.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardCompanion(')
          ..write('id: $id, ')
          ..write('bankName: $bankName, ')
          ..write('cardNumber: $cardNumber, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('cardHolderName: $cardHolderName, ')
          ..write('cvvCode: $cvvCode, ')
          ..write('cardType: $cardType')
          ..write(')'))
        .toString();
  }
}

class $CardTable extends Card with TableInfo<$CardTable, CardData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _bankNameMeta = const VerificationMeta('bankName');
  @override
  late final GeneratedColumn<String?> bankName = GeneratedColumn<String?>(
      'bank_name', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _cardNumberMeta = const VerificationMeta('cardNumber');
  @override
  late final GeneratedColumn<String?> cardNumber = GeneratedColumn<String?>(
      'card_number', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _expiryDateMeta = const VerificationMeta('expiryDate');
  @override
  late final GeneratedColumn<String?> expiryDate = GeneratedColumn<String?>(
      'expiry_date', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _cardHolderNameMeta =
      const VerificationMeta('cardHolderName');
  @override
  late final GeneratedColumn<String?> cardHolderName = GeneratedColumn<String?>(
      'card_holder_name', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _cvvCodeMeta = const VerificationMeta('cvvCode');
  @override
  late final GeneratedColumn<String?> cvvCode = GeneratedColumn<String?>(
      'cvv_code', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _cardTypeMeta = const VerificationMeta('cardType');
  @override
  late final GeneratedColumn<String?> cardType = GeneratedColumn<String?>(
      'card_type', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, bankName, cardNumber, expiryDate, cardHolderName, cvvCode, cardType];
  @override
  String get aliasedName => _alias ?? 'card';
  @override
  String get actualTableName => 'card';
  @override
  VerificationContext validateIntegrity(Insertable<CardData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bank_name')) {
      context.handle(_bankNameMeta,
          bankName.isAcceptableOrUnknown(data['bank_name']!, _bankNameMeta));
    } else if (isInserting) {
      context.missing(_bankNameMeta);
    }
    if (data.containsKey('card_number')) {
      context.handle(
          _cardNumberMeta,
          cardNumber.isAcceptableOrUnknown(
              data['card_number']!, _cardNumberMeta));
    } else if (isInserting) {
      context.missing(_cardNumberMeta);
    }
    if (data.containsKey('expiry_date')) {
      context.handle(
          _expiryDateMeta,
          expiryDate.isAcceptableOrUnknown(
              data['expiry_date']!, _expiryDateMeta));
    } else if (isInserting) {
      context.missing(_expiryDateMeta);
    }
    if (data.containsKey('card_holder_name')) {
      context.handle(
          _cardHolderNameMeta,
          cardHolderName.isAcceptableOrUnknown(
              data['card_holder_name']!, _cardHolderNameMeta));
    } else if (isInserting) {
      context.missing(_cardHolderNameMeta);
    }
    if (data.containsKey('cvv_code')) {
      context.handle(_cvvCodeMeta,
          cvvCode.isAcceptableOrUnknown(data['cvv_code']!, _cvvCodeMeta));
    } else if (isInserting) {
      context.missing(_cvvCodeMeta);
    }
    if (data.containsKey('card_type')) {
      context.handle(_cardTypeMeta,
          cardType.isAcceptableOrUnknown(data['card_type']!, _cardTypeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return CardData.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $CardTable createAlias(String alias) {
    return $CardTable(attachedDatabase, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $CardTable card = $CardTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [card];
}
