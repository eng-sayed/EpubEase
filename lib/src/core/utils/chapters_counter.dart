import 'package:epubease/src/Model/last_place_model.dart';
import 'package:epubx/epubx.dart';

class ChaptersCounter {
  var wasChapterFound = false;

  ChaptersCounter();
  List<LastPlaceModel> countChapters(List<EpubChapter> chapters) {
    final allChapters = <LastPlaceModel>[];
    for (int i = 0; i < chapters.length; i++) {
      final chapter = chapters[i];
      allChapters.add(
        LastPlaceModel(
          chapterPercent: 0,
          chapterTitle: chapter.Title,
          chapterIndex: allChapters.length,
        ),
      );
      final subChapters = countChapters(
        chapter.SubChapters ?? [],
      );
      reindexPlaces(subChapters, allChapters.length - 1);
      allChapters.addAll(subChapters);
    }
    return allChapters;
  }

  void reindexPlaces(List<LastPlaceModel> models, int startIndex) {
    for (int i = 0; i < models.length; i++) {
      models[i] = models[i].copyWith(
        chapterIndex: startIndex + (models[i].chapterIndex ?? 0),
      );
    }
  }
}
