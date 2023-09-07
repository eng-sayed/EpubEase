import 'package:epubease/src/Model/chapter_model.dart';
import 'package:epubease/src/core/utils/words_counter.dart';

double countLastProgress({
  required String selectedChapter,
  required List<Chaptermodel> bookChapters,
  required double currentChapterPercent,
}) {
  final wordsResult =
      WordsCounter().countWordsBefore(bookChapters, selectedChapter);
  final allResult = WordsCounter().countWordsBefore(bookChapters);
  final currentChapterProgress =
      currentChapterPercent * wordsResult.symbolsInCurrent;
  final progress = (wordsResult.symbolsBefore + currentChapterProgress) /
      allResult.symbolsBefore;
  return progress;
}

double countRealProgress({
  required List<Chaptermodel> bookChapters,
}) {
  var readWords = 0.0;
  var allWords = 0;

  for (var chapter in bookChapters) {
    allWords += chapter.symbolsCount;
    readWords += chapter.symbolsCount * chapter.percent;
  }
  return readWords / allWords;
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
