# Klar

Задачи, которые звонят вовремя. Android-приложение на Flutter: списки, подзадачи, повторения,
несколько напоминаний на задачу — каждое может звонить как настоящий будильник (поверх экрана
блокировки, со своим звуком, вибрацией и нарастанием громкости) или приходить обычным уведомлением.

## Запуск

```shell
fvm install            # Flutter из .fvmrc
fvm flutter pub get
fvm flutter run
```

## Генерация кода

```shell
fvm dart run build_runner build --delete-conflicting-outputs   # drift
fvm flutter gen-l10n                                           # строки из lib/l10n/app_ru.arb
```

## Архитектура

- `lib/` — Flutter: UI, база (drift), `AlarmPlanner` считает все будущие сигналы.
- `android/app/src/main/kotlin/com/umartin/klar/alarm/` — нативный движок будильников: хранит
  расписание в device-protected storage, взводит AlarmManager, звонит через foreground service,
  обрабатывает «Готово / Отложить» без запущенного Flutter и переживает перезагрузку.
- Связь — канал `klar/alarms`: Flutter отправляет полный план (`replaceAll`), натив возвращает
  события «Готово», которые Flutter применяет к базе перед следующей синхронизацией.

## Тесты

```shell
fvm flutter test
cd android && ./gradlew :app:testDebugUnitTest
```
