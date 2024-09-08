﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет условия продаж в документе списания товаров у хранителя.
//
// Параметры:
//	УсловияПродаж - Структура - Данные для заполнения.
//
Процедура ЗаполнитьУсловияПродаж(Знач УсловияПродаж) Экспорт
	
	Если УсловияПродаж = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НаправлениеДеятельности = УсловияПродаж.НаправлениеДеятельности;
	Если ЗначениеЗаполнено(УсловияПродаж.ВалютаВзаиморасчетов) Тогда
		Валюта = УсловияПродаж.ВалютаВзаиморасчетов;
	КонецЕсли;
	
	Если УсловияПродаж.Организация <> Организация
		И ЗначениеЗаполнено(УсловияПродаж.Организация) Тогда
		
		Организация = УсловияПродаж.Организация;
		
	КонецЕсли;
	
	Если Не УсловияПродаж.Типовое Тогда
		
		Если ЗначениеЗаполнено(УсловияПродаж.Контрагент)
			И УсловияПродаж.Контрагент <> Контрагент Тогда
			
			Контрагент = УсловияПродаж.Контрагент;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
	
	Договор = ПродажиСервер.ПолучитьДоговорПоУмолчанию(ЭтотОбъект,
														УсловияПродаж.ХозяйственнаяОперация,Валюта,,
														УсловияПродаж.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию);
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетДоходовПоНаправлениямДеятельности") Тогда
		НаправленияДеятельностиСервер.ЗаполнитьНаправлениеПоУмолчанию(НаправлениеДеятельности, Соглашение, Договор);
	КонецЕсли;
	
КонецПроцедуры

// Заполняет условия продаж по умолчанию в документе списания товаров у хранителя.
//
Процедура ЗаполнитьУсловияПродажПоУмолчанию() Экспорт
	
	ИспользоватьСоглашенияСКлиентами = ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами");
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОприходованиеИзлишковТоваровВПользуКомитента Тогда
		ХозяйственнаяОперацияДоговора = Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию;
	Иначе
		ХозяйственнаяОперацияДоговора = Перечисления.ХозяйственныеОперации.ПередачаНаХранениеСПравомПродажи;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Партнер)
		Или Не ИспользоватьСоглашенияСКлиентами Тогда
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("ВыбранноеСоглашение",   Соглашение);
		ПараметрыОтбора.Вставить("ПустаяСсылкаДокумента", Документы.ОприходованиеИзлишковТоваровУХранителя.ПустаяСсылка());
		ПараметрыОтбора.Вставить("ХозяйственныеОперации", ХозяйственнаяОперацияДоговора);
		
		УсловияПродажПоУмолчанию = ПродажиСервер.ПолучитьУсловияПродажПоУмолчанию(Партнер, ПараметрыОтбора);
		
		Если УсловияПродажПоУмолчанию <> Неопределено Тогда
			
			Если Не ИспользоватьСоглашенияСКлиентами
				Или (Соглашение <> УсловияПродажПоУмолчанию.Соглашение
					И ЗначениеЗаполнено(УсловияПродажПоУмолчанию.Соглашение)) Тогда
				
				Соглашение = УсловияПродажПоУмолчанию.Соглашение;
				
				ЗаполнитьУсловияПродаж(УсловияПродажПоУмолчанию);
				
			Иначе
				Соглашение = УсловияПродажПоУмолчанию.Соглашение;
				
				ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
				
				Договор = ПродажиСервер.ПолучитьДоговорПоУмолчанию(ЭтотОбъект, ХозяйственнаяОперацияДоговора);
			КонецЕсли;
			
		Иначе
			Соглашение = Неопределено;
			
			ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Заполняет условия продаж по соглашению в документе списания товаров у хранителя.
