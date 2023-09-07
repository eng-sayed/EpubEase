import 'package:epubease/src/Model/chapter_model.dart';
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

Duration countReadDurationOfChapter(Chaptermodel chapter) {
  final symbolsInChapter = chapter.symbolsCount;
  const symbolsPerSecond = 25;
  final normalReadSeconds = symbolsInChapter / symbolsPerSecond;
  const coef = 0.1;
  final coefReadSeconds = normalReadSeconds * coef;
  final coedReadMilliseconds = coefReadSeconds * 1000;
  return Duration(milliseconds: coedReadMilliseconds.round());
}
