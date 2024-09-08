﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	ВзаиморасчетыСервер.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ВзаиморасчетыСервер.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи);
	
	ВыборкаПодарочныхСертификатов_2_5 = ВыборкаПодарочныхСертификатов_2_5();
	СуммаДокумента = СуммыПоПодарочнымСертификатам_2_5(ВыборкаПодарочныхСертификатов_2_5);
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		ЗаполнитьОбъектРасчетов(ВыборкаПодарочныхСертификатов_2_5);
		
	Иначе
		
		Для Каждого СтрокаТЧ Из ПодарочныеСертификаты Цикл
			СтрокаТЧ.ОбъектРасчетов = Неопределено;
		КонецЦикла;
		
	КонецЕсли;
	
	ОбщегоНазначенияУТ.ЗаполнитьИдентификаторыДокумента(ЭтотОбъект, "ПодарочныеСертификаты");
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПодарочныеСертификатыСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИнициализироватьДокумент();
	
	ПодарочныеСертификаты.Очистить();
	
	ВзаиморасчетыСервер.ПриКопировании(ЭтотОбъект);
	
	ОбщегоНазначенияУТ.ОчиститьИдентификаторыДокумента(ЭтотОбъект, "ПодарочныеСертификаты");
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
	ТаблицаИзменений = УчетНДСУП.НоваяТаблицаИзмененийРасчетов();
	СтрокаИзменений = ТаблицаИзменений.Добавить();
	СтрокаИзменений.Документ = Ссылка;
	СтрокаИзменений.Период = Дата;
	УчетНДСУП.ОтразитьВУчетеНДСИзменениеРасчетовСКлиентами(ТаблицаИзменений);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВыборкаПодарочныхСертификатов_2_5()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПодарочныеСертификаты.НомерСтроки КАК НомерСтроки,
	|	ВЫРАЗИТЬ(ПодарочныеСертификаты.ПодарочныйСертификат КАК Справочник.ПодарочныеСертификаты) КАК ПодарочныйСертификат,
	|	ПодарочныеСертификаты.СуммаВВалютеСертификата КАК СуммаОстаток
	|ПОМЕСТИТЬ ТаблицаПодарочныеСертификаты
	|ИЗ
	|	&ПодарочныеСертификаты КАК ПодарочныеСертификаты
	|ГДЕ
	|	ПодарочныеСертификаты.СуммаВВалютеСертификата <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПодарочныеСертификаты.НомерСтроки КАК НомерСтроки,
	|	ПодарочныеСертификаты.ПодарочныйСертификат КАК ПодарочныйСертификат,
	|	ЕСТЬNULL(ОбъектыРасчетов.Ссылка, ЗНАЧЕНИЕ(Справочник.ОбъектыРасчетов.ПустаяСсылка)) КАК ОбъектРасчетов,
	|	ПодарочныеСертификаты.СуммаОстаток КАК СуммаОстаток
	|ИЗ
	|	ТаблицаПодарочныеСертификаты КАК ПодарочныеСертификаты
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОбъектыРасчетов КАК ОбъектыРасчетов
	|		ПО ПодарочныеСертификаты.ПодарочныйСертификат = ОбъектыРасчетов.Объект
	|			И НЕ ОбъектыРасчетов.ПометкаУдаления
	|ГДЕ
	|	ПодарочныеСертификаты.ПодарочныйСертификат.Владелец.УчетПодарочныхСертификатов2_5";
	Запрос.УстановитьПараметр("ПодарочныеСертификаты", ПодарочныеСертификаты.Выгрузить());
	
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено) Экспорт
	
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Менеджер    = Пользователи.ТекущийПользователь();
	Валюта      = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация);
	Автор       = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ЗаполнитьОбъектРасчетов(ВыборкаПодарочныхСертификатов_2_5)
	
	ВыборкаПодарочныхСертификатов_2_5.Сбросить();
	
	Пока ВыборкаПодарочныхСертификатов_2_5.Следующий() Цикл
		Индекс = ВыборкаПодарочныхСертификатов_2_5.НомерСтроки - 1;
		ПодарочныеСертификаты[Индекс].ОбъектРасчетов = ВыборкаПодарочныхСертификатов_2_5.ОбъектРасчетов;
	КонецЦикла;
	
КонецПроцедуры

Функция СуммыПоПодарочнымСертификатам_2_5(ВыборкаПодарочныхСертификатов_2_5)
	
	СуммыПоПодарочнымСертификатам_2_5 = 0;
	ВыборкаПодарочныхСертификатов_2_5.Сбросить();
	Пока ВыборкаПодарочныхСертификатов_2_5.Следующий() Цикл
		СуммыПоПодарочнымСертификатам_2_5 = СуммыПоПодарочнымСертификатам_2_5 + ВыборкаПодарочныхСертификатов_2_5.СуммаОстаток;
	КонецЦикла;
	
	Возврат СуммыПоПодарочнымСертификатам_2_5;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
