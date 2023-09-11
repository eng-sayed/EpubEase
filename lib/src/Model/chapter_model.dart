import 'package:epubease/src/Model/last_place_model.dart';

class Chaptermodel {
  String title = '';
  bool issubchapter = false;
  List<Chaptermodel> subChapters;
  double percent;
  int index;
  int symbolsCount;
  Chaptermodel({
    required this.title,
    required this.index,
    required this.issubchapter,
    required this.subChapters,
    required this.percent,
    required this.symbolsCount,
  });
  Chaptermodel copyWith({
    double? percent,
    int? index,
  }) =>
      Chaptermodel(
        title: title,
        issubchapter: issubchapter,
        subChapters: subChapters,
        index: index ?? this.index,
        symbolsCount: symbolsCount,
        percent: percent ?? this.percent,
      );
}

extension ChapterExtension on List<Chaptermodel> {
  List<LastPlaceModel> toLastPlaces() {
    return map(
      (chapter) => LastPlaceModel(
        chapterIndex: chapter.index,
        chapterPercent: chapter.percent,
        chapterTitle: chapter.title,
      ),
    ).toList();
  }
}
