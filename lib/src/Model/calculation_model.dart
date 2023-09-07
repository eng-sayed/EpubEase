import 'package:epubease/src/Model/chapter_model.dart';
import 'package:epubease/src/Model/last_place_model.dart';
import 'package:epubx/epubx.dart';

class CalculationModel {
  final double currentChapterPercent;
  final List<EpubChapter> bookChapters;
  final List<Chaptermodel> chapters;
  final LastPlaceModel lastPlace;
  final String selectedChapter;
  final bool canBeRead;

  CalculationModel({
    required this.currentChapterPercent,
    required this.bookChapters,
    required this.chapters,
    required this.lastPlace,
    required this.selectedChapter,
    required this.canBeRead,
  });
}
