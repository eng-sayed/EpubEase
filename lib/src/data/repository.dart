import 'package:epubease/src/Model/reader_result.dart';
import 'package:rxdart/rxdart.dart';

class Repository {
  final void Function(ReaderResult result) onSave;
  final _textStream = BehaviorSubject<ReaderResult>();

  ReaderResult lastReadResult;

  static const _debounceTime = Duration(seconds: 2);
  Repository({
    required this.onSave,
    required this.lastReadResult,
  }) {
    _textStream.debounceTime(_debounceTime).listen((result) {
      onSave(result);
    });
  }

  void addData(ReaderResult model) {
    _textStream.add(model);
  }

  void closeStream() {
    _textStream.close();
  }
}
