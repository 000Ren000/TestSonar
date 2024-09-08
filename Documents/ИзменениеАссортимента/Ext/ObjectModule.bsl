﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ АссортиментСервер.ВидыЦенИзмененияАссортиментаСоответствуютПравилам(ЭтотОбъект) Тогда
		Отказ = Истина;
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если НЕ ЗначениеЗаполнено(Этап) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Стадия");
	КонецЕсли;
	
	ИспользоватьФорматыМагазинов = ПолучитьФункциональнуюОпцию("ИспользоватьФорматыМагазинов");
	
	Если НЕ ЗначениеЗаполнено(ОбъектПланирования) 
		ИЛИ ИспользоватьФорматыМагазинов И ТипЗнч(ОбъектПланирования) = Тип("СправочникСсылка.Склады")
		ИЛИ НЕ ИспользоватьФорматыМагазинов И ТипЗнч(ОбъектПланирования) = Тип("СправочникСсылка.ФорматыМагазинов") Тогда
		
		ШаблонОшибкиОбъектаПланирования = НСтр("ru = 'Поле ""%ОбъектаПланирования%"" не заполнено'");
		Если ИспользоватьФорматыМагазинов Тогда
			ПредставлениеОбъектаПланирования = НСтр("ru = 'Формат магазина'");
		Иначе
			ПредставлениеОбъектаПланирования = НСтр("ru = 'Магазин/склад'");
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрЗаменить(ШаблонОшибкиОбъектаПланирования, "%ОбъектаПланирования%", ПредставлениеОбъектаПланирования),
			ЭтотОбъект,
			"ОбъектПланирования",
			,
			Отказ);
	
	КонецЕсли;
	
	Если Операция <> Перечисления.ОперацииИзмененияАссортимента.УправлениеКоллекцией Тогда
	
		МассивНепроверяемыхРеквизитов.Добавить("КоллекцияНоменклатуры");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаНачалаЗакупок");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаЗапретаЗакупки");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаНачалаПродаж");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаЗапретаПродажи");
	
	КонецЕсли; 
	
	Если Операция <> Перечисления.ОперацииИзмененияАссортимента.ИзменениеВАссортименте Тогда
	
		МассивНепроверяемыхРеквизитов.Добавить("Этап");
		МассивНепроверяемыхРеквизитов.Добавить("Стадия");
		
	КонецЕсли; 
	
	Если Операция = Перечисления.ОперацииИзмененияАссортимента.УправлениеКоллекцией Тогда
		Если ЗначениеЗаполнено(ДатаНачалаЗакупок) 
			И ЗначениеЗаполнено(ДатаЗапретаЗакупки) 
			И ДатаНачалаЗакупок = ДатаЗапретаЗакупки Тогда
		
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Период закупок должен быть больше одного дня.'"),
				ЭтотОбъект,
				"ДатаЗапретаЗакупки",
				,
				Отказ);
		
		КонецЕсли; 
		
		Если ЗначениеЗаполнено(ДатаНачалаПродаж) 
			И ЗначениеЗаполнено(ДатаЗапретаПродажи) 
			И ДатаНачалаПродаж = ДатаЗапретаПродажи Тогда
		
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Период продаж должен быть больше одного дня.'"),
				ЭтотОбъект,
				"ДатаЗапретаПродажи",
				,
				Отказ);
		
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ДатаНачалаЗакупок) 
			И ЗначениеЗаполнено(ДатаЗапретаЗакупки) 
			И ДатаНачалаЗакупок > ДатаЗапретаЗакупки Тогда
		
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Дата окончания закупок меньше чем дата начала.'"),
				ЭтотОбъект,
				"ДатаЗапретаЗакупки",
				,
				Отказ);
		
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ДатаНачалаПродаж) 
			И ЗначениеЗаполнено(ДатаЗапретаПродажи) 
			И ДатаНачалаПродаж > ДатаЗапретаПродажи Тогда
		
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Дата окончания продаж меньше чем дата начала.'"),
				ЭтотОбъект,
				"ДатаЗапретаПродажи",
				,
				Отказ);
		
		КонецЕсли;
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	Если ЭтоНовый() Тогда
		ИнициализироватьДокумент(ДанныеЗаполнения);
	КонецЕсли;
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Ответственный		 = ПользователиКлиентСервер.ТекущийПользователь();
	ДатаНачалаДействия	 = НачалоДня(ТекущаяДатаСеанса());
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	Если Операция = Перечисления.ОперацииИзмененияАссортимента.УправлениеКоллекцией Тогда
		
		Этап = Перечисления.ЭтапыИзмененияАссортимента.ПустаяСсылка();
		Стадия = Перечисления.СтадииАссортимента.ПустаяСсылка();
		
	Иначе
		КоллекцияНоменклатуры = Справочники.КоллекцииНоменклатуры.ПустаяСсылка();
		ДатаНачалаЗакупок = Неопределено;
		ДатаНачалаПродаж = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Параметры:
//    Таблица - см. УправлениеДоступом.ТаблицаНаборыЗначенийДоступа
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	// Логика ограничения следующая:
	// объект доступен, если доступны все виды цен.
	
	ВидыЦен = Товары.Выгрузить();
	ВидыЦен.Свернуть("ВидЦены");
	
	Для Каждого СтрокаТаблицы Из ВидыЦен Цикл
		
		Если Не ЗначениеЗаполнено(СтрокаТаблицы.ВидЦены) Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаТаб = Таблица.Добавить();
		СтрокаТаб.ЗначениеДоступа = СтрокаТаблицы.ВидЦены;
		
	КонецЦикла;
	
	Если Таблица.Количество() = 0 Тогда
		СтрокаТаб = Таблица.Добавить();
		СтрокаТаб.ЗначениеДоступа = Справочники.ВидыЦен.ПустаяСсылка();
	КонецЕсли;
	
КонецПроцедуры

// Инициализирует документ
//
Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Ответственный		 = Пользователи.ТекущийПользователь();
	ДатаНачалаДействия	 = НачалоДня(ТекущаяДатаСеанса());
	ОбъектПланирования	 = ЗначениеНастроекПовтИсп.ПолучитьОбъектПланированияПоУмолчанию(ОбъектПланирования);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли