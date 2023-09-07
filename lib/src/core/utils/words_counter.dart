import 'package:epubease/src/Model/chapter_model.dart';
import 'package:epubease/src/core/utils/count_words_result.dart';
import 'package:epubx/epubx.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

class WordsCounter {
  var wasChapterFound = false;
  WordsCounter();

  CountWordsResult countWordsBefore(
      List<EpubChapter> chapters, String selectedchapter) {
    var wordsBefore = 0;
    int wordsInChapter = 0;
    for (int i = 0; i < chapters.length; i++) {
      final chapter = chapters[i];
      if ((chapter.Title ?? "").toLowerCase() ==
          selectedchapter.toLowerCase()) {
        wasChapterFound = true;
        wordsInChapter = countWordsInChapter(chapter);
        break;
      } else {
        wordsBefore += countWordsInChapter(chapter);
        final wordsInSubChapters =
            countWordsBefore(chapter.SubChapters ?? [], selectedchapter);
        wordsBefore += wordsInSubChapters.symbolsBefore;
        wordsInChapter = wordsInSubChapters.symbolsInCurrent;

        if (wasChapterFound) {
          break;
        }
      }
    }
    return CountWordsResult(
      symbolsBefore: wordsBefore,
      symbolsInCurrent: wordsInChapter,
    );
  }

  CountWordsResult countWordsBeforeTest(List<Chaptermodel> chapters,
      [String? selectedchapter]) {
    final index = selectedchapter != null
        ? chapters.indexWhere((element) => element.title == selectedchapter)
        : chapters.length;
    var count = 0;
    for (int i = 0; i < index; i++) {
      count += chapters[i].symbolsCount;
    }
    final chapterCount =
        selectedchapter != null ? chapters[index].symbolsCount : 0;
    return CountWordsResult(
      symbolsBefore: count,
      symbolsInCurrent: chapterCount,
    );
  }

  int countWordsInChapterAndSubChapters(EpubChapter chapter) {
    final wordsInChapter = countWordsInChapter(chapter);
    var wordsInSubChapters = 0;
    chapter.SubChapters?.forEach((element) {
      wordsInSubChapters += countWordsInChapterAndSubChapters(element);
    });
    return wordsInChapter + wordsInSubChapters;
  }

  int countWordsInChapter(EpubChapter chapter) {
    final doc = parse(chapter.HtmlContent);
    return getWordCountsInNodeList(doc.nodes);
  }

  int getWordCountsInNode(Node node) {
    var wordCount = node.text?.trim().split(' ').length ?? 0;
    if (node.nodes.isNotEmpty) {
      wordCount += getWordCountsInNodeList(node.nodes);
    }
    return wordCount;
  }

  int getWordCountsInNodeList(NodeList nodeList) {
    var wordCount = 0;
    for (var i = 0; i < nodeList.length; i++) {
      wordCount += getWordCountsInNode(nodeList[i]);
    }
    return wordCount;
  }
}
