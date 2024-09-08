﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьВозможныеЗначенияДоговораЭквайринга();
	
	ИспользуемыеТипыДокументов = Новый Массив();
	ИспользуемыеТипыДокументов.Добавить(Тип("ДокументСсылка.ОтчетБанкаПоОперациямЭквайринга"));
	ИспользуемыеТипыДокументов.Добавить(Тип("ДокументСсылка.Сторно"));
	
	ЗаполнитьРеквизитыФормыПриСоздании();
	НастроитьКнопкиУправленияДокументами();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = Новый ОписаниеТипов(ИспользуемыеТипыДокументов);
	ПараметрыРазмещения.КоманднаяПанель = Элементы.СписокКоманднаяПанель;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	НавигационнаяСсылка = "e1cib/list/Документ.ОтчетБанкаПоОперациямЭквайринга";

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом
	
	Список.Параметры.УстановитьЗначениеПараметра("ТипСсылки",
		ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.ОтчетБанкаПоОперациямЭквайринга"));
		
	ОбщегоНазначенияУТ.ЗаменитьПолеСсылкаКонструкциейВыразитьПоТипамДокументов(Элементы.Список,
		ХозяйственныеОперацииИДокументы);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);
	
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Период = Настройки.Получить("Период");
	
	УстановитьВозможныеЗначенияДоговораЭквайринга();
	УстановитьОтборДинамическогоСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Проведение_Сторно"
			Или ИмяСобытия = "Запись_Сторно"
			Или ИмяСобытия = "Запись_ОтчетБанкаПоОперациямЭквайринга" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияОтборПриИзменении(Элемент)
	
	ОрганизацияОтборПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияОтборПриИзмененииНаСервере()
	
	УстановитьВозможныеЗначенияДоговораЭквайринга();
	УстановитьОтборДинамическогоСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорЭквайрингаОтборПриИзменении(Элемент)
	
	УстановитьОтборДинамическогоСписка();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбщегоНазначенияУТКлиент.ИзменитьЭлемент(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, ЭтоГруппа, Параметр)
	
	Если Копирование Тогда
		ОбщегоНазначенияУТКлиент.СкопироватьЭлемент(Элемент);
	Иначе
		СтруктураОтбор = Новый Структура;
		СтруктураОтбор.Вставить("Организация", Организация);
		СтруктураОтбор.Вставить("ДоговорЭквайринга", ДоговорЭквайринга);
		
		СтруктураПараметры = Новый Структура("Основание", СтруктураОтбор);
		ОткрытьФорму("Документ.ОтчетБанкаПоОперациямЭквайринга.ФормаОбъекта", СтруктураПараметры, Элементы.Список);
	КонецЕсли;
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ОбщегоНазначенияУТКлиент.ИзменитьЭлемент(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОтменаПроведения(Команда)
	
	ОбщегоНазначенияУТКлиент.ОтменаПроведения(Элементы.Список, Заголовок);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокСкопировать(Команда)
	
	ОбщегоНазначенияУТКлиент.СкопироватьЭлемент(Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПровести(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиДокументы(Элементы.Список, Заголовок);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокУстановитьСнятьПометкуУдаления(Команда)
	
	ОбщегоНазначенияУТКлиент.УстановитьПометкуУдаления(Элементы.Список, Заголовок);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	Отказ = Истина;
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

&НаСервере
Процедура УстановитьОтборПоПериоду()
	
	Список.Параметры.УстановитьЗначениеПараметра("НачалоПериода",
		Период.ДатаНачала);
	Список.Параметры.УстановитьЗначениеПараметра("КонецПериода", 
		Период.ДатаОкончания);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СоздатьДокумент(Команда)
	
	ЗначенияЗаполнения = Новый Структура("Организация, ДоговорЭквайринга", Организация, ДоговорЭквайринга);
	СтруктураПараметров = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	ОткрытьФорму("Документ.ОтчетБанкаПоОперациямЭквайринга.ФормаОбъекта", СтруктураПараметров);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВозможныеЗначенияДоговораЭквайринга()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДанныеСправочника.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ДоговорыЭквайринга КАК ДанныеСправочника
	|ГДЕ
	|	(ДанныеСправочника.Организация = &Организация ИЛИ &ОрганизацияНеЗаполнена)
	|	И (ДанныеСправочника.ДетальнаяСверкаТранзакций
	|		ИЛИ ДанныеСправочника.СпособОтраженияКомиссии = ЗНАЧЕНИЕ(Перечисление.СпособыОтраженияЭквайринговойКомиссии.ВОтчете))
	|");
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ОрганизацияНеЗаполнена", Не ЗначениеЗаполнено(Организация));
	
	Элементы.ДоговорЭквайрингаОтбор.СписокВыбора.ЗагрузитьЗначения(
		Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
	Если Элементы.ДоговорЭквайрингаОтбор.СписокВыбора.НайтиПоЗначению(ДоговорЭквайринга) = Неопределено Тогда
		ДоговорЭквайринга = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборДинамическогоСписка()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Организация",
		Организация,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(Организация));
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"ДоговорЭквайринга",
		ДоговорЭквайринга,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ДоговорЭквайринга));
		
	УстановитьОтборПоПериоду();
	
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

&НаСервере
Процедура ЗаполнитьРеквизитыФормыПриСоздании()
	
	ТаблицаЗначенийДоступно = Документы.ОтчетБанкаПоОперациямЭквайринга.ИнициализироватьХозяйственныеОперацииИДокументы(
		ХозяйственныеОперацииИДокументы.Выгрузить());
	
	ХозяйственныеОперацииИДокументы.Загрузить(ТаблицаЗначенийДоступно);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьКнопкиУправленияДокументами()
	
	СтруктураПараметров = ОбщегоНазначенияУТ.СтруктураПараметровНастройкиКнопокУправленияДокументами();
	СтруктураПараметров.Форма 												= ЭтотОбъект;
	СтруктураПараметров.ИмяГруппыСоздать 									= "СписокГруппаСоздатьГенерируемая";
	СтруктураПараметров.ИмяГруппыСоздатьКонтекст							= "";
	СтруктураПараметров.ИмяКнопкиСкопировать 								= "СписокСкопировать";
	СтруктураПараметров.ИмяКнопкиСкопироватьКонтекстноеМеню 				= "СписокКонтекстноеМенюСкопировать";
	СтруктураПараметров.ИмяКнопкиИзменить 									= "СписокИзменить";
	СтруктураПараметров.ИмяКнопкиИзменитьКонтекстноеМеню 					= "СписокКонтекстноеМенюИзменить";
	СтруктураПараметров.ИмяКнопкиПровести 									= "СписокПровести";
	СтруктураПараметров.ИмяКнопкиПровестиКонтекстноеМеню 					= "СписокКонтекстноеМенюПровести";
	СтруктураПараметров.ИмяКнопкиОтменаПроведения 							= "СписокОтменаПроведения";
	СтруктураПараметров.ИмяКнопкиОтменаПроведенияКонтекстноеМеню 			= "СписокКонтекстноеМенюОтменаПроведения";
	СтруктураПараметров.ИмяКнопкиУстановитьПометкуУдаления 					= "СписокУстановитьПометкуУдаления";
	СтруктураПараметров.ИмяКнопкиУстановитьПометкуУдаленияКонтекстноеМеню 	= "СписокКонтекстноеМенюУстановитьПометкуУдаления";
	
	ОбщегоНазначенияУТ.НастроитьКнопкиУправленияДокументами(СтруктураПараметров);
	
КонецПроцедуры

#КонецОбласти
