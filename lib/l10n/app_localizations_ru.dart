// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class L10nRu extends L10n {
  L10nRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Klar';

  @override
  String get navToday => 'Сегодня';

  @override
  String get navUpcoming => 'Скоро';

  @override
  String get navLists => 'Списки';

  @override
  String get navSettings => 'Настройки';

  @override
  String get today => 'Сегодня';

  @override
  String get tomorrow => 'Завтра';

  @override
  String get yesterday => 'Вчера';

  @override
  String get later => 'Позже';

  @override
  String get noDate => 'Без даты';

  @override
  String get sectionOverdue => 'Просрочено';

  @override
  String get sectionScheduled => 'По времени';

  @override
  String get sectionAnytime => 'В течение дня';

  @override
  String sectionDone(int count) {
    return 'Выполнено · $count';
  }

  @override
  String todayProgress(int done, int total) {
    return '$done из $total';
  }

  @override
  String get emptyTodayTitle => 'Свободный день';

  @override
  String get emptyTodayBody => 'Добавьте задачу — она напомнит о себе вовремя.';

  @override
  String get emptyUpcomingTitle => 'Впереди тихо';

  @override
  String get emptyUpcomingBody => 'Здесь появятся задачи с датой.';

  @override
  String get emptyListTitle => 'Здесь пока пусто';

  @override
  String get emptyListBody => 'Добавьте первую задачу ниже.';

  @override
  String get quickAddHint => 'Новая задача';

  @override
  String get quickAddMore => 'Подробнее';

  @override
  String get taskCompleted => 'Готово';

  @override
  String taskNextOccurrence(String date) {
    return 'Готово · следующий раз $date';
  }

  @override
  String get taskDeleted => 'Задача удалена';

  @override
  String get undo => 'Отменить';

  @override
  String get listsTitle => 'Списки';

  @override
  String get newList => 'Новый список';

  @override
  String get editList => 'Список';

  @override
  String listTasksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count задачи',
      many: '$count задач',
      few: '$count задачи',
      one: '$count задача',
      zero: 'Нет задач',
    );
    return '$_temp0';
  }

  @override
  String get listNameHint => 'Название';

  @override
  String get listColor => 'Цвет';

  @override
  String get listIcon => 'Иконка';

  @override
  String get deleteListTitle => 'Удалить список?';

  @override
  String deleteListBody(String name) {
    return 'Список «$name» и все его задачи будут удалены.';
  }

  @override
  String get save => 'Сохранить';

  @override
  String get cancel => 'Отмена';

  @override
  String get delete => 'Удалить';

  @override
  String get done => 'Готово';

  @override
  String get edit => 'Изменить';

  @override
  String get newTask => 'Новая задача';

  @override
  String get editTask => 'Задача';

  @override
  String get titleHint => 'Что нужно сделать?';

  @override
  String get notesHint => 'Заметка';

  @override
  String get fieldList => 'Список';

  @override
  String get fieldPriority => 'Приоритет';

  @override
  String get priorityNone => 'Нет';

  @override
  String get priorityLow => 'Низкий';

  @override
  String get priorityMedium => 'Средний';

  @override
  String get priorityHigh => 'Высокий';

  @override
  String get fieldDate => 'Дата';

  @override
  String get fieldTime => 'Время';

  @override
  String get allDay => 'Весь день';

  @override
  String get dateNextWeek => 'Через неделю';

  @override
  String get datePick => 'Другая дата…';

  @override
  String get dateClear => 'Без даты';

  @override
  String get timeClear => 'Без времени';

  @override
  String get fieldRepeat => 'Повтор';

  @override
  String get repeatNone => 'Не повторять';

  @override
  String get repeatDaily => 'Каждый день';

  @override
  String get repeatWorkdays => 'По будням';

  @override
  String get repeatWeekly => 'Каждую неделю';

  @override
  String get repeatMonthly => 'Каждый месяц';

  @override
  String get repeatYearly => 'Каждый год';

  @override
  String get repeatCustom => 'Настроить…';

  @override
  String repeatEveryDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Каждые $n дня',
      many: 'Каждые $n дней',
      few: 'Каждые $n дня',
      one: 'Каждый $n день',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryWeeks(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Каждые $n недели',
      many: 'Каждые $n недель',
      few: 'Каждые $n недели',
      one: 'Каждую $n неделю',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryMonths(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Каждые $n месяца',
      many: 'Каждые $n месяцев',
      few: 'Каждые $n месяца',
      one: 'Каждый $n месяц',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryYears(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Каждые $n года',
      many: 'Каждые $n лет',
      few: 'Каждые $n года',
      one: 'Каждый $n год',
    );
    return '$_temp0';
  }

  @override
  String repeatUntil(String date) {
    return 'до $date';
  }

  @override
  String get repeatInterval => 'Интервал';

  @override
  String get repeatUnitDay => 'День';

  @override
  String get repeatUnitWeek => 'Неделя';

  @override
  String get repeatUnitMonth => 'Месяц';

  @override
  String get repeatUnitYear => 'Год';

  @override
  String get repeatOnDays => 'По дням';

  @override
  String get repeatEnds => 'Окончание';

  @override
  String get repeatEndsNever => 'Никогда';

  @override
  String get repeatEndsOn => 'Дата окончания';

  @override
  String get fieldReminders => 'Напоминания';

  @override
  String get addReminder => 'Добавить напоминание';

  @override
  String get remindersNeedDate => 'Чтобы задача напомнила о себе, выберите дату';

  @override
  String get reminderAtTime => 'В момент срока';

  @override
  String reminderBefore(String duration) {
    return 'За $duration';
  }

  @override
  String reminderAllDayAt(String time) {
    return 'В день задачи, $time';
  }

  @override
  String get reminderCustom => 'Своё…';

  @override
  String get reminderCustomTitle => 'За сколько минут напомнить';

  @override
  String get reminderWhen => 'Когда';

  @override
  String get reminderHow => 'Как';

  @override
  String get reminderKindAlarm => 'Будильник';

  @override
  String get reminderKindNotification => 'Уведомление';

  @override
  String get reminderKindAlarmHint => 'Звонит на весь экран, пока вы не ответите';

  @override
  String get reminderKindNotificationHint => 'Обычное уведомление со звуком';

  @override
  String durationMinutes(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n минуты',
      many: '$n минут',
      few: '$n минуты',
      one: '$n минуту',
    );
    return '$_temp0';
  }

  @override
  String durationHours(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n часа',
      many: '$n часов',
      few: '$n часа',
      one: '$n час',
    );
    return '$_temp0';
  }

  @override
  String durationDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n дня',
      many: '$n дней',
      few: '$n дня',
      one: '$n день',
    );
    return '$_temp0';
  }

  @override
  String get fieldSubtasks => 'Подзадачи';

  @override
  String get addSubtask => 'Добавить подзадачу';

  @override
  String get fieldSound => 'Звук и вибрация';

  @override
  String get asInSettings => 'Как в настройках';

  @override
  String get deleteTask => 'Удалить задачу';

  @override
  String get deleteTaskTitle => 'Удалить задачу?';

  @override
  String deleteTaskBody(String title) {
    return '«$title» будет удалена вместе с подзадачами.';
  }

  @override
  String alarmIn(String duration) {
    return 'Через $duration';
  }

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get sectionAlarm => 'Будильник';

  @override
  String get settingSound => 'Мелодия';

  @override
  String get settingVolume => 'Громкость';

  @override
  String get volumeSystem => 'Как в системе';

  @override
  String volumeAtLeast(int percent) {
    return 'Не тише $percent%';
  }

  @override
  String get volumeSystemHint => 'Не трогать громкость будильника';

  @override
  String get settingRamp => 'Плавное нарастание';

  @override
  String get rampOff => 'Сразу';

  @override
  String seconds(int n) {
    return '$n с';
  }

  @override
  String minutes(int n) {
    return '$n мин';
  }

  @override
  String get settingVibration => 'Вибрация';

  @override
  String get vibrationOff => 'Без вибрации';

  @override
  String get vibrationGentle => 'Мягкая';

  @override
  String get vibrationStandard => 'Обычная';

  @override
  String get vibrationPulse => 'Пульс';

  @override
  String get vibrationHeartbeat => 'Сердцебиение';

  @override
  String get vibrationStrong => 'Сильная';

  @override
  String get settingSnooze => 'Отложить на';

  @override
  String get settingAutoSilence => 'Замолчать через';

  @override
  String get testAlarm => 'Проверить будильник';

  @override
  String get testAlarmHint => 'Прозвенит через 10 секунд';

  @override
  String get testAlarmScheduled => 'Прозвенит через 10 секунд — можно заблокировать экран';

  @override
  String get sectionTasks => 'Задачи';

  @override
  String get settingAllDayTime => 'Задачи без времени напоминают в';

  @override
  String get sectionNotifications => 'Уведомления';

  @override
  String get settingPinNext => 'Ближайшая задача в шторке';

  @override
  String get settingPinNextHint => 'Постоянное уведомление с отсчётом до следующей задачи';

  @override
  String get settingNotificationSound => 'Звук уведомлений';

  @override
  String get settingNotificationSoundHint => 'Настраивается в системе';

  @override
  String get sectionReliability => 'Надёжность';

  @override
  String get reliabilityAllGood => 'Всё настроено — будильники прозвенят вовремя';

  @override
  String get reliabilityIssues => 'Что-то может помешать будильникам';

  @override
  String get permNotifications => 'Уведомления';

  @override
  String get permNotificationsHint => 'Без них будильник не сможет показаться';

  @override
  String get permExactAlarms => 'Точные будильники';

  @override
  String get permExactAlarmsHint => 'Нужны, чтобы звонить минута в минуту';

  @override
  String get permFullScreen => 'Полноэкранный звонок';

  @override
  String get permFullScreenHint => 'Будильник поверх экрана блокировки';

  @override
  String get permBattery => 'Работа в фоне';

  @override
  String get permBatteryHint => 'Не ограничивать расход батареи';

  @override
  String get permAlarmChannel => 'Канал «Будильники»';

  @override
  String get permAlarmChannelHint => 'Отключён в настройках уведомлений';

  @override
  String get permRestricted => 'Фоновая работа ограничена';

  @override
  String get permRestrictedHint => 'Система перевела Klar в режим ограничений';

  @override
  String get permFix => 'Включить';

  @override
  String get forceStoppedBanner =>
      'Klar был остановлен принудительно, будильники восстановлены. Не используйте «Остановить» — Android отменяет все будильники приложения.';

  @override
  String get oemHint =>
      'На телефонах Xiaomi, Huawei, Honor, OPPO и Samsung разрешите Klar также автозапуск и работу без ограничений.';

  @override
  String get soundPickerTitle => 'Мелодия';

  @override
  String get soundSectionKlar => 'Klar';

  @override
  String get soundSectionDevice => 'С устройства';

  @override
  String get soundSystemDefault => 'Стандартный будильник';

  @override
  String get soundPickSystem => 'Выбрать из системных…';

  @override
  String get soundPickFile => 'Свой файл…';

  @override
  String get soundSilent => 'Без звука';

  @override
  String get vibrationPickerTitle => 'Вибрация';

  @override
  String get onboardingTagline => 'Задачи, которые звонят вовремя';

  @override
  String get onboardingBody =>
      'Чтобы будильники срабатывали даже на заблокированном экране, разрешите Klar несколько вещей.';

  @override
  String get onboardingNotifications => 'Уведомления';

  @override
  String get onboardingFullScreen => 'Полноэкранный звонок';

  @override
  String get onboardingBattery => 'Работа в фоне';

  @override
  String get onboardingAllow => 'Разрешить';

  @override
  String get onboardingStart => 'Начать';
}
