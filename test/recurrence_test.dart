import 'package:flutter_test/flutter_test.dart';
import 'package:klar/core/time/local_date.dart';
import 'package:klar/features/tasks/domain/models/recurrence_rule.dart';

LocalDate d(String iso) => LocalDate.parse(iso);

List<String> isoList(Iterable<LocalDate> dates) => dates.map((e) => e.iso).toList();

void main() {
  group('daily', () {
    test('every day from anchor', () {
      final rule = RecurrenceRule(frequency: RecurrenceFrequency.daily, anchor: d('2026-10-10'));
      expect(rule.firstOnOrAfter(d('2026-10-01')), d('2026-10-10'));
      expect(rule.nextAfter(d('2026-10-10')), d('2026-10-11'));
    });

    test('every 3 days keeps the phase of the anchor', () {
      final rule = RecurrenceRule(frequency: RecurrenceFrequency.daily, anchor: d('2026-10-10'), interval: 3);
      expect(isoList(rule.occurrencesBetween(d('2026-10-11'), d('2026-10-20'))), [
        '2026-10-13',
        '2026-10-16',
        '2026-10-19',
      ]);
    });

    test('crosses a DST change without drifting', () {
      final rule = RecurrenceRule(frequency: RecurrenceFrequency.daily, anchor: d('2026-03-28'));
      expect(isoList(rule.occurrencesBetween(d('2026-03-28'), d('2026-03-31'))), [
        '2026-03-28',
        '2026-03-29',
        '2026-03-30',
        '2026-03-31',
      ]);
    });
  });

  group('weekly', () {
    test('defaults to the anchor weekday', () {
      final rule = RecurrenceRule(frequency: RecurrenceFrequency.weekly, anchor: d('2026-10-07')); // Wednesday
      expect(rule.weekdays, {3});
      expect(rule.nextAfter(d('2026-10-07')), d('2026-10-14'));
    });

    test('workdays skip the weekend', () {
      final rule = RecurrenceRule(
        frequency: RecurrenceFrequency.weekly,
        anchor: d('2026-10-09'),
        weekdays: RecurrenceRule.weekdaysOnly,
      );
      expect(rule.isWorkdays, isTrue);
      expect(rule.nextAfter(d('2026-10-09')), d('2026-10-12'));
    });

    test('every 2 weeks on Mon and Thu counts weeks from the anchor week', () {
      final rule = RecurrenceRule(
        frequency: RecurrenceFrequency.weekly,
        anchor: d('2026-10-07'), // Wednesday, week of Oct 5
        interval: 2,
        weekdays: {1, 4},
      );
      expect(isoList(rule.occurrencesBetween(d('2026-10-01'), d('2026-10-31'))), [
        '2026-10-08',
        '2026-10-19',
        '2026-10-22',
      ]);
    });
  });

  group('monthly and yearly', () {
    test('the 31st clamps to the last day of shorter months', () {
      final rule = RecurrenceRule(frequency: RecurrenceFrequency.monthly, anchor: d('2026-01-31'));
      expect(isoList(rule.occurrencesBetween(d('2026-01-01'), d('2026-05-31'))), [
        '2026-01-31',
        '2026-02-28',
        '2026-03-31',
        '2026-04-30',
        '2026-05-31',
      ]);
    });

    test('every 3 months', () {
      final rule = RecurrenceRule(frequency: RecurrenceFrequency.monthly, anchor: d('2026-11-15'), interval: 3);
      expect(rule.nextAfter(d('2026-11-15')), d('2027-02-15'));
      expect(rule.firstOnOrAfter(d('2027-02-16')), d('2027-05-15'));
    });

    test('February 29 falls back to February 28 in common years', () {
      final rule = RecurrenceRule(frequency: RecurrenceFrequency.yearly, anchor: d('2028-02-29'));
      expect(isoList(rule.occurrencesBetween(d('2028-01-01'), d('2032-12-31'))), [
        '2028-02-29',
        '2029-02-28',
        '2030-02-28',
        '2031-02-28',
        '2032-02-29',
      ]);
    });
  });

  test('until ends the series', () {
    final rule = RecurrenceRule(frequency: RecurrenceFrequency.daily, anchor: d('2026-10-10'), until: d('2026-10-12'));
    expect(rule.nextAfter(d('2026-10-11')), d('2026-10-12'));
    expect(rule.nextAfter(d('2026-10-12')), isNull);
  });

  test('json round trip', () {
    final rule = RecurrenceRule(
      frequency: RecurrenceFrequency.weekly,
      anchor: d('2026-10-07'),
      interval: 2,
      weekdays: {4, 1},
      until: d('2027-01-01'),
    );
    expect(RecurrenceRule.fromJson(rule.toJson()), rule);
  });
}
