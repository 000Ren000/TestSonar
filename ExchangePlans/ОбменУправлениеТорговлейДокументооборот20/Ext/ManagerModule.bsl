﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область НастройкиПоУмолчанию

// Заполняет настройки, влияющие на использование плана обмена.
//
// Параметры:
//   Настройки - Структура - настройки плана обмена по умолчанию, см. ОбменДаннымиСервер.НастройкиПланаОбменаПоУмолчанию,
//                           описание возвращаемого значения функции.
//
Процедура ПриПолученииНастроек(Настройки) Экспорт
	
	Настройки.ИмяКонфигурацииИсточника = "УправлениеТорговлей";
	Настройки.ИмяКонфигурацииПриемника.Вставить("Документооборот", Неопределено);
	
	Настройки.ПредупреждатьОНесоответствииВерсийПравилОбмена	= Ложь;
	Настройки.ПланОбменаИспользуетсяВМоделиСервиса				= Ложь;
	
	Настройки.Алгоритмы.ПриПолученииВариантовНастроекОбмена				= Истина;
	Настройки.Алгоритмы.ПриПолученииОписанияВариантаНастройки			= Истина;
	Настройки.Алгоритмы.НастроитьИнтерактивнуюВыгрузку					= Истина;
	Настройки.Алгоритмы.НастроитьИнтерактивнуюВыгрузкуВМоделиСервиса	= Истина;
	Настройки.Алгоритмы.ПредставлениеОтбораИнтерактивнойВыгрузки		= Истина;
	
КонецПроцедуры

