import 'package:flutter/material.dart';
import 'package:one_wallet/app/database/database.dart';
import 'package:one_wallet/app/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:csv/csv.dart';
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' as dr;

class CsvLogic {
  static Future<List<List<dynamic>>> loadCSV(BuildContext context) async {
    AppDatabase database = Provider.of<AppDatabase>(context, listen: false);
    String path = '/storage/emulated/0/OneWallet/cards.csv';
    List<List<dynamic>> loadedCsv = [];
    final newFile = File(path);

    if (await newFile.exists()) {
      final file = newFile.openRead();

      loadedCsv = await file
          .transform(utf8.decoder)
          .transform(const CsvToListConverter())
          .toList();
      if (loadedCsv.length > 1) {
        for (var i = 1; i < loadedCsv.length; i++) {
          database.insertCard(CardCompanion(
            bankName: dr.Value(loadedCsv[i][1].toString()),
            cardNumber: dr.Value(loadedCsv[i][2].toString()),
            expiryDate: dr.Value(loadedCsv[i][3].toString()),
            cardHolderName: dr.Value(loadedCsv[i][4].toString()),
            cvvCode: dr.Value(loadedCsv[i][5].toString()),
            cardType: dr.Value(loadedCsv[i][6].toString()),
          ));
        }
        Utils.scaffoldMessengerSnackBar(context, 'Data Imported Succesfully');
      } else {
        Utils.scaffoldMessengerSnackBar(context, 'No data to import');
      }
    } else {
      Utils.scaffoldMessengerSnackBar(context, 'No data to import');
    }

    return loadedCsv;
  }

  static Future<void> generateCSV(BuildContext context) async {
    AppDatabase database = Provider.of<AppDatabase>(context, listen: false);
    List<CardData> cards = await database.allCards;
    List<List<String>> csvData = [
      [
        'id',
        'Bank Name',
        'Card Number',
        'Expiry Date',
        'Card Holder Name',
        'CVV code',
        'Card Type'
      ],
      ...cards.map((item) => [
            item.id.toString(),
            item.bankName,
            item.cardNumber,
            item.expiryDate,
            item.cardHolderName,
            item.cvvCode,
            item.cardType ?? 'Unknown'
          ]),
    ];

    String csv = const ListToCsvConverter().convert(csvData);

    await Permission.manageExternalStorage.request();

    Directory directory = (await getExternalStorageDirectory())!;
    String fileName = 'cards.csv';
    String newPath = '';

    List<String> paths = directory.path.split('/');

    for (var i = 1; i < paths.length; i++) {
      String currentFolder = paths[i];
      if (currentFolder != 'Android') {
        newPath += '/' + currentFolder;
      } else {
        break;
      }
    }

    newPath = newPath + '/OneWallet';

    directory = Directory(newPath);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    if (await directory.exists()) {
      final File file = File(directory.path + '/$fileName');
      await file.writeAsString(csv).then((value) => Utils.scaffoldMessengerSnackBar(
          context,
          'Data exported successfully to storage/emulated/0/OneWallet/cards.csv'));
    }
  }
}
