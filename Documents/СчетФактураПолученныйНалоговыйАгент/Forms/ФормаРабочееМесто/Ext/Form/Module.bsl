﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	//Получение ФО
	ИспользоватьПартнеровКакКонтрагентов = ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов");
	ИспользоватьДоговорыСКлиентами = ПолучитьФункциональнуюОпцию("ИспользоватьДоговорыСКлиентами");
	
	ТипыОснований = Метаданные.Документы.СчетФактураПолученныйНалоговыйАгент.ТабличныеЧасти.ДокументыОснования.Реквизиты.ДокументОснование.Тип;
	
	
	// Установка отборов.
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		СтруктураБыстрогоОтбора.Свойство("Организация", Организация);
		СтруктураБыстрогоОтбора.Свойство("Контрагент",  Контрагент);
	КонецЕсли;
	
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(СписокСчетовФактурыНаОформление,
		"Организация", Организация, СтруктураБыстрогоОтбора);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(СписокСчетовФактурыНаОформление,
		"Контрагент", Контрагент, СтруктураБыстрогоОтбора);
		
	ПараметрыЗапроса = ПараметрыЗапросаСчетаФактурыКОформлению();
	Для Каждого ТекПараметр Из ПараметрыЗапроса Цикл
		СписокСчетовФактурыНаОформление.Параметры.УстановитьЗначениеПараметра(ТекПараметр.Ключ, ТекПараметр.Значение);
	КонецЦикла;
	
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	СвойстваСписка.ОсновнаяТаблица = "";
	СвойстваСписка.ДинамическоеСчитываниеДанных = Ложь;
	СвойстваСписка.ТекстЗапроса = ТекстЗапросаДанныхОснованийКОформлениюСчетФактур();
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.СписокСчетовФактурыНаОформление, СвойстваСписка);
	
	ЗаполнитьСчетаФактурыВПути();
	СчетаФактурыВПутиПоказывать = Не СчетаФактурыВПутиКоличество = 0;
	
	УправлениеЭлементамиСтраницыСчетаФактурыКОформлению();
	УправлениеЭлементамиФормы(ЭтотОбъект);
	
	МассивМенеджеровРасчетаСмТакжеВРаботе = Новый Массив();
	МассивМенеджеровРасчетаСмТакжеВРаботе.Добавить("Обработка.ЖурналДокументовНДС");
	СмТакжеВРаботе = ОбщегоНазначенияУТ.СформироватьГиперссылкуСмТакжеВРаботе(МассивМенеджеровРасчетаСмТакжеВРаботе, Неопределено);
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтаФорма, "СканерШтрихкода");
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентамиКлиент.ПриОткрытии(ЭтотОбъект);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
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
	
	МассивТипов = ТипыДокументовОснованийКОформлению();
	МассивТипов.Добавить("СчетФактураПолученныйНалоговыйАгент");
	
	Для Каждого ТипДокумента Из МассивТипов Цикл
		Если ИмяСобытия = "Запись_" + ТипДокумента Тогда
			Элементы.СписокСчетовФактурыНаОформление.Обновить();
			ЗаполнитьСчетаФактурыВПути();
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		СтруктураБыстрогоОтбора.Свойство("Организация", Организация);
		Настройки.Удалить("Организация");
		СтруктураБыстрогоОтбора.Свойство("Контрагент", Контрагент);
		Настройки.Удалить("Контрагент");
	Иначе
		Организация = Настройки.Получить("Организация");
		Контрагент  = Настройки.Получить("Контрагент");
	КонецЕсли;
	
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(СписокСчетовФактурыНаОформление, 
		"Организация", Организация, СтруктураБыстрогоОтбора, Настройки);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(СписокСчетовФактурыНаОформление, 
		"Контрагент", Контрагент, СтруктураБыстрогоОтбора, Настройки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокСчетовФактурыНаОформление,
		"Организация",
		Организация,
		ВидСравненияКомпоновкиДанных.Равно, ,
		ЗначениеЗаполнено(Организация));
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокСчетовФактурыНаОформление,
		"Контрагент",
		Контрагент,
		ВидСравненияКомпоновкиДанных.Равно, ,
		ЗначениеЗаполнено(Контрагент));
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСчетовФактурыНаОформлениеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПоказатьЗначение(, Элемент.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура СмТакжеВРаботеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	// &ЗамерПроизводительности
	ИмяКлючевойОперации = СтрШаблон("Документ.СчетФактураПолученныйНалоговыйАгент.Форма.ФормаРабочееМесто.СмТакже.%1",
									НавигационнаяСсылкаФорматированнойСтроки);
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, ИмяКлючевойОперации);
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	СтруктураБыстрогоОтбора = Новый Структура;
	
	Если ЗначениеЗаполнено(Организация) Тогда
		ПараметрыФормы.Вставить("Организация", Организация);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Организация) Тогда
		ПараметрыФормы.Вставить("Контрагент", Контрагент);
	КонецЕсли;
	
	ОткрытьФорму(НавигационнаяСсылкаФорматированнойСтроки, ПараметрыФормы, ЭтаФорма, ЭтаФорма.УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокСчетовФактурыНаОформлениеПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСчетаФактурыВПути

&НаКлиенте
Процедура СчетаФактурыВПутиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекДанные = СчетаФактурыВПути.НайтиПоИдентификатору(ВыбраннаяСтрока);
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьЗначение(, ТекДанные.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗарегистрироватьСчетФактуру(Команда)
	
	РезультатЗаполнения = ПолучитьДанныеДляЗаполненияСчетаФактуры();
	Если РезультатЗаполнения.ЕстьОшибки Тогда
		Возврат;
	КонецЕсли;
	
	СоздатьДокументыСчетФактура(РезультатЗаполнения.МассивСсылок, РезультатЗаполнения.ДанныеСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗарегистрироватьСчетФактуруВПути(Команда)
	
	ПустойМассивСсылок = Новый Массив;
	ПустойМассивСсылок.Добавить(Неопределено);
	
	ДанныеСтроки = Новый Структура;
	ДанныеСтроки.Вставить("ДатаПродажи", Дата(1,1,1));
	ДанныеСтроки.Вставить("Корректировка", Ложь);
	ДанныеСтроки.Вставить("Исправление", Ложь);
	ДанныеСтроки.Вставить("Организация", Организация);
	ДанныеСтроки.Вставить("Контрагент", Контрагент);
	
	СоздатьДокументыСчетФактура(ПустойМассивСсылок, ДанныеСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПривязатьСчетФактуруВПути(Команда)
	
	ТекДанные = Элементы.СчетаФактурыВПути.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Укажите счет-фактуру для привязки к документам-основания.'"));
		Возврат;
	КонецЕсли;
	
	РезультатЗаполнения = ПолучитьДанныеДляЗаполненияСчетаФактуры();
	Если РезультатЗаполнения.ЕстьОшибки Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьДокументыОснованияСчетаФактуры(РезультатЗаполнения.МассивСсылок, ТекДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСчетаФактурыВПути(Команда)
	
	ЗаполнитьСчетаФактурыВПути();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьСчетаФактурыВПути(Команда)
	
	СчетаФактурыВПутиПоказывать = Не СчетаФактурыВПутиПоказывать;
	
	УправлениеЭлементамиФормы(ЭтотОбъект);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.СписокСчетовФактурыНаОформление);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.СписокСчетовФактурыНаОформление, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.СписокСчетовФактурыНаОформление);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.СписокСчетовФактурыНаОформление);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// ЭлектронноеВзаимодействие.ОбменСКонтрагентами

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	
	ЭлектронноеВзаимодействиеКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтаФорма, Элементы.СписокСчетовФактурыНаОформление);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОжиданияЭДО()
	
	ОбменСКонтрагентамиКлиент.ОбработчикОжиданияЭДО(ЭтотОбъект);
	
КонецПроцедуры

// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.СчетФактураПолученныйНалоговыйАгент.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		Элементы.СписокСчетовФактурыНаОформление.ТекущаяСтрока = МассивСсылок[0];
		ПоказатьЗначение(,МассивСсылок[0]);
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокСчетовФактурыНаОформлениеСрок.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокСчетовФактурыНаОформление.Срок");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
	ОтборЭлемента.ПравоеЗначение = Константы.СрокВыставленияСчетаФактуры.Получить();
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПросроченныйДокумент);
	