// Заполняет набор параметров, определяющих вариант настройки обмена.
//
// Параметры:
//   ОписаниеВарианта       - Структура - набор варианта настройки по умолчанию,
//                                        см. ОбменДаннымиСервер.ОписаниеВариантаНастройкиОбменаПоУмолчанию,
//                                        описание возвращаемого значения.
//   ИдентификаторНастройки - Строка    - идентификатор варианта настройки обмена.
//   ПараметрыКонтекста     - Структура - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияОписанияВариантаНастройки,
//                                        описание возвращаемого значения функции.
//
Процедура ПриПолученииОписанияВариантаНастройки(ОписаниеВарианта, ИдентификаторНастройки, ПараметрыКонтекста) Экспорт
	
	ОписаниеВарианта.ИмяКонфигурацииКорреспондента = "Документооборот";
	
	ОписаниеВарианта.ИмяФайлаНастроекДляПриемника = НСтр("ru = 'Настройки обмена УТ-ДО'");
	
	ОписаниеВарианта.ЗаголовокКомандыДляСозданияНовогоОбменаДанными	= ЗаголовокКомандыДляСозданияНовогоОбменаДанными();
	ОписаниеВарианта.НаименованиеКонфигурацииКорреспондента			= ЗаголовокКомандыДляСозданияНовогоОбменаДанными();
	ОписаниеВарианта.ИспользоватьПомощникСозданияОбменаДанными		= Истина;
	ОписаниеВарианта.ИспользуемыеТранспортыСообщенийОбмена =
		ОбменДаннымиСервер.ВсеТранспортыСообщенийОбменаКонфигурации();
	ОписаниеВарианта.КраткаяИнформацияПоОбмену = 
		НСтр("ru = 'Данная настройка позволит синхронизировать данные между программами 
		|""1С:Управление торговлей, редакция 11"", и ""1С:Документооборот, редакция 2"".'");
	ОписаниеВарианта.ПодробнаяИнформацияПоОбмену =
		"ПланОбмена.ОбменУправлениеТорговлейДокументооборот20.Форма.ПодробнаяИнформация";
	ОписаниеВарианта.ЗаголовокПомощникаСозданияОбмена =
		НСтр("ru='Настройка синхронизации с 1С:Документооборотом, ред. 2'");
	ОписаниеВарианта.ЗаголовокУзлаПланаОбмена = НСтр("ru='Синхронизация с 1С:Документооборотом, ред. 2'");
	
КонецПроцедуры

#КонецОбласти

#Область ПереопределяемаяНастройкаДополненияВыгрузки

// Предназначена для настройки вариантов интерактивной настройки выгрузки по сценарию узла.
// Для настройки необходимо установить значения свойств параметров в необходимые значения.
//
// Используется для контроля режимов работы помощника интерактивного обмена данными.
//
// Параметры:
//   Получатель - ПланОбменаСсылка - Узел, для которого производится настройка
//   Параметры  - Структура        - Параметры для изменения. Содержит поля:
//
//       ВариантБезДополнения - Структура     - настройки типового варианта "Не добавлять".
//                                              Содержит поля:
//           Использование - Булево - флаг разрешения использования варианта. По умолчанию Истина.
//           Порядок       - Число  - порядок размещения варианта на форме помощника, сверху вниз. По умолчанию 1.
//           Заголовок     - Строка - позволяет переопределить название типового варианта.
//           Пояснение     - Строка - позволяет переопределить текст пояснения варианта для пользователя.
//
//       ВариантВсеДокументы - Структура      - настройки типового варианта "Добавить все документы за период".
//                                              Содержит поля:
//           Использование - Булево - флаг разрешения использования варианта. По умолчанию Истина.
//           Порядок       - Число  - порядок размещения варианта на форме помощника, сверху вниз. По умолчанию 2.
//           Заголовок     - Строка - позволяет переопределить название типового варианта.
//           Пояснение     - Строка - позволяет переопределить текст пояснения варианта для пользователя.
//
//       ВариантПроизвольныйОтбор - Структура - настройки типового варианта "Добавить данные с произвольным отбором".
//                                              Содержит поля:
//           Использование - Булево - флаг разрешения использования варианта. По умолчанию Истина.
//           Порядок       - Число  - порядок размещения варианта на форме помощника, сверху вниз. По умолчанию 3.
//           Заголовок     - Строка - позволяет переопределить название типового варианта.
//           Пояснение     - Строка - позволяет переопределить текст пояснения варианта для пользователя.
//
//       ВариантДополнительно - Структура     - настройки дополнительного варианта по сценарию узла.
//                                              Содержит поля:
//           Использование            - Булево            - флаг разрешения использования варианта. По умолчанию Ложь.
//           Порядок                  - Число             - порядок размещения варианта на форме помощника, сверху
//                                                          вниз. По умолчанию 4.
//           Заголовок                - Строка            - название варианта для отображения на форме.
//           ИмяФормыОтбора           - Cтрока            - Имя формы, вызываемой для редактирования настроек.
//           ЗаголовокКомандыФормы    - Cтрока            - Заголовок для отрисовки на форме команды открытия формы настроек.
//           ИспользоватьПериодОтбора - Булево            - флаг того, что необходим общий отбор по периоду. По
//                                                          умолчанию Ложь.
//           ПериодОтбора             - СтандартныйПериод - значение периода общего отбора, предлагаемого по умолчанию.
//
//           Отбор                    - ТаблицаЗначений   - содержит строки с описанием подробных отборов по сценарию узла.
//                                                          Содержит колонки:
//               ПолноеИмяМетаданных - Строка                - полное имя метаданных регистрируемого объекта, отбор
//                                                             которого описывает строка. Например
//                                                             "Документ._ДемоПоступлениеТоваров". Можно  использовать
//                                                             специальные значения "ВсеДокументы" и "ВсеСправочники"
//                                                             для отбора соответственно всех документов и всех
//                                                             справочников, регистрирующихся на узле Получатель.
//               ВыборПериода        - Булево                - флаг того, что данная строка описывает отбор с общим периодом.
//               Период              - СтандартныйПериод     - значение периода общего отбора для метаданных строки,
//                                                             предлагаемого по умолчанию.
//               Отбор               - ОтборКомпоновкиДанных - отбор по умолчанию. Поля отбора формируются в
//                                                             соответствии с общим правилами формирования полей
//                                                             компоновки. Например, для указания отбора по реквизиту
//                                                             документа "Организация", необходимо использовать поле "Ссылка.Организация".
//
//
//   Если для всех вариантов флаги разрешения использования установлены в Ложь, то страница дополнения выгрузки в помощнике
//   интерактивного обмена данными будет пропущена и дополнительная регистрация объектов производится не будет.
//   Например, инициализация вида:
//
//        Параметры.ВариантВсеДокументы.Использование      = Ложь;
//        Параметры.ВариантБезДополнения.Использование     = Ложь;
//        Параметры.ВариантПроизвольныйОтбор.Использование = Ложь;
//        Параметры.ВариантДополнительно.Использование     = Ложь;
//
//   Приведет к тому, что шаг дополнения выгрузки будет полностью пропущен.
//
Процедура НастроитьИнтерактивнуюВыгрузку(Получатель, Параметры) Экспорт
	
	Параметры.ВариантВсеДокументы.Использование      = Ложь;
	Параметры.ВариантБезДополнения.Использование     = Ложь;
	Параметры.ВариантПроизвольныйОтбор.Использование = Ложь;
	Параметры.ВариантДополнительно.Использование     = Ложь;
	
КонецПроцедуры

Процедура НастроитьИнтерактивнуюВыгрузкуВМоделиСервиса(Получатель, Параметры) Экспорт
	
	Параметры.ВариантВсеДокументы.Использование      = Ложь;
	Параметры.ВариантБезДополнения.Использование     = Ложь;
	Параметры.ВариантПроизвольныйОтбор.Использование = Ложь;
	Параметры.ВариантДополнительно.Использование     = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

// Заполняет коллекцию вариантов настроек, предусмотренных для плана обмена.
//
// Параметры:
//   ВариантыНастроекОбмена - ТаблицаЗначений - коллекция вариантов настроек обмена, см. описание возвращаемого значения
//                                        функции НастройкиПланаОбменаПоУмолчанию общего модуля ОбменДаннымиСервер.
//   ПараметрыКонтекста     - Структура - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияВариантовНастроек,
//                                        описание возвращаемого значения функции.
//
Процедура ПриПолученииВариантовНастроекОбмена(ВариантыНастроекОбмена, ПараметрыКонтекста) Экспорт
	
	ВариантНастройки = ВариантыНастроекОбмена.Добавить();
	
	ВариантНастройки.ИдентификаторНастройки			= "УТ";
	ВариантНастройки.КорреспондентВМоделиСервиса	= Истина;
	ВариантНастройки.КорреспондентВЛокальномРежиме	= Истина;
	
КонецПроцедуры

// Возвращает режим запуска, в случае интерактивного инициирования синхронизации.
//
Функция РежимЗапускаСинхронизацииДанных(УзелИнформационнойБазы) Экспорт
	
	Возврат "";
	
КонецФункции

// Возвращает сценарий работы помощника интерактивного сопоставления
// НеОтправлять, ИнтерактивнаяСинхронизацияДокументов, ИнтерактивнаяСинхронизацияСправочников либо пустую строку.
//
Функция ИнициализироватьСценарийРаботыПомощникаИнтерактивногоОбмена(УзелИнформационнойБазы) Экспорт
	
	Возврат "";
	
КонецФункции

// Возвращает значения ограничений объектов узла плана обмена для интерактивной регистрации к обмену.
// Структура: ВсеДокументы, ВсеСправочники, ДетальныйОтбор.
// Детальный отбор либо неопределено, либо массив объектов метаданных входящих в состав узла (Указывается полное имя метаданных).
//
Функция ДобавитьГруппыОграничений(УзелИнформационнойБазы) Экспорт
	
	Возврат Новый Структура("ВсеДокументы, ВсеСправочники, ДетальныйОтбор", Ложь, Ложь, Неопределено);
	
КонецФункции

// Возвращает представление команды создания нового обмена данными.
//
// Возвращаемое значение:
//   Строка, Неогранич - представление команды, выводимое в пользовательском интерфейсе.
//
// Например:
//	Возврат НСтр("ru = 'Создать обмен в распределенной информационной базе'");
//
Функция ЗаголовокКомандыДляСозданияНовогоОбменаДанными() Экспорт
	
	Возврат НСтр("ru = '1С:Документооборот КОРП, ред. 2'");
	
КонецФункции

// Обработчик события коллизий изменений объектов.
// Условие возникновения: 
// Событие возникает при загрузке данных,
// в случае коллизии изменений загружаемого объекта.
// Коллизия изменений возникает, когда в информационной базе 
// зарегистрированы изменения для загружаемого объекта.
//
// Параметры:
//   УзелИнформационнойБазы - ПланОбменаСсылка - узел плана обмена для которого выполняется загрузка данных.
//   Объект - объект, для которого возникла коллизия изменений.
//
// Возвращаемое значение:
//   Булево - Истина - загружаемый объект будет записан в информационную базу;
//            Ложь - загружаемый объект записан не будет.
//
Функция ПрименитьОбъектПриКоллизииИзменений(УзелИнформационнойБазы, Объект) Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Возвращает представление отбора для варианта дополнения выгрузки по сценарию узла.
// См. описание "ВариантДополнительно" в процедуре "НастроитьИнтерактивнуюВыгрузку"
//
// Параметры:
//   Получатель - ПланОбменаСсылка - Узел, для которого определяется представление отбора
//   Параметры  - Структура        - Характеристики отбора. Содержит поля:
//       ИспользоватьПериодОтбора - Булево            - флаг того, что необходимо использовать общий отбор по периоду.
//       ПериодОтбора             - СтандартныйПериод - значение периода общего отбора.
//       Отбор                    - ТаблицаЗначений   - содержит строки с описанием подробных отборов по сценарию узла.
//                                                      Содержит колонки:
//               ПолноеИмяМетаданных - Строка                - полное имя метаданных регистрируемого объекта, отбор которого описывает строка.
//                                                             Например "Документ._ДемоПоступлениеТоваров". Могут быть использованы специальные 
//                                                             значения "ВсеДокументы" и "ВсеСправочники" для отбора соответственно всех 
//                                                             документов и всех справочников, регистрирующихся на узле Получатель.
//               ВыборПериода        - Булево                - флаг того, что данная строка описывает отбор с общим периодом.
//               Период              - СтандартныйПериод     - значение периода общего отбора для метаданных строки.
//               Отбор               - ОтборКомпоновкиДанных - поля отбора. Поля отбора формируются в соответствии с общим правилами
//                                                             формирования полей компоновки. Например, для указания отбора по реквизиту
//                                                             документа "Организация", будет использовано поле "Ссылка.Организация"
//
// Возвращаемое значение: 
//   Строка - описание отбора
//
Функция ПредставлениеОтбораИнтерактивнойВыгрузки(Получатель, Параметры) Экспорт
	
	Возврат "";
	
КонецФункции

#КонецОбласти

#КонецЕсли