﻿// @strict-types


#Область ПрограммныйИнтерфейс

// Проверить и создать на сервере.
// 
// Параметры:
//  ТипЭПД - Тип
//  ПроверяемыеОбъекты - Массив из ДокументСсылка, ДокументОбъект.ЭлектроннаяТранспортнаяНакладная, ДокументОбъект.ЭлектронныйЗаказНаряд
// 
// Возвращаемое значение:
//  см. ОбменСГИСЭПДПереопределяемый.ПроверитьИСоздатьНаСервере
Функция ПроверитьИСоздатьНаСервере(ТипЭПД, ПроверяемыеОбъекты) Экспорт
	
	Возврат ОбменСГИСЭПДПереопределяемый.ПроверитьИСоздатьНаСервере(ТипЭПД, ПроверяемыеОбъекты);
	
КонецФункции

// Получает типы ЭПД
//
// Возвращаемое значение:
//  СписокЗначений из Строка
//
Функция ТипыДокументовЭПД() Экспорт
	
	Возврат ОбменСГИСЭПДПереопределяемый.ТипыДокументовЭПД();
	
КонецФункции
#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Код процедур и функций

#КонецОбласти
