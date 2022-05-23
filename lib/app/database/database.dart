import 'package:drift/drift.dart';
// These imports are only needed to open the database
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'database.g.dart';

class Card extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get bankName => text()();
  TextColumn get cardNumber => text()();
  TextColumn get expiryDate => text()();
  TextColumn get cardHolderName => text()();
  TextColumn get cvvCode => text()();
  TextColumn get cardType => text().nullable()();
}

@DriftDatabase(tables: [Card])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<CardData>> get allCards => select(card).get();

  Stream<List<CardData>> watchEntriesInCard() {
    return select(card).watch();
  }

  Future<int> insertCard(CardCompanion cardCompanion) async {
    return await into(card).insert(cardCompanion);
  }

  Future<int> deleteCard(CardData cardData) {
    return delete(card).delete(cardData);
  }

  Future<bool> updateCard(CardData cardData) {
    return update(card).replace(cardData);
  }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
