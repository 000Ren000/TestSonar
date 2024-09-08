﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	// Пропускаем обработку, чтобы гарантировать получение формы объекта при передаче параметра "АвтоТест".
	Если ДанныеЗаполнения = "АвтоТест" Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	МассивНепроверяемыхРеквизитов.Добавить("БанковскийСчет");
	
	Если Не ЗначениеЗаполнено(БанковскийСчет) Тогда
		
		ТекстОшибки = НСтр("ru = 'Поле ""Банковский счет для зачисления"" не заполнено'");
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , "Объект.БанковскийСчет", , Отказ);
		
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов.Добавить("Партнер");
	
	Если Не ЗначениеЗаполнено(Партнер) Тогда
		
		ТекстОшибки = НСтр("ru = 'Поле ""Эквайер"" не заполнено'");
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , "Объект.Партнер", , Отказ);
		
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ИспользуютсяЭквайринговыеТерминалы = (СпособПроведенияПлатежа = Перечисления.СпособыПроведенияПлатежей.ЭквайринговыйТерминал);

	Если Не ФиксированнаяСтавкаКомиссии Тогда
		СтавкаКомиссии = 0;
	КонецЕсли;
	
	Если СпособОтраженияКомиссии = Перечисления.СпособыОтраженияЭквайринговойКомиссии.ВОтчете Тогда
		ВзимаетсяКомиссияПриВозврате = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли