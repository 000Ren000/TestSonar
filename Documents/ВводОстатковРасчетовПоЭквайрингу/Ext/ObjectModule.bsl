﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ИсправлениеДокументов.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ОбщегоНазначенияУТ.ЗаполнитьИдентификаторыДокумента(	ЭтотОбъект, "РасчетыПоЭквайрингу");

	ВводОстатковЛокализация.ВводОстатковРасчетовПоЭквайрингуПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	ВводОстатковЛокализация.ВводОстатковРасчетовПоЭквайрингуОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	ВводОстатковЛокализация.ВводОстатковРасчетовПоЭквайрингуОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Не ОтражатьВОперативномУчете 
		И Не ОтражатьВБУиНУ
		И Не ОтражатьВУУ Тогда
		
		ТекстСообщения = НСтр("ru='Операция должна отражаться в одном из учетов'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , 
			"Объект.ОтражатьВОперативномУчете", , Отказ);
		
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Не ОтражатьВОперативномУчете Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Валюта");
	КонецЕсли;
	
	ИсправлениеДокументов.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ВводОстатковЛокализация.ВводОстатковРасчетовПоЭквайрингуОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Ответственный = Пользователи.ТекущийПользователь();
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка." + Метаданные().Имя) Тогда
		
		ИсправлениеДокументов.ЗаполнитьИсправление(ЭтотОбъект, ДанныеЗаполнения);
		
	КонецЕсли;
	
	ВводОстатковЛокализация.ВводОстатковРасчетовПоЭквайрингуОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИсправлениеДокументов.ПриКопировании(ЭтотОбъект, ОбъектКопирования);
	
	ОбщегоНазначенияУТ.ОчиститьИдентификаторыДокумента(ЭтотОбъект, "РасчетыПоЭквайрингу");
	
	ВводОстатковЛокализация.ВводОстатковРасчетовПоЭквайрингуПриКопировании(ЭтотОбъект, ОбъектКопирования);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	ВводОстатковЛокализация.ВводОстатковРасчетовПоЭквайрингуПриЗаписи(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьДанныеЭквайринга() Экспорт

	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	РасчетыПоЭквайрингу.ТипДенежныхСредств,
	|	РасчетыПоЭквайрингу.Валюта,
	|	РасчетыПоЭквайрингу.ЭквайринговыйТерминал,
	|	РасчетыПоЭквайрингу.Договор КАК ДоговорЭквайринга,
	|	РасчетыПоЭквайрингу.ДатаПлатежа КАК ДатаПлатежа,
	|	(-РасчетыПоЭквайрингу.СуммаОстаток) КАК Сумма
	|ИЗ
	|	РегистрНакопления.РасчетыПоЭквайрингу.Остатки(, Организация = &Организация) КАК РасчетыПоЭквайрингу
	|ГДЕ
	|	РасчетыПоЭквайрингу.СуммаОстаток < 0
	|	И РасчетыПоЭквайрингу.ТипДенежныхСредств = ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредствПоЭквайрингу.ПоступлениеПоПлатежнойКарте)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	РасчетыПоЭквайрингу.ТипДенежныхСредств,
	|	РасчетыПоЭквайрингу.Валюта,
	|	РасчетыПоЭквайрингу.ЭквайринговыйТерминал,
	|	РасчетыПоЭквайрингу.Договор КАК ДоговорЭквайринга,
	|	РасчетыПоЭквайрингу.ДатаПлатежа КАК ДатаПлатежа,
	|	РасчетыПоЭквайрингу.СуммаОстаток КАК Сумма
	|ИЗ
	|	РегистрНакопления.РасчетыПоЭквайрингу.Остатки(, Организация = &Организация) КАК РасчетыПоЭквайрингу
	|ГДЕ
	|	РасчетыПоЭквайрингу.СуммаОстаток > 0
	|	И РасчетыПоЭквайрингу.ТипДенежныхСредств = ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредствПоЭквайрингу.СписаниеПоПлатежнойКарте)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаПлатежа
	|");

	Запрос.УстановитьПараметр("Организация", Организация);
	РасчетыПоЭквайрингу.Загрузить(Запрос.Выполнить().Выгрузить());

КонецПроцедуры

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Валюта) Тогда
		Валюта = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация);
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("ХозяйственнаяОперация") Тогда
			ХозяйственнаяОперация = ДанныеЗаполнения.ХозяйственнаяОперация;
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("Комментарий") Тогда
			Комментарий = ДанныеЗаполнения.Комментарий;
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("ЗначениеКопирования") Тогда
			ВводОстатковСервер.ЗаполнитьЗначенияПоСтаромуВводуОстатков(ЭтотОбъект, ДанныеЗаполнения.ЗначениеКопирования);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
