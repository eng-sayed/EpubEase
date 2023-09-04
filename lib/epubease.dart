library epubease;

import 'dart:async';

import 'package:epubease/src/Model/last_place_model.dart';
import 'package:epubease/src/core/utils/chapters_counter.dart';
import 'package:epubx/epubx.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/services.dart' show rootBundle;

import 'epubease.dart';

export 'src/Pages/epub_display.dart';

/// A Calculator.
class Epubease {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<void> openAsset(
    String assetpath,
    BuildContext context, {
    required LastPlaceModel lastPlace,
    required List<LastPlaceModel> chapters,
    required Function(double percent) onClose,
  }) async {
    var bytes = await rootBundle.load(assetpath);

    EpubBook epubBook = await EpubReader.readBook(bytes.buffer.asUint8List());

    String htmlcontent = '';
    Map<String, EpubTextContentFile> htmlFiles = epubBook.Content!.Html!;

    for (var htmlFile in htmlFiles.values) {
      htmlcontent = htmlcontent + htmlFile.Content!;
    }

    final countedChapters =
        ChaptersCounter().countChapters(epubBook.Chapters ?? []);
    final chaptersPercentages = chapters.isEmpty ? countedChapters : chapters;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final percent = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return ShowEpub(
              html1: htmlcontent,
              epubBook: epubBook,
              lastPlace: lastPlace,
              chaptersPercentages: chaptersPercentages,
            );
          },
        ),
      );
      onClose(percent);
    });
  }

  static Future<void> open(
    String bookurl,
    BuildContext context, {
    required LastPlaceModel lastPlace,
    required List<LastPlaceModel> chapters,
    required Function(double percent) onClose,
  }) async {
    final response = await http.get(Uri.parse(bookurl));
    if (response.statusCode == 200) {
      final epubData = response.bodyBytes;

      // Load the EPUB from memory
      EpubBook epubBook = await EpubReader.readBook(epubData);

      String htmlcontent = '';
      Map<String, EpubTextContentFile> htmlFiles = epubBook.Content!.Html!;

      for (var htmlFile in htmlFiles.values) {
        htmlcontent = htmlcontent + htmlFile.Content!;
      }

      final countedChapters =
          ChaptersCounter().countChapters(epubBook.Chapters ?? []);
      final chaptersPercentages = chapters.isEmpty ? countedChapters : chapters;

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        final percent = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ShowEpub(
                html1: htmlcontent,
                epubBook: epubBook,
                lastPlace: lastPlace,
                chaptersPercentages: chaptersPercentages,
              );
            },
          ),
        );
        onClose(percent);
      });
    }
  }
}
