﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет список выбора статуса, в зависимости от включенных опций
//
// Параметры:
//  ДанныеВыбора			 - СписокЗначений	 - заполняемый список значений
//  ИспользоватьСтатусЗакрыт - Булево			 - признак необходимости использования статуса "Закрыт".
//  ИспользоватьСтатусНаСогласовании - Булево	 - признак необходимости использования статуса "НаСогласовании".
//
Процедура ЗаполнитьСписокВыбора(ДанныеВыбора, ИспользоватьСтатусЗакрыт, ИспользоватьСтатусНаСогласовании) Экспорт
	
	ДанныеВыбора.Очистить();
	
	Если ИспользоватьСтатусНаСогласовании Тогда
		ДанныеВыбора.Добавить(Перечисления.СтатусыВнутреннихЗаказов.НаСогласовании);
	КонецЕсли;
	
	// Безусловные статусы
	ДанныеВыбора.Добавить(Перечисления.СтатусыВнутреннихЗаказов.КВыполнению);
	ДанныеВыбора.Добавить(Перечисления.СтатусыВнутреннихЗаказов.Закрыт);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