КонецПроцедуры

&НаСервере
Процедура УправлениеЭлементамиСтраницыСчетаФактурыКОформлению()
	
	Элементы.СписокСчетовФактурыНаОформлениеПартнер.Видимость = Не ИспользоватьПартнеровКакКонтрагентов;
	Элементы.СписокСчетовФактурыНаОформлениеДоговор.Видимость = ИспользоватьДоговорыСКлиентами;
	Элементы.СписокСчетовФактурыНаОформлениеОрганизация.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	Элементы.СписокСчетовФактурыНаОформлениеВалюта.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеЭлементамиФормы(Форма)
	
	Форма.Элементы.ГруппаСчетаФактурыВПути.Видимость = Форма.СчетаФактурыВПутиПоказывать;
	Форма.Элементы.СписокСчетовФактурыНаОформлениеПоказыватьСчетаФактурыВПути.Пометка = Форма.СчетаФактурыВПутиПоказывать;
	Форма.Элементы.ЗарегистрироватьСчетФактуруВПути.Видимость = Форма.СчетаФактурыВПутиПоказывать;
	
КонецПроцедуры

&НаСервере
Функция ТекстЗапросаДанныхОснованийКОформлениюСчетФактур(Разрешенные=Ложь)
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТребуетсяОформлениеСчетаФактуры.Организация КАК Организация,
	|	ТребуетсяОформлениеСчетаФактуры.Контрагент КАК Контрагент,
	|	МАКСИМУМ(НАЧАЛОПЕРИОДА(ДанныеОснования.Дата, ДЕНЬ)) КАК ДатаПродажи,
	|	МАКСИМУМ(ДанныеПервичныхДокументов.Номер) КАК Номер,
	|	ТребуетсяОформлениеСчетаФактуры.Основание КАК Ссылка,
	|	ТИПЗНАЧЕНИЯ(ТребуетсяОформлениеСчетаФактуры.Основание) КАК ВидОснования,
	|	МАКСИМУМ(РеестрДокументов.Партнер) КАК Партнер,
	|	МАКСИМУМ(ДанныеОснования.Договор) КАК Договор,
	|	МАКСИМУМ(РеестрДокументов.Ответственный) КАК Менеджер,
	|	МАКСИМУМ(ДанныеОснования.СуммаБезНДС) КАК Сумма,
	|	МАКСИМУМ(РАЗНОСТЬДАТ(НАЧАЛОПЕРИОДА(ДанныеОснования.Дата, ДЕНЬ), &НачалоТекущегоДня, ДЕНЬ)) КАК Срок,
	|	МАКСИМУМ(ДанныеОснования.ИсправлениеОшибок) КАК Исправление,
	|	МАКСИМУМ(ДанныеОснования.КорректировкаПоСогласованиюСторон) КАК Корректировка,
	|	МАКСИМУМ(ВЫБОР
	|		КОГДА ДанныеОснования.ИсправлениеОшибок
	|			ТОГДА &ТекстИсправлениеСчетФактуры
	|		КОГДА ДанныеОснования.КорректировкаПоСогласованиюСторон
	|			ТОГДА &ТекстКорректировкаСчетФактуры
	|		ИНАЧЕ &ТекстНовыйСчетФактура
	|	КОНЕЦ) КАК Действие,
	|	ТребуетсяОформлениеСчетаФактуры.Валюта КАК Валюта
	|ИЗ
	|	РегистрСведений.ТребуетсяОформлениеСчетаФактуры КАК ТребуетсяОформлениеСчетаФактуры
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеОснованийСчетовФактур КАК ДанныеОснования
	|		ПО ТребуетсяОформлениеСчетаФактуры.Основание = ДанныеОснования.Регистратор
	|		И ТребуетсяОформлениеСчетаФактуры.ТипСчетаФактуры = ДанныеОснования.ТипСчетаФактуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РеестрДокументов КАК РеестрДокументов
	|		ПО ТребуетсяОформлениеСчетаФактуры.Основание = РеестрДокументов.Ссылка
	|		И ТребуетсяОформлениеСчетаФактуры.Организация = РеестрДокументов.Организация
	|		И НЕ РеестрДокументов.ДополнительнаяЗапись
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеПервичныхДокументов КАК ДанныеПервичныхДокументов
	|		ПО ДанныеОснования.Регистратор = ДанныеПервичныхДокументов.Документ
	|		И ДанныеОснования.Организация = ДанныеПервичныхДокументов.Организация
	|ГДЕ
	|	ТребуетсяОформлениеСчетаФактуры.ТипСчетаФактуры = &ТипСчетаФактуры
	|СГРУППИРОВАТЬ ПО
	|	ТребуетсяОформлениеСчетаФактуры.Организация,
	|	ТребуетсяОформлениеСчетаФактуры.Контрагент,
	|	ТребуетсяОформлениеСчетаФактуры.Основание,
	|	ТИПЗНАЧЕНИЯ(ТребуетсяОформлениеСчетаФактуры.Основание),
	|	ТребуетсяОформлениеСчетаФактуры.Валюта
	|{ГДЕ
	|	ТребуетсяОформлениеСчетаФактуры.Организация.* КАК Организация,
	|	ТребуетсяОформлениеСчетаФактуры.Контрагент.* КАК Контрагент,
	|	ТребуетсяОформлениеСчетаФактуры.Валюта.* КАК Валюта,
	|	НАЧАЛОПЕРИОДА(ДанныеОснования.Дата, ДЕНЬ) КАК ДатаПродажи,
	|	ДанныеОснования.Договор.* КАК Договор,
	|	РеестрДокументов.Ответственный.* КАК Менеджер,
	|	ДанныеОснования.ИсправлениеОшибок КАК Исправление,
	|	ДанныеОснования.КорректировкаПоСогласованиюСторон КАК Корректировка}
	|";
	
	Возврат ТекстЗапроса;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСчетаФактурыВПути()
	
	СтруктураОтбора = Новый Структура("Контрагент,Организация", Контрагент, Организация);
	СчетаФактуры = Документы.СчетФактураПолученныйНалоговыйАгент.СчетаФактурыПоТоварамВПути(СтруктураОтбора);
	
	СчетаФактурыВПути.Загрузить(СчетаФактуры);
	СчетаФактурыВПутиКоличество = СчетаФактурыВПути.Количество();
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьДанныеДляЗаполненияСчетаФактуры()
	
	Результат = Новый Структура("МассивСсылок,ДанныеСтроки");
	Результат.Вставить("ЕстьОшибки", Ложь);
	
	ВыделенныеСтроки = Элементы.СписокСчетовФактурыНаОформление.ВыделенныеСтроки;
	
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Укажите документы-основания для формирования счета-фактуры.'"));
		
		Результат.ЕстьОшибки = Истина;
		Возврат Результат;
	КонецЕсли;
	
	МассивСсылок = Новый Массив;
	ПерваяСтрока = Истина;
	РезультатПроверки = Новый Структура("Организация, Контрагент, Валюта, Исправление, Корректировка");
	
	РазныеОрганизации = Ложь;
	РазныеКонтрагенты = Ложь;
	РазныеВалюты      = Ложь;
	РазныеТипы        = Ложь;
	
	Для Каждого ДокументПродажи Из ВыделенныеСтроки Цикл
		
		Если ТипЗнч(ДокументПродажи) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			Продолжить;
		КонецЕсли;
		
		ДанныеСтроки = Элементы.СписокСчетовФактурыНаОформление.ДанныеСтроки(ДокументПродажи);
		
		Если ПерваяСтрока Тогда
			ПерваяСтрока = Ложь;
			ЗаполнитьЗначенияСвойств(РезультатПроверки, ДанныеСтроки);
		Иначе
			РазныеОрганизации = РазныеОрганизации Или РезультатПроверки.Организация <> ДанныеСтроки.Организация;
			РазныеКонтрагенты = РазныеКонтрагенты Или РезультатПроверки.Контрагент <> ДанныеСтроки.Контрагент;
			РазныеВалюты      = РазныеВалюты Или РезультатПроверки.Валюта <> ДанныеСтроки.Валюта;
			РазныеТипы        = РазныеТипы Или РезультатПроверки.Исправление <> ДанныеСтроки.Исправление
			                     Или РезультатПроверки.Корректировка <> ДанныеСтроки.Корректировка;
		КонецЕсли;
		
		МассивСсылок.Добавить(ДанныеСтроки.Ссылка);
		
	КонецЦикла;
	
	ОчиститьСообщения();
	
	Если РазныеОрганизации Или РазныеКонтрагенты Или РазныеВалюты Или РазныеТипы Тогда
		
		ТекстСообщения = НСтр("ru='Реквизиты документов, на основании которых регистрируется счет-фактура, не совпадают:'")
			+ ?(РазныеОрганизации, Символы.ПС + НСтр("ru='- организация'"), "")
			+ ?(РазныеКонтрагенты, Символы.ПС + НСтр("ru='- контрагент'"), "")
			+ ?(РазныеВалюты, Символы.ПС + НСтр("ru='- валюта документа'"), "")
			+ ?(РазныеТипы, Символы.ПС + НСтр("ru='- реквизиты ""Исправление"", ""Корректировка""'"), "") + Символы.ПС 
			+ НСтр("ru='Необходимо изменить реквизиты документов-оснований или зарегистрировать по документам с расхождениями отдельные счета-фактуры.'");
			
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		
		Результат.ЕстьОшибки = Истина;
		Возврат Результат;
		
	КонецЕсли;
	
	Результат.МассивСсылок = МассивСсылок;
	Результат.ДанныеСтроки = ДанныеСтроки;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура СоздатьДокументыСчетФактура(Основания, ДополнительныеПараметры)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
	"Документ.СчетФактураПолученныйНалоговыйАгент.Форма.ФормаРабочееМесто.ЗарегистрироватьСчетФактуру");
	
	СтруктураЗаполнения = Новый Структура;
	Если Основания.Количество() = 1 Тогда
		СтруктураЗаполнения.Вставить("ДокументОснование", Основания[0]);
	Иначе
		СтруктураЗаполнения.Вставить("ДокументОснование", Основания);
	КонецЕсли;
	
	СтруктураЗаполнения.Вставить("Корректировочный", ДополнительныеПараметры.Корректировка);
	СтруктураЗаполнения.Вставить("Исправление",      ДополнительныеПараметры.Исправление);
	СтруктураЗаполнения.Вставить("Контрагент",       ДополнительныеПараметры.Контрагент);
	СтруктураЗаполнения.Вставить("Организация",      ДополнительныеПараметры.Организация);
	СтруктураЗаполнения.Вставить("Дата",             ДополнительныеПараметры.ДатаПродажи);
	
	ПараметрыФормы = Новый Структура("Основание", СтруктураЗаполнения);
	
	ОткрытьФорму("Документ.СчетФактураПолученныйНалоговыйАгент.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДокументыОснованияСчетаФактуры(Основания, СчетФактура)
	
	УчетНДСРФВызовСервера.ОтразитьПолучениеТовараСОбратнымОбложениемНДС(
		СчетФактура,
		Основания);
	
	ОткрытьФорму("Документ.СчетФактураПолученныйНалоговыйАгент.ФормаОбъекта",
		Новый Структура("Ключ", СчетФактура));
	
КонецПроцедуры

&НаКлиенте
Функция ТипыДокументовОснованийКОформлению()
	
	Возврат ТипыОснований.Типы();
	
КонецФункции

&НаСервереБезКонтекста
Функция ПараметрыЗапросаСчетаФактурыКОформлению()
	
	Параметры = Новый Структура;
	Параметры.Вставить("НачалоТекущегоДня", НачалоДня(ТекущаяДатаСеанса()));
	Параметры.Вставить("ТекстНовыйСчетФактура", НСтр("ru = 'Новый'"));
	Параметры.Вставить("ТекстИсправлениеСчетФактуры", НСтр("ru = 'Исправительный'"));
	Параметры.Вставить("ТекстКорректировкаСчетФактуры", НСтр("ru = 'Корректировочный'"));
	Параметры.Вставить("ТипСчетаФактуры", ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.СчетФактураПолученныйНалоговыйАгент"));
	
	Возврат Параметры;
	
КонецФункции

#КонецОбласти

#КонецОбласти
