import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L10n
/// returned by `L10n.of(context)`.
///
/// Applications need to include `L10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L10n.localizationsDelegates,
///   supportedLocales: L10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L10n.supportedLocales
/// property.
abstract class L10n {
  L10n(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L10n of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n)!;
  }

  static const LocalizationsDelegate<L10n> delegate = _L10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('ru')];

  /// No description provided for @appTitle.
  ///
  /// In ru, this message translates to:
  /// **'Klar'**
  String get appTitle;

  /// No description provided for @navToday.
  ///
  /// In ru, this message translates to:
  /// **'Сегодня'**
  String get navToday;

  /// No description provided for @navUpcoming.
  ///
  /// In ru, this message translates to:
  /// **'Скоро'**
  String get navUpcoming;

  /// No description provided for @navLists.
  ///
  /// In ru, this message translates to:
  /// **'Списки'**
  String get navLists;

  /// No description provided for @navSettings.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get navSettings;

  /// No description provided for @today.
  ///
  /// In ru, this message translates to:
  /// **'Сегодня'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In ru, this message translates to:
  /// **'Завтра'**
  String get tomorrow;

  /// No description provided for @yesterday.
  ///
  /// In ru, this message translates to:
  /// **'Вчера'**
  String get yesterday;

  /// No description provided for @later.
  ///
  /// In ru, this message translates to:
  /// **'Позже'**
  String get later;

  /// No description provided for @noDate.
  ///
  /// In ru, this message translates to:
  /// **'Без даты'**
  String get noDate;

  /// No description provided for @sectionOverdue.
  ///
  /// In ru, this message translates to:
  /// **'Просрочено'**
  String get sectionOverdue;

  /// No description provided for @sectionScheduled.
  ///
  /// In ru, this message translates to:
  /// **'По времени'**
  String get sectionScheduled;

  /// No description provided for @sectionAnytime.
  ///
  /// In ru, this message translates to:
  /// **'В течение дня'**
  String get sectionAnytime;

  /// No description provided for @sectionDone.
  ///
  /// In ru, this message translates to:
  /// **'Выполнено · {count}'**
  String sectionDone(int count);

  /// No description provided for @todayProgress.
  ///
  /// In ru, this message translates to:
  /// **'{done} из {total}'**
  String todayProgress(int done, int total);

  /// No description provided for @emptyTodayTitle.
  ///
  /// In ru, this message translates to:
  /// **'Свободный день'**
  String get emptyTodayTitle;

  /// No description provided for @emptyTodayBody.
  ///
  /// In ru, this message translates to:
  /// **'Добавьте задачу — она напомнит о себе вовремя.'**
  String get emptyTodayBody;

  /// No description provided for @emptyUpcomingTitle.
  ///
  /// In ru, this message translates to:
  /// **'Впереди тихо'**
  String get emptyUpcomingTitle;

  /// No description provided for @emptyUpcomingBody.
  ///
  /// In ru, this message translates to:
  /// **'Здесь появятся задачи с датой.'**
  String get emptyUpcomingBody;

  /// No description provided for @emptyListTitle.
  ///
  /// In ru, this message translates to:
  /// **'Здесь пока пусто'**
  String get emptyListTitle;

  /// No description provided for @emptyListBody.
  ///
  /// In ru, this message translates to:
  /// **'Добавьте первую задачу ниже.'**
  String get emptyListBody;

  /// No description provided for @quickAddHint.
  ///
  /// In ru, this message translates to:
  /// **'Новая задача'**
  String get quickAddHint;

  /// No description provided for @quickAddMore.
  ///
  /// In ru, this message translates to:
  /// **'Подробнее'**
  String get quickAddMore;

  /// No description provided for @taskCompleted.
  ///
  /// In ru, this message translates to:
  /// **'Готово'**
  String get taskCompleted;

  /// No description provided for @taskNextOccurrence.
  ///
  /// In ru, this message translates to:
  /// **'Готово · следующий раз {date}'**
  String taskNextOccurrence(String date);

  /// No description provided for @taskDeleted.
  ///
  /// In ru, this message translates to:
  /// **'Задача удалена'**
  String get taskDeleted;

  /// No description provided for @undo.
  ///
  /// In ru, this message translates to:
  /// **'Отменить'**
  String get undo;

  /// No description provided for @listsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Списки'**
  String get listsTitle;

  /// No description provided for @newList.
  ///
  /// In ru, this message translates to:
  /// **'Новый список'**
  String get newList;

  /// No description provided for @editList.
  ///
  /// In ru, this message translates to:
  /// **'Список'**
  String get editList;

  /// No description provided for @listTasksCount.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, =0{Нет задач} one{{count} задача} few{{count} задачи} many{{count} задач} other{{count} задачи}}'**
  String listTasksCount(int count);

  /// No description provided for @listNameHint.
  ///
  /// In ru, this message translates to:
  /// **'Название'**
  String get listNameHint;

  /// No description provided for @listColor.
  ///
  /// In ru, this message translates to:
  /// **'Цвет'**
  String get listColor;

  /// No description provided for @listIcon.
  ///
  /// In ru, this message translates to:
  /// **'Иконка'**
  String get listIcon;

  /// No description provided for @deleteListTitle.
  ///
  /// In ru, this message translates to:
  /// **'Удалить список?'**
  String get deleteListTitle;

  /// No description provided for @deleteListBody.
  ///
  /// In ru, this message translates to:
  /// **'Список «{name}» и все его задачи будут удалены.'**
  String deleteListBody(String name);

  /// No description provided for @save.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In ru, this message translates to:
  /// **'Удалить'**
  String get delete;

  /// No description provided for @done.
  ///
  /// In ru, this message translates to:
  /// **'Готово'**
  String get done;

  /// No description provided for @edit.
  ///
  /// In ru, this message translates to:
  /// **'Изменить'**
  String get edit;

  /// No description provided for @newTask.
  ///
  /// In ru, this message translates to:
  /// **'Новая задача'**
  String get newTask;

  /// No description provided for @editTask.
  ///
  /// In ru, this message translates to:
  /// **'Задача'**
  String get editTask;

  /// No description provided for @titleHint.
  ///
  /// In ru, this message translates to:
  /// **'Что нужно сделать?'**
  String get titleHint;

  /// No description provided for @notesHint.
  ///
  /// In ru, this message translates to:
  /// **'Заметка'**
  String get notesHint;

  /// No description provided for @fieldList.
  ///
  /// In ru, this message translates to:
  /// **'Список'**
  String get fieldList;

  /// No description provided for @fieldPriority.
  ///
  /// In ru, this message translates to:
  /// **'Приоритет'**
  String get fieldPriority;

  /// No description provided for @priorityNone.
  ///
  /// In ru, this message translates to:
  /// **'Нет'**
  String get priorityNone;

  /// No description provided for @priorityLow.
  ///
  /// In ru, this message translates to:
  /// **'Низкий'**
  String get priorityLow;

  /// No description provided for @priorityMedium.
  ///
  /// In ru, this message translates to:
  /// **'Средний'**
  String get priorityMedium;

  /// No description provided for @priorityHigh.
  ///
  /// In ru, this message translates to:
  /// **'Высокий'**
  String get priorityHigh;

  /// No description provided for @fieldDate.
  ///
  /// In ru, this message translates to:
  /// **'Дата'**
  String get fieldDate;

  /// No description provided for @fieldTime.
  ///
  /// In ru, this message translates to:
  /// **'Время'**
  String get fieldTime;

  /// No description provided for @allDay.
  ///
  /// In ru, this message translates to:
  /// **'Весь день'**
  String get allDay;

  /// No description provided for @dateNextWeek.
  ///
  /// In ru, this message translates to:
  /// **'Через неделю'**
  String get dateNextWeek;

  /// No description provided for @datePick.
  ///
  /// In ru, this message translates to:
  /// **'Другая дата…'**
  String get datePick;

  /// No description provided for @dateClear.
  ///
  /// In ru, this message translates to:
  /// **'Без даты'**
  String get dateClear;

  /// No description provided for @timeClear.
  ///
  /// In ru, this message translates to:
  /// **'Без времени'**
  String get timeClear;

  /// No description provided for @fieldRepeat.
  ///
  /// In ru, this message translates to:
  /// **'Повтор'**
  String get fieldRepeat;

  /// No description provided for @repeatNone.
  ///
  /// In ru, this message translates to:
  /// **'Не повторять'**
  String get repeatNone;

  /// No description provided for @repeatDaily.
  ///
  /// In ru, this message translates to:
  /// **'Каждый день'**
  String get repeatDaily;

  /// No description provided for @repeatWorkdays.
  ///
  /// In ru, this message translates to:
  /// **'По будням'**
  String get repeatWorkdays;

  /// No description provided for @repeatWeekly.
  ///
  /// In ru, this message translates to:
  /// **'Каждую неделю'**
  String get repeatWeekly;

  /// No description provided for @repeatMonthly.
  ///
  /// In ru, this message translates to:
  /// **'Каждый месяц'**
  String get repeatMonthly;

  /// No description provided for @repeatYearly.
  ///
  /// In ru, this message translates to:
  /// **'Каждый год'**
  String get repeatYearly;

  /// No description provided for @repeatCustom.
  ///
  /// In ru, this message translates to:
  /// **'Настроить…'**
  String get repeatCustom;

  /// No description provided for @repeatEveryDays.
  ///
  /// In ru, this message translates to:
  /// **'{n, plural, one{Каждый {n} день} few{Каждые {n} дня} many{Каждые {n} дней} other{Каждые {n} дня}}'**
  String repeatEveryDays(int n);

  /// No description provided for @repeatEveryWeeks.
  ///
  /// In ru, this message translates to:
  /// **'{n, plural, one{Каждую {n} неделю} few{Каждые {n} недели} many{Каждые {n} недель} other{Каждые {n} недели}}'**
  String repeatEveryWeeks(int n);

  /// No description provided for @repeatEveryMonths.
  ///
  /// In ru, this message translates to:
  /// **'{n, plural, one{Каждый {n} месяц} few{Каждые {n} месяца} many{Каждые {n} месяцев} other{Каждые {n} месяца}}'**
  String repeatEveryMonths(int n);

  /// No description provided for @repeatEveryYears.
  ///
  /// In ru, this message translates to:
  /// **'{n, plural, one{Каждый {n} год} few{Каждые {n} года} many{Каждые {n} лет} other{Каждые {n} года}}'**
  String repeatEveryYears(int n);

  /// No description provided for @repeatUntil.
  ///
  /// In ru, this message translates to:
  /// **'до {date}'**
  String repeatUntil(String date);

  /// No description provided for @repeatInterval.
  ///
  /// In ru, this message translates to:
  /// **'Интервал'**
  String get repeatInterval;

  /// No description provided for @repeatUnitDay.
  ///
  /// In ru, this message translates to:
  /// **'День'**
  String get repeatUnitDay;

  /// No description provided for @repeatUnitWeek.
  ///
  /// In ru, this message translates to:
  /// **'Неделя'**
  String get repeatUnitWeek;

  /// No description provided for @repeatUnitMonth.
  ///
  /// In ru, this message translates to:
  /// **'Месяц'**
  String get repeatUnitMonth;

  /// No description provided for @repeatUnitYear.
  ///
  /// In ru, this message translates to:
  /// **'Год'**
  String get repeatUnitYear;

  /// No description provided for @repeatOnDays.
  ///
  /// In ru, this message translates to:
  /// **'По дням'**
  String get repeatOnDays;

  /// No description provided for @repeatEnds.
  ///
  /// In ru, this message translates to:
  /// **'Окончание'**
  String get repeatEnds;

  /// No description provided for @repeatEndsNever.
  ///
  /// In ru, this message translates to:
  /// **'Никогда'**
  String get repeatEndsNever;

  /// No description provided for @repeatEndsOn.
  ///
  /// In ru, this message translates to:
  /// **'Дата окончания'**
  String get repeatEndsOn;

  /// No description provided for @fieldReminders.
  ///
  /// In ru, this message translates to:
  /// **'Напоминания'**
  String get fieldReminders;

  /// No description provided for @addReminder.
  ///
  /// In ru, this message translates to:
  /// **'Добавить напоминание'**
  String get addReminder;

  /// No description provided for @remindersNeedDate.
  ///
  /// In ru, this message translates to:
  /// **'Чтобы задача напомнила о себе, выберите дату'**
  String get remindersNeedDate;

  /// No description provided for @reminderAtTime.
  ///
  /// In ru, this message translates to:
  /// **'В момент срока'**
  String get reminderAtTime;

  /// No description provided for @reminderBefore.
  ///
  /// In ru, this message translates to:
  /// **'За {duration}'**
  String reminderBefore(String duration);

  /// No description provided for @reminderAllDayAt.
  ///
  /// In ru, this message translates to:
  /// **'В день задачи, {time}'**
  String reminderAllDayAt(String time);

  /// No description provided for @reminderCustom.
  ///
  /// In ru, this message translates to:
  /// **'Своё…'**
  String get reminderCustom;

  /// No description provided for @reminderCustomTitle.
  ///
  /// In ru, this message translates to:
  /// **'За сколько минут напомнить'**
  String get reminderCustomTitle;

  /// No description provided for @reminderWhen.
  ///
  /// In ru, this message translates to:
  /// **'Когда'**
  String get reminderWhen;

  /// No description provided for @reminderHow.
  ///
  /// In ru, this message translates to:
  /// **'Как'**
  String get reminderHow;

  /// No description provided for @reminderKindAlarm.
  ///
  /// In ru, this message translates to:
  /// **'Будильник'**
  String get reminderKindAlarm;

  /// No description provided for @reminderKindNotification.
  ///
  /// In ru, this message translates to:
  /// **'Уведомление'**
  String get reminderKindNotification;

  /// No description provided for @reminderKindAlarmHint.
  ///
  /// In ru, this message translates to:
  /// **'Звонит на весь экран, пока вы не ответите'**
  String get reminderKindAlarmHint;

  /// No description provided for @reminderKindNotificationHint.
  ///
  /// In ru, this message translates to:
  /// **'Обычное уведомление со звуком'**
  String get reminderKindNotificationHint;

  /// No description provided for @durationMinutes.
  ///
  /// In ru, this message translates to:
  /// **'{n, plural, one{{n} минуту} few{{n} минуты} many{{n} минут} other{{n} минуты}}'**
  String durationMinutes(int n);

  /// No description provided for @durationHours.
  ///
  /// In ru, this message translates to:
  /// **'{n, plural, one{{n} час} few{{n} часа} many{{n} часов} other{{n} часа}}'**
  String durationHours(int n);

  /// No description provided for @durationDays.
  ///
  /// In ru, this message translates to:
  /// **'{n, plural, one{{n} день} few{{n} дня} many{{n} дней} other{{n} дня}}'**
  String durationDays(int n);

  /// No description provided for @fieldSubtasks.
  ///
  /// In ru, this message translates to:
  /// **'Подзадачи'**
  String get fieldSubtasks;

  /// No description provided for @addSubtask.
  ///
  /// In ru, this message translates to:
  /// **'Добавить подзадачу'**
  String get addSubtask;

  /// No description provided for @fieldSound.
  ///
  /// In ru, this message translates to:
  /// **'Звук и вибрация'**
  String get fieldSound;

  /// No description provided for @asInSettings.
  ///
  /// In ru, this message translates to:
  /// **'Как в настройках'**
  String get asInSettings;

  /// No description provided for @deleteTask.
  ///
  /// In ru, this message translates to:
  /// **'Удалить задачу'**
  String get deleteTask;

  /// No description provided for @deleteTaskTitle.
  ///
  /// In ru, this message translates to:
  /// **'Удалить задачу?'**
  String get deleteTaskTitle;

  /// No description provided for @deleteTaskBody.
  ///
  /// In ru, this message translates to:
  /// **'«{title}» будет удалена вместе с подзадачами.'**
  String deleteTaskBody(String title);

  /// No description provided for @alarmIn.
  ///
  /// In ru, this message translates to:
  /// **'Через {duration}'**
  String alarmIn(String duration);

  /// No description provided for @settingsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get settingsTitle;

  /// No description provided for @sectionAlarm.
  ///
  /// In ru, this message translates to:
  /// **'Будильник'**
  String get sectionAlarm;

  /// No description provided for @settingSound.
  ///
  /// In ru, this message translates to:
  /// **'Мелодия'**
  String get settingSound;

  /// No description provided for @settingVolume.
  ///
  /// In ru, this message translates to:
  /// **'Громкость'**
  String get settingVolume;

  /// No description provided for @volumeSystem.
  ///
  /// In ru, this message translates to:
  /// **'Как в системе'**
  String get volumeSystem;

  /// No description provided for @volumeAtLeast.
  ///
  /// In ru, this message translates to:
  /// **'Не тише {percent}%'**
  String volumeAtLeast(int percent);

  /// No description provided for @volumeSystemHint.
  ///
  /// In ru, this message translates to:
  /// **'Не трогать громкость будильника'**
  String get volumeSystemHint;

  /// No description provided for @settingRamp.
  ///
  /// In ru, this message translates to:
  /// **'Плавное нарастание'**
  String get settingRamp;

  /// No description provided for @rampOff.
  ///
  /// In ru, this message translates to:
  /// **'Сразу'**
  String get rampOff;

  /// No description provided for @seconds.
  ///
  /// In ru, this message translates to:
  /// **'{n} с'**
  String seconds(int n);

  /// No description provided for @minutes.
  ///
  /// In ru, this message translates to:
  /// **'{n} мин'**
  String minutes(int n);

  /// No description provided for @settingVibration.
  ///
  /// In ru, this message translates to:
  /// **'Вибрация'**
  String get settingVibration;

  /// No description provided for @vibrationOff.
  ///
  /// In ru, this message translates to:
  /// **'Без вибрации'**
  String get vibrationOff;

  /// No description provided for @vibrationGentle.
  ///
  /// In ru, this message translates to:
  /// **'Мягкая'**
  String get vibrationGentle;

  /// No description provided for @vibrationStandard.
  ///
  /// In ru, this message translates to:
  /// **'Обычная'**
  String get vibrationStandard;

  /// No description provided for @vibrationPulse.
  ///
  /// In ru, this message translates to:
  /// **'Пульс'**
  String get vibrationPulse;

  /// No description provided for @vibrationHeartbeat.
  ///
  /// In ru, this message translates to:
  /// **'Сердцебиение'**
  String get vibrationHeartbeat;

  /// No description provided for @vibrationStrong.
  ///
  /// In ru, this message translates to:
  /// **'Сильная'**
  String get vibrationStrong;

  /// No description provided for @settingSnooze.
  ///
  /// In ru, this message translates to:
  /// **'Отложить на'**
  String get settingSnooze;

  /// No description provided for @settingAutoSilence.
  ///
  /// In ru, this message translates to:
  /// **'Замолчать через'**
  String get settingAutoSilence;

  /// No description provided for @testAlarm.
  ///
  /// In ru, this message translates to:
  /// **'Проверить будильник'**
  String get testAlarm;

  /// No description provided for @testAlarmHint.
  ///
  /// In ru, this message translates to:
  /// **'Прозвенит через 10 секунд'**
  String get testAlarmHint;

  /// No description provided for @testAlarmScheduled.
  ///
  /// In ru, this message translates to:
  /// **'Прозвенит через 10 секунд — можно заблокировать экран'**
  String get testAlarmScheduled;

  /// No description provided for @sectionTasks.
  ///
  /// In ru, this message translates to:
  /// **'Задачи'**
  String get sectionTasks;

  /// No description provided for @settingAllDayTime.
  ///
  /// In ru, this message translates to:
  /// **'Задачи без времени напоминают в'**
  String get settingAllDayTime;

  /// No description provided for @sectionNotifications.
  ///
  /// In ru, this message translates to:
  /// **'Уведомления'**
  String get sectionNotifications;

  /// No description provided for @settingPinNext.
  ///
  /// In ru, this message translates to:
  /// **'Ближайшая задача в шторке'**
  String get settingPinNext;

  /// No description provided for @settingPinNextHint.
  ///
  /// In ru, this message translates to:
  /// **'Постоянное уведомление с отсчётом до следующей задачи'**
  String get settingPinNextHint;

  /// No description provided for @settingNotificationSound.
  ///
  /// In ru, this message translates to:
  /// **'Звук уведомлений'**
  String get settingNotificationSound;

  /// No description provided for @settingNotificationSoundHint.
  ///
  /// In ru, this message translates to:
  /// **'Настраивается в системе'**
  String get settingNotificationSoundHint;

  /// No description provided for @sectionReliability.
  ///
  /// In ru, this message translates to:
  /// **'Надёжность'**
  String get sectionReliability;

  /// No description provided for @reliabilityAllGood.
  ///
  /// In ru, this message translates to:
  /// **'Всё настроено — будильники прозвенят вовремя'**
  String get reliabilityAllGood;

  /// No description provided for @reliabilityIssues.
  ///
  /// In ru, this message translates to:
  /// **'Что-то может помешать будильникам'**
  String get reliabilityIssues;

  /// No description provided for @permNotifications.
  ///
  /// In ru, this message translates to:
  /// **'Уведомления'**
  String get permNotifications;

  /// No description provided for @permNotificationsHint.
  ///
  /// In ru, this message translates to:
  /// **'Без них будильник не сможет показаться'**
  String get permNotificationsHint;

  /// No description provided for @permExactAlarms.
  ///
  /// In ru, this message translates to:
  /// **'Точные будильники'**
  String get permExactAlarms;

  /// No description provided for @permExactAlarmsHint.
  ///
  /// In ru, this message translates to:
  /// **'Нужны, чтобы звонить минута в минуту'**
  String get permExactAlarmsHint;

  /// No description provided for @permFullScreen.
  ///
  /// In ru, this message translates to:
  /// **'Полноэкранный звонок'**
  String get permFullScreen;

  /// No description provided for @permFullScreenHint.
  ///
  /// In ru, this message translates to:
  /// **'Будильник поверх экрана блокировки'**
  String get permFullScreenHint;

  /// No description provided for @permBattery.
  ///
  /// In ru, this message translates to:
  /// **'Работа в фоне'**
  String get permBattery;

  /// No description provided for @permBatteryHint.
  ///
  /// In ru, this message translates to:
  /// **'Не ограничивать расход батареи'**
  String get permBatteryHint;

  /// No description provided for @permAlarmChannel.
  ///
  /// In ru, this message translates to:
  /// **'Канал «Будильники»'**
  String get permAlarmChannel;

  /// No description provided for @permAlarmChannelHint.
  ///
  /// In ru, this message translates to:
  /// **'Отключён в настройках уведомлений'**
  String get permAlarmChannelHint;

  /// No description provided for @permRestricted.
  ///
  /// In ru, this message translates to:
  /// **'Фоновая работа ограничена'**
  String get permRestricted;

  /// No description provided for @permRestrictedHint.
  ///
  /// In ru, this message translates to:
  /// **'Система перевела Klar в режим ограничений'**
  String get permRestrictedHint;

  /// No description provided for @permFix.
  ///
  /// In ru, this message translates to:
  /// **'Включить'**
  String get permFix;

  /// No description provided for @forceStoppedBanner.
  ///
  /// In ru, this message translates to:
  /// **'Klar был остановлен принудительно, будильники восстановлены. Не используйте «Остановить» — Android отменяет все будильники приложения.'**
  String get forceStoppedBanner;

  /// No description provided for @oemHint.
  ///
  /// In ru, this message translates to:
  /// **'На телефонах Xiaomi, Huawei, Honor, OPPO и Samsung разрешите Klar также автозапуск и работу без ограничений.'**
  String get oemHint;

  /// No description provided for @soundPickerTitle.
  ///
  /// In ru, this message translates to:
  /// **'Мелодия'**
  String get soundPickerTitle;

  /// No description provided for @soundSectionKlar.
  ///
  /// In ru, this message translates to:
  /// **'Klar'**
  String get soundSectionKlar;

  /// No description provided for @soundSectionDevice.
  ///
  /// In ru, this message translates to:
  /// **'С устройства'**
  String get soundSectionDevice;

  /// No description provided for @soundSystemDefault.
  ///
  /// In ru, this message translates to:
  /// **'Стандартный будильник'**
  String get soundSystemDefault;

  /// No description provided for @soundPickSystem.
  ///
  /// In ru, this message translates to:
  /// **'Выбрать из системных…'**
  String get soundPickSystem;

  /// No description provided for @soundPickFile.
  ///
  /// In ru, this message translates to:
  /// **'Свой файл…'**
  String get soundPickFile;

  /// No description provided for @soundSilent.
  ///
  /// In ru, this message translates to:
  /// **'Без звука'**
  String get soundSilent;

  /// No description provided for @vibrationPickerTitle.
  ///
  /// In ru, this message translates to:
  /// **'Вибрация'**
  String get vibrationPickerTitle;

  /// No description provided for @onboardingTagline.
  ///
  /// In ru, this message translates to:
  /// **'Задачи, которые звонят вовремя'**
  String get onboardingTagline;

  /// No description provided for @onboardingBody.
  ///
  /// In ru, this message translates to:
  /// **'Чтобы будильники срабатывали даже на заблокированном экране, разрешите Klar несколько вещей.'**
  String get onboardingBody;

  /// No description provided for @onboardingNotifications.
  ///
  /// In ru, this message translates to:
  /// **'Уведомления'**
  String get onboardingNotifications;

  /// No description provided for @onboardingFullScreen.
  ///
  /// In ru, this message translates to:
  /// **'Полноэкранный звонок'**
  String get onboardingFullScreen;

  /// No description provided for @onboardingBattery.
  ///
  /// In ru, this message translates to:
  /// **'Работа в фоне'**
  String get onboardingBattery;

  /// No description provided for @onboardingAllow.
  ///
  /// In ru, this message translates to:
  /// **'Разрешить'**
  String get onboardingAllow;

  /// No description provided for @onboardingStart.
  ///
  /// In ru, this message translates to:
  /// **'Начать'**
  String get onboardingStart;
}

class _L10nDelegate extends LocalizationsDelegate<L10n> {
  const _L10nDelegate();

  @override
  Future<L10n> load(Locale locale) {
    return SynchronousFuture<L10n>(lookupL10n(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_L10nDelegate old) => false;
}

L10n lookupL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ru':
      return L10nRu();
  }

  throw FlutterError(
    'L10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
