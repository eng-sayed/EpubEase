import 'dart:math';

import 'package:epubease/src/Model/calculation_model.dart';
import 'package:epubease/src/Model/chapter_model.dart';
import 'package:epubease/src/Model/reader_result.dart';
import 'package:epubease/src/core/utils/utils.dart';
import 'package:rxdart/rxdart.dart';

class Repository {
  final void Function(ReaderResult result) onSave;
  final _textStream = BehaviorSubject<CalculationModel>();

  ReaderResult lastReadResult;

  static const _debounceTime = Duration(seconds: 2);
  Repository({
    required this.onSave,
    required this.lastReadResult,
  }) {
    _textStream.debounceTime(_debounceTime).listen((model) {
      final result = _calculateResult(model);
      onSave(result);
    });
  }

  void addData(CalculationModel model) {
    _textStream.add(model);
  }

  ReaderResult _calculateResult(CalculationModel model) {
    double progress = lastReadResult.totalProgress;

    if (model.canBeRead) {
      progress = max(
        countProgress(
          selectedChapter: model.selectedChapter,
          bookChapters: model.bookChapters,
          currentChapterPercent: model.currentChapterPercent,
        ),
        lastReadResult.totalProgress,
      );
    }
    final result = ReaderResult(
      chapters: model.chapters.toLastPlaces(),
      totalProgress: progress,
      lastPlace: model.lastPlace,
    );

    lastReadResult = result;

    return result;
  }

  void closeStream() {
    _textStream.close();
  }
}
