class LastPlaceModel {
  final String? chapterTitle;
  final int? chapterIndex;
  final int? chapterPercent;

  const LastPlaceModel({
    required this.chapterPercent,
    required this.chapterTitle,
    required this.chapterIndex,
  });

  LastPlaceModel copyWith({
    String? chapterTitle,
    int? chapterIndex,
    double? chapterPercent,
  }) =>
      LastPlaceModel(
        chapterPercent: chapterPercent ?? this.chapterPercent,
        chapterTitle: chapterTitle ?? this.chapterTitle,
        chapterIndex: chapterIndex ?? this.chapterIndex,
      );
}
