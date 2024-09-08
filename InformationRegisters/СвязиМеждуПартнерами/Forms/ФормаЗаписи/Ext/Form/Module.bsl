﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Запись, ЭтотОбъект);

	Если НЕ ЗначениеЗаполнено(Запись.Автор)
	 ИЛИ ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		Запись.Автор = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	Если Параметры.Свойство("Партнер") Тогда
		Запись.ПервыйПартнер = Параметры.Партнер;
	КонецЕсли;
	
	ПартнерыИКонтрагенты.ЗаголовокРеквизитаВЗависимостиОтФОИспользоватьПартнеровКакКонтрагентов(
	               ЭтотОбъект, "Партнер1", НСтр("ru = 'Первый контрагент'"));
	ПартнерыИКонтрагенты.ЗаголовокРеквизитаВЗависимостиОтФОИспользоватьПартнеровКакКонтрагентов(
	               ЭтотОбъект, "Партнер2", НСтр("ru = 'Второй контрагент'"));
	ПартнерыИКонтрагенты.ЗаголовокРеквизитаВЗависимостиОтФОИспользоватьПартнеровКакКонтрагентов(
	               ЭтотОбъект, "", НСтр("ru = 'Связь между контрагентами'"));
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект)
	
	Если Запись.ПервыйПартнер = Запись.ВторойПартнер Тогда
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
			ТекстСообщения = НСтр("ru='Контрагенты, указанные в связи не должны совпадать.'");
		Иначе
			ТекстСообщения = НСтр("ru='Партнеры, указанные в связи не должны совпадать.'");
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		ТекстСообщения,
		,
		"ПервыйПартнер",, Отказ);
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти
