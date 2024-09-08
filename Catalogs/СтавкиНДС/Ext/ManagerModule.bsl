﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Определяет настройки начального заполнения элементов
//
// Параметры:
//  Настройки - Структура - настройки заполнения:
//   * ПриНачальномЗаполненииЭлемента - Булево - Если Истина, то для каждого элемента будет
//      вызвана процедура индивидуального заполнения ПриНачальномЗаполненииЭлемента.
Процедура ПриНастройкеНачальногоЗаполненияЭлементов(Настройки) Экспорт
	
	Настройки.ПриНачальномЗаполненииЭлемента = Истина;
	
КонецПроцедуры

// Вызывается при начальном заполнении справочника.
//
// Параметры:
//  КодыЯзыков - Массив - список языков конфигурации. Актуально для мультиязычных конфигураций.
//  Элементы   - ТаблицаЗначений - данные заполнения. Состав колонок соответствует набору реквизитов
//                                 справочника.
//  ТабличныеЧасти - Структура - Ключ - Имя табличной части объекта.
//                               Значение - Выгрузка в таблицу значений пустой табличной части.
//
Процедура ПриНачальномЗаполненииЭлементов(КодыЯзыков, Элементы, ТабличныеЧасти) Экспорт
	
КонецПроцедуры

// Вызывается при начальном заполнении создаваемого элемента.
//
// Параметры:
//  Объект                  - СправочникОбъект.СтавкиНДС - заполняемый объект.
//  Данные                  - СтрокаТаблицыЗначений - данные заполнения.
//  ДополнительныеПараметры - Структура - Дополнительные параметры.
//
Процедура ПриНачальномЗаполненииЭлемента(Объект, Данные, ДополнительныеПараметры) Экспорт

КонецПроцедуры

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	УчетНДСУП.ПолучитьДанныеВыбораСтавкиНДС(ДанныеВыбора, Параметры, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецЕсли

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьКлиентСервер.ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьКлиентСервер.ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

Процедура СоздатьЭлементыПервоначальногоЗаполнения(ПервыйЗапуск = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	
	Попытка
		
		СтавкаБезНДССсылка = Справочники.СтавкиНДС.БезНДС;
		
		БлокировкаДанных = Новый БлокировкаДанных();
		ЭлементБлокировки = БлокировкаДанных.Добавить("Справочник.СтавкиНДС");
		ЭлементБлокировки.УстановитьЗначение("Ссылка", СтавкаБезНДССсылка);
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		БлокировкаДанных.Заблокировать();
		
		СтавкаБезНДСОбъект = СтавкаБезНДССсылка.ПолучитьОбъект();
		
		ОбщегоНазначения.УстановитьЗначениеРеквизита(СтавкаБезНДСОбъект, "Наименование", НСтр("ru = 'Без НДС'"));
		СтавкаБезНДСОбъект.Ставка = 0;
		
		СтавкаБезНДСОбъект.ТипыНалогообложенияНДС.Очистить();
		
		ТипНалогообложенияНДС = СтавкаБезНДСОбъект.ТипыНалогообложенияНДС.Добавить();
		ТипНалогообложенияНДС.ТипНалогообложенияНДС = Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС;
		
		ТипНалогообложенияНДС = СтавкаБезНДСОбъект.ТипыНалогообложенияНДС.Добавить();
		ТипНалогообложенияНДС.ТипНалогообложенияНДС = Перечисления.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС;
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(СтавкаБезНДСОбъект);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
	УчетНДСЛокализация.ЗаполнитьСправочникСтавкиНДС();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
