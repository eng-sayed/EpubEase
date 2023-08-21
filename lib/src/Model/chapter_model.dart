import 'package:epubease/src/Pages/Content.dart';
import 'package:epubx/epubx.dart';

class Chaptermodel {
  String chapter = '';
  bool issubchapter = false;
  List<Chaptermodel> subChapters;
  Chaptermodel({
    required this.chapter,
    required this.issubchapter,
    required this.subChapters,
  });
}

extension ChapterExtension on List<EpubChapter>? {
  List<Chaptermodel> toChapterModels() {
    if (this != null) {
      return this!
          .map((chapter) => Chaptermodel(
                chapter: chapter.Title ?? '',
                issubchapter: true,
                subChapters: chapter.SubChapters.toChapterModels(),
              ))
          .toList();
    }
    return [];
  }
}
