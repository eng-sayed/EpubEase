library epubease;

import 'dart:async';

import 'package:epubease/src/Model/last_place_model.dart';
import 'package:epubease/src/Model/reader_result.dart';
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
    required LastPlaceModel? lastPlace,
    required List<LastPlaceModel>? chapters,
    required Function(ReaderResult result) onClose,
  }) async {
    var bytes = await rootBundle.load(assetpath);

    EpubBook epubBook = await EpubReader.readBook(bytes.buffer.asUint8List());

    String htmlcontent = '';
    Map<String, EpubTextContentFile> htmlFiles = epubBook.Content!.Html!;

    for (var htmlFile in htmlFiles.values) {
      htmlcontent = htmlcontent + htmlFile.Content!;
    }

    final chaptersPercentages =
        dealWithChapters(chapters, epubBook.Chapters ?? []);
    final realLastPlace = dealWithLastPlace(chaptersPercentages, lastPlace);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return ShowEpub(
              html1: htmlcontent,
              epubBook: epubBook,
              lastPlace: realLastPlace,
              chaptersPercentages: chaptersPercentages,
            );
          },
        ),
      );
      onClose(result);
    });
  }

  static Future<void> open(
    String bookurl,
    BuildContext context, {
    required LastPlaceModel? lastPlace,
    required List<LastPlaceModel>? chapters,
    required Function(ReaderResult result) onClose,
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

      final chaptersPercentages =
          dealWithChapters(chapters, epubBook.Chapters ?? []);
      final realLastPlace = dealWithLastPlace(chaptersPercentages, lastPlace);

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ShowEpub(
                html1: htmlcontent,
                epubBook: epubBook,
                lastPlace: realLastPlace,
                chaptersPercentages: chaptersPercentages,
              );
            },
          ),
        );
        onClose(result);
      });
    }
  }
}

List<LastPlaceModel> dealWithChapters(
    List<LastPlaceModel>? chapters, List<EpubChapter> bookChapters) {
  List<LastPlaceModel> resultChapters;
  final countedChapters = ChaptersCounter().countChapters(bookChapters);
  if (chapters != null &&
      chapters.isNotEmpty &&
      countedChapters.length == chapters.length) {
    resultChapters = [...chapters];
    for (int i = 0; i < resultChapters.length; i++) {
      resultChapters[i] = resultChapters[i]
          .copyWith(chapterTitle: countedChapters[i].chapterTitle);
    }
  } else {
    resultChapters = countedChapters;
  }
  return resultChapters;
}

LastPlaceModel? dealWithLastPlace(
    List<LastPlaceModel> chapters, LastPlaceModel? lastPlace) {
  if (lastPlace == null) {
    return lastPlace;
  }
  final chapter = chapters
      .firstWhere((element) => element.chapterIndex == lastPlace.chapterIndex);
  return lastPlace.copyWith(chapterTitle: chapter.chapterTitle);
}
