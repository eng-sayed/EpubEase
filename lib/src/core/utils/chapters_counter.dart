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

    for (int i = 0; i < list.length; i++) {
      list[i] = list[i].copyWith(index: i + 1);
    }
    return list;
  }

  List<Chaptermodel> _getSubChapters(
    EpubChapter chapter, {
    bool isSubChapter = true,
    int wordsInParentChapter = 0,
  }) {
    List<Chaptermodel> subChapters = [];
    List<Chaptermodel> subSubChapters = [];
    final wordsInChapter = wordsCounter.countWordsInChapter(chapter);
    if (chapter.SubChapters != null &&
        (chapter.SubChapters?.isNotEmpty ?? false)) {
      for (int i = 0; i < chapter.SubChapters!.length; i++) {
        final element = chapter.SubChapters![i];
        final chapters = _getSubChapters(
          element,
          wordsInParentChapter: wordsInChapter,
        );
        subSubChapters.addAll(chapters);
      }
    }

    subChapters.add(
      Chaptermodel(
        title: chapter.Title!,
        issubchapter: isSubChapter,
        percent: 0,
        subChapters: subSubChapters,
        index: 0,
        symbolsCount: wordsInChapter + wordsInParentChapter,
        content: chapter.HtmlContent ?? "",
      ),
    );
    subChapters.addAll(subSubChapters);

    return subChapters;
  }
}
