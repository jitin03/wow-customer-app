import 'dart:io';

import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getExternalStorageDirectory();
    final file = File('${dir!.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;
    print(url);

    File file1 = File(url);

    if (file1.existsSync()) {
      print("File exists at $url");
    } else {
      print("File does not exist at $url");
    }
    await OpenFile.open(url);

    print('done');
  }
}

