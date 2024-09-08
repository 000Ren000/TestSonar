﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если НЕ ЭтоГруппа И НЕ РасчетыВВалютеРеглУчета И НЕ РасчетыВВалюте Тогда
		РасчетыВВалютеРеглУчета = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если Отказ ИЛИ ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ВидРасчетовЗаполнен = Ложь;
	
	Если ДанныеЗаполнения <> Неопределено Тогда
		
		МассивВидовРасчетовДляУдаления = Новый Массив;
		
		Справочники.ГруппыФинансовогоУчетаРасчетов.ПреобразоватьОтборПараметровВыбора(ДанныеЗаполнения);
		ВидыРасчетов = Справочники.ГруппыФинансовогоУчетаРасчетов.ВидыРасчетов();
	
		Для каждого ВидРасчетов Из ВидыРасчетов Цикл
			ИспользоватьВидРасчетов = Ложь;
			Если ДанныеЗаполнения.Свойство(ВидРасчетов, ИспользоватьВидРасчетов) Тогда
				Если ИспользоватьВидРасчетов Тогда
					ВидРасчетовЗаполнен = Истина;
					Прервать;
				Иначе
					МассивВидовРасчетовДляУдаления.Добавить(ВидРасчетов);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		Если МассивВидовРасчетовДляУдаления.Количество() Тогда
			ДоступныеВидыРасчетов = ОбщегоНазначенияКлиентСервер.РазностьМассивов(ВидыРасчетов, МассивВидовРасчетовДляУдаления);
			Если ДоступныеВидыРасчетов.Количество() Тогда
				ЭтотОбъект[ДоступныеВидыРасчетов.Получить(0)] = Истина;
				ВидРасчетовЗаполнен = Истина;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ ЭтоГруппа И НЕ ВидРасчетовЗаполнен Тогда
		РасчетыСКлиентами = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли