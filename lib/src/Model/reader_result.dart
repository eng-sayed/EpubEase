import 'package:epubease/src/Model/last_place_model.dart';

class ReaderResult {
  final LastPlaceModel lastPlace;
  final List<LastPlaceModel> chapters;
  final double lastProgress;
  final double realProgress;

  ReaderResult({
    required this.lastPlace,
    required this.chapters,
    required this.lastProgress,
    required this.realProgress,
  });
}
