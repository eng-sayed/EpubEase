import 'package:epubease/src/Model/last_place_model.dart';

class ReaderResult {
  final LastPlaceModel lactPlace;
  final List<LastPlaceModel> chapters;
  final int totalProgress;

  ReaderResult({
    required this.lactPlace,
    required this.chapters,
    required this.totalProgress,
  });
}
