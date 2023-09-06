import 'package:epubx/epubx.dart';

class Chaptermodel {
  String chapter = '';
  bool issubchapter = false;
  List<Chaptermodel> subChapters;
  int percent;
  Chaptermodel({
    required this.chapter,
    required this.issubchapter,
    required this.subChapters,
    required this.percent,
  });
  Chaptermodel copyWith({int? percent}) => Chaptermodel(
        chapter: chapter,
        issubchapter: issubchapter,
        subChapters: subChapters,
        percent: percent ?? this.percent,
      );
}

extension ChapterExtension on List<EpubChapter>? {
  List<Chaptermodel> toChapterModels() {
    if (this != null) {
      return this!
          .map((chapter) => Chaptermodel(
                chapter: chapter.Title ?? '',
                issubchapter: true,
                percent: 0,
                subChapters: chapter.SubChapters.toChapterModels(),
              ))
          .toList();
    }
    return [];
  }
}
