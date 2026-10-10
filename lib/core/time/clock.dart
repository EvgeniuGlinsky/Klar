import 'package:klar/core/time/local_date.dart';
import 'package:klar/core/time/local_date_time.dart';

/// Source of the current time; replaced with a fixed clock in tests.
class Clock {
  const Clock();

  DateTime now() => DateTime.now();

  LocalDate today() => LocalDate.fromDateTime(now());

  LocalDateTime localNow() => LocalDateTime.fromDateTime(now());
}

class FixedClock extends Clock {
  FixedClock(this.value);

  DateTime value;

  @override
  DateTime now() => value;
}
