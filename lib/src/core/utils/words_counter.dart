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
