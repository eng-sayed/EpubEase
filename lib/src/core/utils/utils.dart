import 'package:epubease/src/Model/chapter_model.dart';
import 'package:epubease/src/core/utils/words_counter.dart';

double countLastProgress({
  required int selectedChapter,
  required List<Chaptermodel> bookChapters,
  required double currentChapterPercent,
}) {
  final wordsResult =
      WordsCounter().countWordsBefore(bookChapters, selectedChapter);
  final allResult = WordsCounter().countWordsBefore(bookChapters);
  final chapter =
      bookChapters.firstWhere((element) => element.index == selectedChapter);

  late final double currentChapterProgress;
  if (chapter.subChapters.isEmpty) {
    currentChapterProgress =
        currentChapterPercent * wordsResult.symbolsInCurrent;
  } else {
    currentChapterProgress =
        countRealProgress(bookChapters: chapter.subChapters);
  }
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
    if (chapter.subChapters.isEmpty) {
      allWords += chapter.symbolsCount;
      readWords += chapter.symbolsCount * chapter.percent;
    }
  }
  return readWords / allWords;
}

Duration countReadDurationOfChapter(Chaptermodel chapter) {
  final symbolsInChapter = chapter.symbolsCount;
  const symbolsPerSecond = 25;
  final normalReadSeconds = symbolsInChapter / symbolsPerSecond;
  const coef = 0.1;
  final coefReadSeconds = normalReadSeconds * coef * (1 - chapter.percent);
  final coedReadMilliseconds = coefReadSeconds * 1000;
  return Duration(milliseconds: coedReadMilliseconds.round());
}
