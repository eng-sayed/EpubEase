import 'package:epubx/epubx.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

int countWordsBefore(List<EpubChapter> chapters, String selectedchapter) {
  var wordsBefore = 0;
  for (int i = 0; i < chapters.length; i++) {
    final chapter = chapters[i];
    if ((chapter.Title ?? "").toLowerCase() == selectedchapter.toLowerCase()) {
      break;
    } else {
      wordsBefore += countWordsInChapter(chapter);
    }
  }
  return wordsBefore;
}

int countWordsInChapter(EpubChapter chapter) {
  final doc = parse(chapter.HtmlContent);
  return getWordCountsInNodeList(doc.querySelectorAll('p'));
}

int getWordCountsInNodeList(List<Element> nodeList) {
  var wordCount = 0;
  for (var i = 0; i < nodeList.length; i++) {
    wordCount += nodeList[i].text.trim().split(' ').length;
  }
  return wordCount;
}