//
Процедура ЗаполнитьУсловияПродажПоСоглашению() Экспорт
	
	УсловияПродаж = ПродажиСервер.ПолучитьУсловияПродаж(Соглашение);
	
	ЗаполнитьУсловияПродаж(УсловияПродаж);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ОприходованиеИзлишковТоваровУХранителя);
	
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ);
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект, ПараметрыУказанияСерий, Отказ, МассивНепроверяемыхРеквизитов);
	
	Если ПолучитьФункциональнуюОпцию("ФормироватьВидыЗапасовПоПодразделениямМенеджерам") Тогда
		ПроверяемыеРеквизиты.Добавить("Подразделение");
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов.Добавить("Товары.НомерГТД");
	Если ПолучитьФункциональнуюОпцию("ЗапретитьПоступлениеТоваровБезНомеровГТД") Тогда
		ЗапасыСервер.ПроверитьЗаполнениеНомеровГТД(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
	// Выбор статей и аналитик.
	ПараметрыВыбораСтатейИАналитик = Документы.ОприходованиеИзлишковТоваровУХранителя.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты,
		ПараметрыВыбораСтатейИАналитик);
	
	Если Не Отказ
		И ОбщегоНазначенияУТ.ПроверитьЗаполнениеРеквизитовОбъекта(ЭтотОбъект, ПроверяемыеРеквизиты) Тогда
		
		Отказ = Истина;
		
	КонецЕсли;
	
	ЗатратыСервер.ПроверитьИспользованиеПартионногоУчета22(ЭтотОбъект, Дата, Отказ);
	
	ПродажиСервер.ПроверитьКорректностьЗаполненияДокументаПродажи(ЭтотОбъект, Отказ);
	
	ОприходованиеИзлишковТоваровУХранителяЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
	// Выбор статей и аналитик.
	ПараметрыВыбораСтатейИАналитик = Документы.ОприходованиеИзлишковТоваровУХранителя.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ОбработкаЗаполнения(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	ИнициализироватьДокумент();
	
	УсловияПродажПоУмолчанию = ПродажиСервер.ПолучитьУсловияПродажПоУмолчанию(
		Партнер,
		Новый Структура("ВыбранноеСоглашение, ПустаяСсылкаДокумента", 
		Соглашение,
		Документы.ОприходованиеИзлишковТоваровУХранителя.ПустаяСсылка()));
	
	Если УсловияПродажПоУмолчанию <> Неопределено Тогда
		Валюта = УсловияПродажПоУмолчанию.Валюта;
	КонецЕсли;
	
	ОтветственныеЛицаСервер.ОтветственныеЛицаДокументаОбработкаЗаполнения(Ссылка, ДанныеЗаполнения, СтандартнаяОбработка);
	ЗаполнениеОбъектовПоСтатистике.ЗаполнитьРеквизитыОбъекта(ЭтотОбъект, ДанныеЗаполнения);
	
	ОприходованиеИзлишковТоваровУХранителяЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Сумма = Товары.Итог("Сумма");
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ОприходованиеИзлишковТоваровУХранителя);
	
	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(ЭтотОбъект, ПараметрыУказанияСерий);
	
	ОбщегоНазначенияУТ.ЗаполнитьИдентификаторыДокумента(ЭтотОбъект, "Товары");
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		МестаУчета = РегистрыСведений.АналитикаУчетаНоменклатуры.МестаУчета(ХозяйственнаяОперация,
																			Договор,
																			Подразделение,
																			Партнер,
																			Договор);
		
		ИменаПолей = РегистрыСведений.АналитикаУчетаНоменклатуры.ИменаПолейКоллекцииПоУмолчанию();
		
		Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОприходованиеИзлишковТоваровВПользуКомитента Тогда
			ИменаПолей.Назначение = "";
		КонецЕсли;
		
		РегистрыСведений.АналитикаУчетаНоменклатуры.ЗаполнитьВКоллекции(Товары, МестаУчета, ИменаПолей);
		
		ЗаполнитьВидыЗапасовДокумента();
		
	КонецЕсли;
	
	Если ЭтоНовый()
		И Не ЗначениеЗаполнено(Номер) Тогда
		
		УстановитьНовыйНомер();
		
	КонецЕсли;
	
	
	// Выбор статей и аналитик.
	ПараметрыВыбораСтатейИАналитик = Документы.ОприходованиеИзлишковТоваровУХранителя.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ПередЗаписью(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	ОприходованиеИзлишковТоваровУХранителяЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
	ОприходованиеИзлишковТоваровУХранителяЛокализация.ПриЗаписи(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
	ОприходованиеИзлишковТоваровУХранителяЛокализация.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ДополнительныеСвойства.Вставить("ПараметрыЗаполненияВидовЗапасов", ЗапасыСервер.ПараметрыЗаполненияВидовЗапасов());
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
	ОприходованиеИзлишковТоваровУХранителяЛокализация.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИнициализироватьДокумент();
	
	ОприходованиеИзлишковТоваровУХранителяЛокализация.ПриКопировании(ЭтотОбъект, ОбъектКопирования);
	
	Автор = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент()
	
	Организация   = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Если Не ЗначениеЗаполнено(Валюта) Тогда
		Валюта = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация);
	КонецЕсли;
	Ответственный = Пользователи.ТекущийПользователь();
	Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Ответственный, Подразделение);
	
КонецПроцедуры

#КонецОбласти

#Область ВидыЗапасов

Процедура ЗаполнитьВидыЗапасовДокумента()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ТаблицаТоваров.ВидЗапасов КАК ВидЗапасов
	|ПОМЕСТИТЬ ВтИсходнаяТаблицаТоваров
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|ГДЕ
	|	ТаблицаТоваров.ВидЗапасов = ЗНАЧЕНИЕ(Справочник.ВидыЗапасов.ПустаяСсылка)
	|	ИЛИ &ПерезаполнитьВидыЗапасов
	|;
	|///////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА &Проведен
	|			ТОГДА ТаблицаТоваров.ВидЗапасов
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ВидыЗапасов.ПустаяСсылка)
	|	КОНЕЦ КАК ТекущийВидЗапасов,
	|	ЛОЖЬ КАК ЭтоВозвратнаяТара,
	|	&Организация КАК Организация,
	|	&ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.ПустаяСсылка) КАК ТипЗапасов,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
	|	ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка) КАК Контрагент,
	|	ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка) КАК Договор,
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК Валюта,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка) КАК НалогообложениеНДС,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка) КАК НалогообложениеОрганизации,
	|	НЕОПРЕДЕЛЕНО КАК ВладелецТовара,
	|	ЗНАЧЕНИЕ(Справочник.ВидыЦенПоставщиков.ПустаяСсылка) КАК ВидЦены
	|ПОМЕСТИТЬ ИсходнаяТаблицаТоваров
	|ИЗ
	|	ВтИсходнаяТаблицаТоваров КАК ТаблицаТоваров
	|;
	|///////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВтИсходнаяТаблицаТоваров
	|");
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ТаблицаТоваров", Товары.Выгрузить(, "НомерСтроки, Номенклатура, ВидЗапасов"));
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Проведен", Проведен);
	Запрос.УстановитьПараметр("ХозяйственнаяОперация", ХозяйственнаяОперация);
	
	ЗапасыСервер.ДополнитьВременныеТаблицыОбязательнымиКолонками(Запрос);
	ЗапасыСервер.ПроверитьНеобходимостьПерезаполненияВидовЗапасовДокумента(ЭтотОбъект, Запрос);
	
	Запрос.Выполнить();
	
	ЗапасыСервер.ЗаполнитьВидыЗапасовПоУмолчанию(МенеджерВременныхТаблиц, Товары);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
