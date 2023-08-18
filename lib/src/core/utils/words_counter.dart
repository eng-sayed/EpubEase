import 'package:epubx/epubx.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

class WordsCounter {
  var wasChapterFound = false;
  WordsCounter();
  int countWordsBefore(List<EpubChapter> chapters, String selectedchapter) {
    var wordsBefore = 0;
    for (int i = 0; i < chapters.length; i++) {
      final chapter = chapters[i];
      if ((chapter.Title ?? "").toLowerCase() ==
          selectedchapter.toLowerCase()) {
        wasChapterFound = true;
        break;
      } else {
        wordsBefore += countWordsInChapter(chapter);
        wordsBefore +=
            countWordsBefore(chapter.SubChapters ?? [], selectedchapter);
        if (wasChapterFound) {
          break;
        }
      }
    }
    return wordsBefore;
  }

  int countWordsInChapter(EpubChapter chapter) {
    var htmlChapter = chapter.HtmlContent;

    final doc = parse(chapter.HtmlContent);
    return getWordCountsInNodeList(doc.nodes);
  }

  String getChapterHtml(EpubChapter chapter) {
    var htmlChapter = chapter.HtmlContent ?? "";
    for (var element in chapter.SubChapters ?? []) {
      htmlChapter = htmlChapter + getChapterHtml(element);
    }
    return htmlChapter;
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
