import 'package:epubease/src/core/utils/words_counter.dart';
import 'package:epubx/epubx.dart';

double countProgress({
  required String selectedChapter,
  required List<EpubChapter> bookChapters,
  required double currentChapterPercent,
}) {
  final wordsResult =
      WordsCounter().countWordsBefore(bookChapters, selectedChapter);
  final allResult =
      WordsCounter().countWordsBefore(bookChapters, "sdvsmkvmksmdcs");
  final currentChapterProgress =
      currentChapterPercent * wordsResult.symbolsInCurrent;
  final progress = (wordsResult.symbolsBefore + currentChapterProgress) /
      allResult.symbolsBefore;
  return progress;
}
