﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Устанавливает статус для объекта документа
//
// Параметры:
//	НовыйСтатус - Строка - Имя статуса, который будет установлен у заказов
//	ДополнительныеПараметры - Структура - Структура дополнительных параметров установки статуса.
//
// Возвращаемое значение:
//	Булево - Истина, в случае успешной установки нового статуса.
//
Функция УстановитьСтатус(НовыйСтатус, ДополнительныеПараметры) Экспорт
	
	ЗначениеНовогоСтатуса = Перечисления.СтатусыПлановыхКорректировок[НовыйСтатус];
	
	Статус = ЗначениеНовогоСтатуса;
	
	Возврат ПроверитьЗаполнение();
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	ДокументПлан = Неопределено;
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		
		Если ДанныеЗаполнения.Свойство("Номенклатура") Тогда
			НоваяСтрока = УменьшениеПотребностей.Добавить();
			НоваяСтрока.Номенклатура = ДанныеЗаполнения.Номенклатура;
			НоваяСтрока.Характеристика = ДанныеЗаполнения.Характеристика;
			НоваяСтрока.Назначение = ДанныеЗаполнения.Назначение;
			НоваяСтрока.Количество = ДанныеЗаполнения.Количество;
		КонецЕсли;
		
		ДанныеЗаполнения.Свойство("План", ДокументПлан);
		
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ПланЗакупок")
		ИЛИ ТипДанныхЗаполнения = Тип("ДокументСсылка.ПланСборкиРазборки") Тогда
		
		ДокументПлан = ДанныеЗаполнения;
		
	КонецЕсли;
	
	Если ДокументПлан <> Неопределено Тогда
		ДокументРеквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументПлан, "Сценарий, ВидПлана, Ссылка, НачалоПериода");
		
		Сценарий = ДокументРеквизиты.Сценарий;
		ВидПлана = ДокументРеквизиты.ВидПлана;
		План = ДокументРеквизиты.Ссылка;
		Период = ДокументРеквизиты.НачалоПериода;
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ПараметрыПроверки = НоменклатураСервер.ПараметрыПроверкиЗаполненияКоличества();
	ПараметрыПроверки.ИмяТЧ = "УменьшениеПотребностей";
	ПараметрыПроверки.ПроверитьВозможностьОкругления = Ложь;
	НоменклатураСервер.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, ПараметрыПроверки);
	
	ПараметрыПроверки = НоменклатураСервер.ПараметрыПроверкиЗаполненияКоличества();
	ПараметрыПроверки.ИмяТЧ = "УвеличениеПотребностей";
	ПараметрыПроверки.ПроверитьВозможностьОкругления = Ложь;
	НоменклатураСервер.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, ПараметрыПроверки);
	
	ПараметрыПроверки = НоменклатураСервер.ПараметрыПроверкиЗаполненияХарактеристик();
	ПараметрыПроверки.ИмяТЧ = "УменьшениеПотребностей";
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ, ПараметрыПроверки);
	
	ПараметрыПроверки = НоменклатураСервер.ПараметрыПроверкиЗаполненияХарактеристик();
	ПараметрыПроверки.ИмяТЧ = "УвеличениеПотребностей";
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ, ПараметрыПроверки);

	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
	Если Не Отказ
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Сценарий,"УправлениеПроцессомПланирования") Тогда
		
		Планирование.ЗапускВыполненияФоновойПроверкиРасчетаДефицитаПоЭтапам(Сценарий, ВидПлана);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
	Если Не Отказ
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Сценарий,"УправлениеПроцессомПланирования") Тогда
		
		Планирование.ЗапускВыполненияФоновойПроверкиРасчетаДефицитаПоЭтапам(Сценарий, ВидПлана);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Ответственный			= ПользователиКлиентСервер.ТекущийПользователь();
	Дата					= ТекущаяДатаСеанса();
	Статус					= Перечисления.СтатусыПлановыхКорректировок.Утверждена;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
