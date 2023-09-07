import 'package:epubease/src/Model/chapter_model.dart';
import 'package:epubease/src/core/utils/words_counter.dart';
import 'package:epubx/epubx.dart';

class ChaptersCounter {
  var wasChapterFound = false;
  final WordsCounter wordsCounter = WordsCounter();

  ChaptersCounter();

  List<Chaptermodel> getAllChapters(List<EpubChapter> chapters) {
    var list = <Chaptermodel>[];
    for (var chapter in chapters) {
      List<Chaptermodel> subChapters = [];
      subChapters.addAll(
        _getSubChapters(
          chapter,
          isSubChapter: false,
        ),
      );

      list += subChapters;
    }
    return list;
  }

  List<Chaptermodel> _getSubChapters(EpubChapter chapter,
      {bool isSubChapter = true, int startIndex = 0}) {
    List<Chaptermodel> subChapters = [];
    List<Chaptermodel> subSubChapters = [];

    if (chapter.SubChapters != null &&
        (chapter.SubChapters?.isNotEmpty ?? false)) {
      for (var element in chapter.SubChapters!) {
        final chapters = _getSubChapters(element,
            startIndex: subChapters.length + subSubChapters.length);
        subSubChapters.addAll(chapters);
      }
    }

    subChapters.add(
      Chaptermodel(
        title: chapter.Title!,
        issubchapter: isSubChapter,
        percent: 0,
        subChapters: subSubChapters,
        index: startIndex + subChapters.length,
        symbolsCount: wordsCounter.countWordsInChapter(chapter),
      ),
    );
    subChapters.addAll(subSubChapters);

    return subChapters;
  }
}
