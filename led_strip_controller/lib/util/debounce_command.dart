import 'package:easy_debounce/easy_debounce.dart';

void debouncedCommand(Function() command) {
  EasyDebounce.debounce(
    'debouncedCommand',
    const Duration(milliseconds: 500),
    command,
  );
}
