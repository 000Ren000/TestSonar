﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	НавигационнаяСсылка = "e1cib/app/Обработка.ЖурналДокументовОтчетыКомиссионеров";
	
	ИспользуемыеТипыДокументов = Новый Массив;
	ИспользуемыеТипыДокументов.Добавить(Тип("ДокументСсылка.ОтчетКомиссионера"));
	ИспользуемыеТипыДокументов.Добавить(Тип("ДокументСсылка.ОтчетКомиссионераОСписании"));
		
	Элементы.ТоварыПереданныеСоздатьОтчетКомиссионераОПродажах.Видимость = 
		ПравоДоступа("Добавление", Метаданные.Документы.ОтчетКомиссионера);
	Элементы.ТоварыПереданныеСоздатьОтчетКомиссионераОСписании.Видимость = 
		ПравоДоступа("Добавление", Метаданные.Документы.ОтчетКомиссионераОСписании);
		
	Элементы.ТоварыПереданныеОрганизация.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	Элементы.Контрагент.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровИКонтрагентов");
	
	Список.Параметры.УстановитьЗначениеПараметра("ИдОбъектаОтчетКомиссионера",
		ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.ОтчетКомиссионера"));
	Список.Параметры.УстановитьЗначениеПараметра("ИдОбъектаОтчетКомиссионераОСписании",
		ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.ОтчетКомиссионераОСписании"));
	
	ТипыДокументов = Новый Массив();
	ТипыДокументов.Добавить("Документ.ОтчетКомиссионера");
	ТипыДокументов.Добавить("Документ.ОтчетКомиссионераОСписании");
	
	ОбщегоНазначенияУТ.ЗаменитьПолеСсылкаКонструкциейВыразитьПоТипамДокументов(Элементы.Список,
		ТипыДокументов);
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриСозданииНаСервереСписокДокументов(Список);
	
	Если ПроверкаКонтрагентовВызовСервера.ИспользованиеПроверкиВозможно() Тогда
		Элементы.ЕстьОшибкиПроверкиКонтрагентов.Видимость = Истина;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами 
	
	ИспользуемыеТипыДокументов.Добавить(Тип("ДокументСсылка.Сторно"));
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = Новый ОписаниеТипов(ИспользуемыеТипыДокументов);
	ПараметрыРазмещения.КоманднаяПанель = Элементы.СписокКоманднаяПанель;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма, Элементы.СписокКоманднаяПанель);
	// Конец ИнтеграцияС1СДокументооборотом
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыПриСозданииНаСервере = ОбменСКонтрагентами.ПараметрыПриСозданииНаСервере_ФормаСписка();
	ПараметрыПриСозданииНаСервере.Форма = ЭтотОбъект;
	ПараметрыПриСозданииНаСервере.МестоРазмещенияКоманд = Элементы.ПодменюЭДО;
	ПараметрыПриСозданииНаСервере.КолонкаСостоянияЭДО = Элементы.СостояниеЭДО;
	ОбменСКонтрагентами.ПриСозданииНаСервере_ФормаСписка(ПараметрыПриСозданииНаСервере);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	УстановитьОтбор();
	УстановитьПараметрыДинамическихСписков();
	УстановитьТекущуюСтраницу();
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Комиссионер = Настройки.Получить("Комиссионер");
	УстановитьОтбор();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентамиКлиент.ПриОткрытии(ЭтотОбъект);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтаФорма, "СканерШтрихкода");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияУТКлиент.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияУТКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	Если ИмяСобытия = "Запись_ОтчетКомиссионера"
		ИЛИ ИмяСобытия = "Запись_ОтчетКомиссионераОСписании"
		ИЛИ ИмяСобытия = "ЗаписьСторно"
		ИЛИ ИмяСобытия = "Проведение_Сторно" Тогда
		Элементы.ТоварыПереданные.Обновить();
		Элементы.Список.Обновить();
	КонецЕсли;
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыОповещенияЭДО = ОбменСКонтрагентамиКлиент.ПараметрыОповещенияЭДО_ФормаСписка();
	ПараметрыОповещенияЭДО.Форма = ЭтотОбъект;
	ПараметрыОповещенияЭДО.ИмяДинамическогоСписка = "Список";
	ПараметрыОповещенияЭДО.ЕстьОбработчикОбновленияВидимостиСостоянияЭДО = Истина;
	ОбменСКонтрагентамиКлиент.ОбработкаОповещения_ФормаСписка(ИмяСобытия, Параметр, Источник, ПараметрыОповещенияЭДО);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КомиссионерПриИзменении(Элемент)
	
	УстановитьОтбор();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодВариантПриИзменении(Элемент)
	
	УстановитьПараметрыДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодДатаНачалаПриИзменении(Элемент)
	
	Если Период.ДатаНачала > Период.ДатаОкончания Тогда
		Период.ДатаОкончания = Период.ДатаНачала;
	КонецЕсли;
	
	УстановитьПараметрыДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодДатаОкончанияПриИзменении(Элемент)
	
	Если Период.ДатаНачала > Период.ДатаОкончания Тогда
		Период.ДатаНачала = Период.ДатаОкончания;
	КонецЕсли;

	УстановитьПараметрыДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если ТекущаяСтраница = Элементы.СтраницаКомиссионеры Тогда
		Элементы.ТоварыПереданные.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбщегоНазначенияУТКлиент.ИзменитьЭлемент(Элемент);

	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	Если Поле = Элементы.СостояниеЭДО Тогда
		ОбменСКонтрагентамиКлиент.СостояниеЭДОНажатие_ФормаСписка(Элемент.ТекущиеДанные.Ссылка, СтандартнаяОбработка);
	КонецЕсли;
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ОбщегоНазначенияУТКлиент.ИзменитьЭлемент(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Копирование Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	ОбщегоНазначенияУТКлиент.УстановитьПометкуУдаления(Элемент, Заголовок);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СписокПровести(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиДокументы(Элементы.Список, Заголовок);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОтменаПроведения(Команда)
	
	ОбщегоНазначенияУТКлиент.ОтменаПроведения(Элементы.Список, Заголовок);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокУстановитьСнятьПометкуУдаления(Команда)
	
	ОбщегоНазначенияУТКлиент.УстановитьПометкуУдаления(Элементы.Список, Заголовок);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервал(Команда)
	
	Оповещение = Новый ОписаниеОповещения("УстановитьИнтервалЗавершение", ЭтотОбъект);
	
	ОбщегоНазначенияУтКлиент.РедактироватьПериод(Период, , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервалЗавершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Период = ВыбранноеЗначение;
	УстановитьОтборПоПериоду();
	
КонецПроцедуры
&НаКлиенте
Процедура СоздатьОтчетКомиссионераОПродажах(Команда)
	
	Строка = Элементы.ТоварыПереданные.ТекущиеДанные;
	Если Строка <> Неопределено Тогда
		СтруктураПараметры = СтруктураПараметровОтчетаКомиссионера(Строка);
		ОткрытьФорму("Документ.ОтчетКомиссионера.ФормаОбъекта", СтруктураПараметры, Элементы.Список);
	Иначе
		ОткрытьФорму("Документ.ОтчетКомиссионера.ФормаОбъекта", , Элементы.Список);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьОтчетКомиссионераОСписании(Команда)
	
	Строка = Элементы.ТоварыПереданные.ТекущиеДанные;
	Если Строка <> Неопределено Тогда
		СтруктураПараметры = СтруктураПараметровОтчетаКомиссионера(Строка);
		ОткрытьФорму("Документ.ОтчетКомиссионераОСписании.ФормаОбъекта", СтруктураПараметры, Элементы.Список);
	Иначе
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Команда не может быть выполнена для указанного объекта.'"));
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

// ЭлектронноеВзаимодействие.ОбменСКонтрагентами

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	
	ЭлектронноеВзаимодействиеКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОжиданияЭДО()
	
	ОбменСКонтрагентамиКлиент.ОбработчикОжиданияЭДО(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьВидимостьСостоянияЭДО()
	
	ОбменСКонтрагентамиКлиент.ОбработчикОбновленияВидимостьСостоянияЭДО(ЭтотОбъект, Элементы.СостояниеЭДО);
	
КонецПроцедуры

// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтбор()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Партнер",
		Комиссионер,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(Комиссионер));
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ТоварыПереданные,
		"АналитикаУчетаНоменклатуры.МестоХранения",
		Комиссионер,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(Комиссионер));
	УстановитьОтборПоПериоду();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоПериоду()
	
	Список.Параметры.УстановитьЗначениеПараметра("НачалоПериода",
		Период.ДатаНачала);
	Список.Параметры.УстановитьЗначениеПараметра("КонецПериода", 
		?(ЗначениеЗаполнено(Период.ДатаОкончания), Период.ДатаОкончания, КонецДня(Дата(3999, 12, 31))));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекущуюСтраницу()
	
	ИмяТекущейСтраницы = "";
	
	Если Параметры.Свойство("ИмяТекущейСтраницы", ИмяТекущейСтраницы) Тогда
		Если ЗначениеЗаполнено(ИмяТекущейСтраницы) Тогда
			ТекущийЭлемент = Элементы[ИмяТекущейСтраницы];
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция СтруктураПараметровОтчетаКомиссионера(Строка)
	
	СтруктураОснование = Новый Структура;
	СтруктураОснование.Вставить("Организация", Строка.Организация);
	СтруктураОснование.Вставить("Партнер", Строка.Комиссионер);
	СтруктураОснование.Вставить("Соглашение", Строка.Соглашение);
	СтруктураОснование.Вставить("НачалоПериода", Период.ДатаНачала);
	СтруктураОснование.Вставить("КонецПериода", Период.ДатаОкончания);
	СтруктураОснование.Вставить("ПоРезультатамИнвентаризации", Истина);
	СтруктураОснование.Вставить("ЗаполнятьПоСоглашению", Истина);
	
	СтруктураПараметры = Новый Структура;
	СтруктураПараметры.Вставить("Основание", СтруктураОснование);
	
	Возврат СтруктураПараметры;
	
КонецФункции

&НаСервере
Процедура УстановитьПараметрыДинамическихСписков()
	
	ДатаОстатков = ?(ЗначениеЗаполнено(Период.ДатаОкончания), Период.ДатаОкончания, '00010101');
	
	Если ЗначениеЗаполнено(ДатаОстатков) Тогда
		Граница = Новый Граница(КонецДня(ДатаОстатков), ВидГраницы.Включая);
	Иначе
		Граница = ДатаОстатков;
	КонецЕсли;
	
	ТоварыПереданные.Параметры.УстановитьЗначениеПараметра("Граница", Граница);
	
КонецПроцедуры

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ОтчетКомиссионера.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ОтчетКомиссионераОСписании.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		Ссылка = МассивСсылок[0];
		Элементы.Список.ТекущаяСтрока = Ссылка;
		ПоказатьЗначение(Неопределено, Ссылка);
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
