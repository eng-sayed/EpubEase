library epubease;

import 'dart:async';
import 'dart:io';

import 'package:epubease/src/Model/chapter_model.dart';
import 'package:epubease/src/Model/last_place_model.dart';
import 'package:epubease/src/Model/reader_result.dart';
import 'package:epubease/src/core/utils/chapters_counter.dart';
import 'package:epubease/src/data/repository.dart';
import 'package:epubx/epubx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;

export 'src/Pages/epub_display.dart';

/// A Calculator.
class Epubease {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<void> open(
    String bookurl,
    BuildContext context, {
    required ReaderResult result,
    required Function(ReaderResult result) onClose,
    required Function(ReaderResult result) onSave,
    required Future<dynamic> Function(Widget reader) pushReader,
    required void Function(String message) onError,
  }) async {
    try {
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
            dealWithChapters(result.chapters, epubBook.Chapters ?? []);
        final realLastPlace =
            dealWithLastPlace(chaptersPercentages, result.lastPlace);

        final repository = Repository(onSave: onSave, lastReadResult: result);

        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          final result = await pushReader(Scaffold(
            body: SingleChildScrollView(child: Html(data: htmlcontent)),
          )
              /*  ShowEpub(
              html1: htmlcontent,
              epubBook: epubBook,
              lastPlace: realLastPlace,
              repository: repository,
              realChapters: chaptersPercentages,
            ), */
              );
          onClose(result);
        });
      } else {
        throw HttpException(response.reasonPhrase ?? "Something went wrong");
      }
    } on HttpException catch (e) {
      onError(e.message);
    } catch (e) {
      onError(e.toString());
    }
  }
}

List<Chaptermodel> dealWithChapters(
  List<LastPlaceModel>? chapters,
  List<EpubChapter> bookChapters,
) {
  final countedChapters = ChaptersCounter().getAllChapters(bookChapters);

  if (chapters != null &&
      chapters.isNotEmpty &&
      countedChapters.length == chapters.length) {
    for (int i = 0; i < countedChapters.length; i++) {
      countedChapters[i] =
          countedChapters[i].copyWith(percent: chapters[i].chapterPercent);
    }
  }
  return countedChapters;
}

LastPlaceModel? dealWithLastPlace(
    List<Chaptermodel> chapters, LastPlaceModel? lastPlace) {
  if (lastPlace == null) {
    return lastPlace;
  }
  final chapter =
      chapters.firstWhere((element) => element.index == lastPlace.chapterIndex);
  return lastPlace.copyWith(chapterTitle: chapter.title);
}
